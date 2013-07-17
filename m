Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32862 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab3GQMGA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 08:06:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tom <Bassai_Dai@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: implement ov3640 driver using subdev-api with omap3-isp
Date: Wed, 17 Jul 2013 14:06:44 +0200
Message-ID: <4492814.VvG9cMpqVU@avalon>
In-Reply-To: <loom.20130716T155926-399@post.gmane.org>
References: <loom.20130715T104602-373@post.gmane.org> <3305303.jznjHFUBkl@avalon> <loom.20130716T155926-399@post.gmane.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tom,

On Tuesday 16 July 2013 14:24:59 Tom wrote:
> Laurent Pinchart <laurent.pinchart <at> ideasonboard.com> writes:
> > On Monday 15 July 2013 09:23:19 Tom wrote:
> > > Hello,
> > > 
> > > I am working with a gumstix overo board connected with a e-con-systems
> > > camera module using a ov3640 camera sensor.
> > > 
> > > Along with the board I got a camera driver
> > > (https://github.com/scottellis/econ-cam-driver)
> > > which can be used with linux kernel 2.6.34, but I want to use the camera
> > > along with the linux kernel 3.5.
> > > 
> > > So I tried to implement the driver into the kernel sources by referring
> > > to a existing drivers like /driver/media/video/ov9640.c and
> > > /driver/media/video/mt9v032.c.
> > > 
> > > The old driver has an isp implementation integrated and it registers
> > > itself once as a video device. So the application which is going to use
> > > the camera sensor just needs to open the right video device and by
> > > calling ioctl the corresponding functions will be called.
> > > 
> > > By going through the linux 3.5 kernel sources I found out that the
> > > omap3-isp registers itself as an video-device and should support
> > > sensors using the v4l2-subdev interface.
> > > 
> > > So am I right when I think that I just need to add the ov3640 subdev to
> > > the isp_v4l2_subdevs_group in the board-overo.c file and then just open
> > > thevideo device of the isp to use it via application (ioctl)?
> > > 
> > > I read an article which told me that I need to use the
> > > v4l2_subdev_pad_ops to interact from isp with the ov3640 subdev, but it
> > > does not work. I don't know what I am doing wrong.
> > > 
> > > Is there already an implemenation of the ov3640 using subdev-api which I
> > > couldn't find or can someone give me a hint what I need to do to get the
> > > sensor with the isp working?
> > 
> > As a matter of fact there's one. You can't be blamed for not finding it,
> > as it was stored on my computer.
> > 
> > I've rebased the patches on top of the latest linuxtv master branch and
> > pushed the patches to
> > 
> > 	git://linuxtv.org/pinchartl/media.git sensors/ov3640
> > 
> > Two caveats:
> > 
> > - The rebased patches have been compile-tested only, I haven't had time to
> > test them on the hardware. One particular point that might break is the
> > use of the clock API as a replacement for the OMAP3 ISP .set_xclk()
> > callback. Any problem that may arise from this shouldn't be too difficult
> > to fix.
> > 
> > - The driver doesn't work in all resolutions and formats. This is really
> > work in progress that I haven't had time to finish. The code should be
> > relatively clean, but the lack of support from Omnivision killed the
> > schedule (which I've planned too optimistically I have to confess).
> > 
> > Fixes would be very welcome. I'd like to push this driver to mainline at
> > some point, I'd hate to waste the time I've spent on this.
> 
> Hello Laurent,
> 
> many thanks for the quick reply.
> 
> I'm still a beginner, so please excuse that I have to ask you once again
> just to understand the subdev-api and the isp exactly.

No worries. As long as people do a bit of research and read documentation by 
themselves beforehand, I'm happy to answer questions and share knowledge.

> Is the implementation within the board-overo.c file correct to use the isp
> along with your camera driver?
> 
> And would it be enough to just open the isp video device within my
> application or do I need to open the subdev-device, too when calling ioctl?

You will need to access the subdevs directly to configure the OMAP3 ISP 
pipeline before starting the video stream. This task can be performed directly 
in a custom application using the media controller and V4L2 subdevs userspace 
APIs, or using the media-ctl command line tool 
(http://git.ideasonboard.org/media-ctl.git). The topic has been discussed 
extensively before and information is available online, both in web pages or 
in the linux-media mailing list archives. I don't have exact URLs, so it would 
be nice if you could post a couple of pointers in reply to this thread after 
searching for information, to help future newcomers.

Once the pipeline is configured you can then capture video frames from the 
OMAP3 ISP output using the V4L2 API on the appropriate video node.

> Best Regards, Tom
> 
> 
> My Code Snippet board-overo.c:
> 
> #define LM3553_SLAVE_ADDRESS	0x53
> #define OV3640_I2C_ADDR		(0x78 >> 1)
> int omap3evm_ov3640_platform_data;
> int lm3553_platform_data;
> 
> static struct i2c_board_info omap3_i2c_boardinfo_ov3640 = {
> 		I2C_BOARD_INFO("ov3640", OV3640_I2C_ADDR),
> 		.platform_data = &omap3evm_ov3640_platform_data,
> };
> 
> static struct i2c_board_info omap3_i2c_boardinfo_lm3553 = {
> 		I2C_BOARD_INFO("lm3553",LM3553_SLAVE_ADDRESS),
> 		.platform_data = &lm3553_platform_data,
> };
> 
> static struct i2c_board_info mt9v032_i2c_device = {
> 	I2C_BOARD_INFO("mt9v032", MT9V032_I2C_ADDR),
> 	.platform_data = &mt9v032_platform_data,
> };
> 
> /*static struct isp_subdev_i2c_board_info mt9v032_subdevs[] = {
> 	{
> 		.board_info = &mt9v032_i2c_device,
> 		.i2c_adapter_id = MT9V032_I2C_BUS_NUM,
> 	},
> 	{ NULL, 0, },
> };*/
> 
> static struct isp_subdev_i2c_board_info overo_subdevs[] = {
> 	/*{
> 		.board_info = &mt9v032_i2c_device,
> 		.i2c_adapter_id = MT9V032_I2C_BUS_NUM,
> 	},*/
> 	{
> 		.board_info = &omap3_i2c_boardinfo_ov3640,
> 		.i2c_adapter_id = MT9V032_I2C_BUS_NUM,
> 	},
> 	{ NULL, 0, },
> };
> 
> static struct isp_v4l2_subdevs_group overo_camera_subdevs[] = {
> 	{
> 		//.subdevs = mt9v032_subdevs,
> 		.subdevs = overo_subdevs,
> 		.interface = ISP_INTERFACE_PARALLEL,
> 		.bus = {
> 				.parallel = {
> 					.data_lane_shift = 0,
> 					.clk_pol = 0,
> 					.bridge = ISPCTRL_PAR_BRIDGE_DISABLE,
> 				}
> 		},
> 	},
> 	{ NULL, 0, },
> };
> 
> static struct isp_platform_data overo_isp_platform_data = {

I had forgotten to update the ISP platform data in the patches available in my 
sensors/ov3640 branch. I've pushed the (still untested) updated code to my git 
tree. Only the "board-omap3beagle: Add support for the OV3640 sensor module" 
patch has been modified. You need to add

        .xclks = {
                [0] = {
                        .dev_id = "3-003c",
                },
        },

here. 3 should be the I2C bus number your sensor is connected to, and 003c 
should be the sensor I2C address. Please fix that if I got the bus number 
wrong.

> 	.subdevs = overo_camera_subdevs,
> };


> static int __init overo_camera_init(void)
> {
>        return omap3_init_camera(&overo_isp_platform_data);
> }

-- 
Regards,

Laurent Pinchart

