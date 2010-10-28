Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:36570 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758771Ab0J1Xa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 19:30:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: New media framework user space usage
Date: Fri, 29 Oct 2010 01:31:25 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com>
In-Reply-To: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010290131.25828.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Thursday 28 October 2010 16:38:01 Bastian Hecht wrote:
> Hello Laurent,
> 
> my mt9p031 camera project for the omap3530 isp has come to the point
> where the ISP registered video[0-6], media0 and v4l-subdev[0-7].
> 
> As far as I can see from the names...
> 
> cat /sys/class/video4linux/video*/names
> OMAP3 ISP CCP2 input
> OMAP3 ISP CSI2a output
> OMAP3 ISP CCDC output
> OMAP3 ISP preview input
> OMAP3 ISP preview output
> OMAP3 ISP resizer input
> OMAP3 ISP resizer output
> 
> cat /sys/class/video4linux/v4l-subdev*/names
> OMAP3 ISP CCP2
> OMAP3 ISP CSI2a
> OMAP3 ISP CCDC
> OMAP3 ISP preview
> OMAP3 ISP resizer
> OMAP3 ISP AEWB
> OMAP3 ISP AF
> OMAP3 ISP histogram

That's nice, but you seem to be missing a sensor sub-device. See below.

> ... I want to read /dev/video2 (CCDC).
> 
> When I try out a little test program from the V4L2 doc, this line fails:
>       ioctl (fd, VIDIOC_G_STD, &std_id)

The VIDIOC_G_STD ioctl isn't implemented. Just skip that.

> So far I adopted your mt9t001 driver, merged it with Guennadis mt9p031. It
> contains lot of stubs that I want to fill out when I succeed to make them
> called inside the kernel.
> I looked at your presentation for the media controller and wonder if I have
> to set up a pipeline by myself before I can read /dev/video2
> (http://linuxtv.org/downloads/presentations/summit_jun_2010/20100614-
v4l2_summit-media.pdf).
> I failed at the point where I wanted to try out the little snippet on page
> 17 as I don't have definitions of the MEDIA_IOC_ENUM_ENTITIES. Are there
> somewhere userspace headers available?

Yes, in include/linux/media.h.

> int fd;
> fd = open(“/dev/media0”, O_RDWR);
> while (1) {
>  struct media_user_entity entity;
>  struct media_user_links links;
>  ret = ioctl(fd, MEDIA_IOC_ENUM_ENTITIES, &entity);
>  if (ret < 0)
>  break;
>  while (1) {
>  ret = ioctl(fd, MEDIA_IOC_ENUM_LINKS, &links);
>  if (ret < 0)
>  break;
> }

The structure names have changed, you should now use media_entity and 
media_links instead of media_user_entity and media_user_links.

You can have a look at http://git.ideasonboard.org/?p=media-ctl.git;a=summary 
(new-api branch) to see how links are configured.

[snip]

> static int mt9p031_probe(struct i2c_client *client,
> 			 const struct i2c_device_id *did)
> {
> 	struct mt9p031 *mt9p031;
> 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> 	int ret;
> 
> 
> 
> 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> 		dev_warn(&adapter->dev,
> 			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> 		return -EIO;
> 	}
> 
> 	mt9p031 = kzalloc(sizeof(struct mt9p031), GFP_KERNEL);
> 	if (!mt9p031)
> 		return -ENOMEM;
> 
> 	v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);

Add

mt9p031->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;

here to create a subdev node for the sensor.

[snip]

-- 
Regards,

Laurent Pinchart
