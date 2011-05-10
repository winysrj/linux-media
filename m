Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43824 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab1EJJbW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2011 05:31:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: Current status report of mt9p031.
Date: Tue, 10 May 2011 11:32:10 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris Rodley <carlighting@yahoo.co.nz>
References: <BANLkTi=pS07RymXLOFsRihd5Jso-y6OsHg@mail.gmail.com> <201105051855.32405.laurent.pinchart@ideasonboard.com> <BANLkTimhvxzn0cfZdAMYq=3Eg72eKgFx8Q@mail.gmail.com>
In-Reply-To: <BANLkTimhvxzn0cfZdAMYq=3Eg72eKgFx8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105101132.11041.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Javier,

On Tuesday 10 May 2011 09:31:02 javier Martin wrote:
> On 5 May 2011 18:55, Laurent Pinchart <laurent.pinchart@ideasonboard.com> 
wrote:
> > Hi Javier,
> > 
> > Here's the review of 0002-mt9p031.patch.
> 
> [snip]
> 
> >> +static int mt9p031_probe(struct i2c_client *client,
> >> +                      const struct i2c_device_id *did)
> >> +{
> >> +     struct mt9p031 *mt9p031;
> >> +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
> >> +     struct mt9p031_platform_data *pdata = client->dev.platform_data;
> >> +     struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> >> +     int ret;
> >> +
> >> +     if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> >> +             dev_warn(&adapter->dev,
> >> +                      "I2C-Adapter doesn't support
> >> I2C_FUNC_SMBUS_WORD\n"); +             return -EIO;
> >> +     }
> >> +
> >> +     mt9p031 = kzalloc(sizeof(struct mt9p031), GFP_KERNEL);
> >> +     if (!mt9p031)
> >> +             return -ENOMEM;
> >> +
> >> +     v4l2_i2c_subdev_init(&mt9p031->subdev, client,
> >> &mt9p031_subdev_ops); +
> >> +//       struct isp_device *isp =
> >> v4l2_dev_to_isp_device(subdev->v4l2_dev); +//       isp_set_xclk(isp,
> >> 16*1000*1000, ISP_XCLK_A);
> >> +
> >> +     mt9p031->rect.left      = 0/*MT9P031_COLUMN_SKIP*/;
> >> +     mt9p031->rect.top       = 0/*MT9P031_ROW_SKIP*/;
> >> +     mt9p031->rect.width     = MT9P031_MAX_WIDTH;
> >> +     mt9p031->rect.height    = MT9P031_MAX_HEIGHT;
> >> +
> >> +     switch (pdata->data_shift) {
> >> +     case 2:
> >> +             mt9p031->format.code = V4L2_MBUS_FMT_SGRBG8_1X8;
> >> +             break;
> >> +     case 1:
> >> +             mt9p031->format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
> >> +             break;
> >> +     case 0:
> >> +             mt9p031->format.code = V4L2_MBUS_FMT_SBGGR12_1X12;
> >> +     }
> > 
> > Why ? The sensor produces 12-bit data, you shouldn't fake other data
> > widths.
> 
> Hi Laurent,
> I was fixing all the issues you have pointed out when I ran into this.
> 
> It is true that mt9p031 produces 12-bit data only. However, when
> connected to omap3isp it is possible to discard 4 least significant
> bits (i.e. changing V4L2_MBUS_FMT_SGRBG12_1X12 into
> V4L2_MBUS_FMT_SGRBG8_1X8).
> The point is, if I just force  "mt9p031->format.code =
> V4L2_MBUS_FMT_SGRBG12_1X12;" then the following test will fail:
> 
> ./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> ./media-ctl -f '"mt9p031 2-0048":0[SGRBG8 320x240], "OMAP3 ISP
> CCDC":1[SGRBG8 320x240]'
> Unable to set format: Invalid argument (-22) --->
> v4l2_subdev_set_format() fails which is quite logical since that
> format is now not defined in mt9p031.c
>
> And this test will fail too:
> ./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> ./media-ctl -f '"mt9p031 2-0048":0[SGRBG8 320x240], "OMAP3 ISP
> CCDC":1[SGRBG8 320x240]'
> ./yavta --stdout -f SGRBG8 -s 320x240 -n 4 --capture=100 --skip 3 -F
> `./media-ctl -e "OMAP3 ISP CCDC output"` | nc 192.168.0.42 3000
> Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
> Video format set: width: 320 height: 240 buffer size: 76800
> Video format: GRBG (47425247) 320x240
> 4 buffers requested.
> length: 76800 offset: 0
> Buffer 0 mapped at address 0x40133000.
> length: 76800 offset: 77824
> Buffer 1 mapped at address 0x401e3000.
> length: 76800 offset: 155648
> Buffer 2 mapped at address 0x4021e000.
> length: 76800 offset: 233472
> Buffer 3 mapped at address 0x40368000.
> Unable to start streaming: 22. ---> ioctl(VIDIOC_STREAMON) fails
> 
> What is the clean way of doing this?

Please try replacing the media-ctl -f line with

./media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], \
	"OMAP3 ISP CCDC":0[SGRBG8 320x240], \
	"OMAP3 ISP CCDC":1[SGRBG8 320x240]'

-- 
Regards,

Laurent Pinchart
