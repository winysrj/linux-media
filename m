Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43102 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758630Ab3IBOJv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Sep 2013 10:09:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VGUpA-00016J-3V
	for linux-media@vger.kernel.org; Mon, 02 Sep 2013 16:09:48 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 02 Sep 2013 16:09:48 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 02 Sep 2013 16:09:48 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: Re: implement ov3640 driver using subdev-api with omap3-isp
Date: Mon, 2 Sep 2013 14:09:28 +0000 (UTC)
Message-ID: <loom.20130902T155555-717@post.gmane.org>
References: <loom.20130715T104602-373@post.gmane.org> <3305303.jznjHFUBkl@avalon> <loom.20130716T155926-399@post.gmane.org> <4492814.VvG9cMpqVU@avalon> <loom.20130731T145356-176@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

> Laurent Pinchart <laurent.pinchart <at> ideasonboard.com> writes:
> 
> > 
> > Hi Tom,
> > 
> > On Tuesday 16 July 2013 14:24:59 Tom wrote:
> > > Laurent Pinchart <laurent.pinchart <at> ideasonboard.com> writes:
> > > > On Monday 15 July 2013 09:23:19 Tom wrote:
> > > > > Hello,
> > > > > 
> > > > > I am working with a gumstix overo board connected with a e-con-systems
> > > > > camera module using a ov3640 camera sensor.
> > > > > 
> > > > > Along with the board I got a camera driver
> > > > > (https://github.com/scottellis/econ-cam-driver)
> > > > > which can be used with linux kernel 2.6.34, but I want to use the
camera
> > > > > along with the linux kernel 3.5.
> > > > > 
> > > > > So I tried to implement the driver into the kernel sources by
referring
> > > > > to a existing drivers like /driver/media/video/ov9640.c and
> > > > > /driver/media/video/mt9v032.c.
> > > > > 
> > > > > The old driver has an isp implementation integrated and it registers
> > > > > itself once as a video device. So the application which is going
to use
> > > > > the camera sensor just needs to open the right video device and by
> > > > > calling ioctl the corresponding functions will be called.
> > > > > 
> > > > > By going through the linux 3.5 kernel sources I found out that the
> > > > > omap3-isp registers itself as an video-device and should support
> > > > > sensors using the v4l2-subdev interface.
> > > > > 
> > > > > So am I right when I think that I just need to add the ov3640
subdev to
> > > > > the isp_v4l2_subdevs_group in the board-overo.c file and then just
open
> > > > > thevideo device of the isp to use it via application (ioctl)?
> > > > > 
> > > > > I read an article which told me that I need to use the
> > > > > v4l2_subdev_pad_ops to interact from isp with the ov3640 subdev,
but it
> > > > > does not work. I don't know what I am doing wrong.
> > > > > 
> > > > > Is there already an implemenation of the ov3640 using subdev-api
which I
> > > > > couldn't find or can someone give me a hint what I need to do to
get the
> > > > > sensor with the isp working?
> > > > 
> > > > As a matter of fact there's one. You can't be blamed for not finding it,
> > > > as it was stored on my computer.
> > > > 
> > > > I've rebased the patches on top of the latest linuxtv master branch and
> > > > pushed the patches to
> > > > 
> > > > 	git://linuxtv.org/pinchartl/media.git sensors/ov3640
> > > > 
> > > > Two caveats:
> > > > 
> > > > - The rebased patches have been compile-tested only, I haven't had
time to
> > > > test them on the hardware. One particular point that might break is the
> > > > use of the clock API as a replacement for the OMAP3 ISP .set_xclk()
> > > > callback. Any problem that may arise from this shouldn't be too
difficult
> > > > to fix.
> > > > 
> > > > - The driver doesn't work in all resolutions and formats. This is really
> > > > work in progress that I haven't had time to finish. The code should be
> > > > relatively clean, but the lack of support from Omnivision killed the
> > > > schedule (which I've planned too optimistically I have to confess).
> > > > 
> > > > Fixes would be very welcome. I'd like to push this driver to mainline at
> > > > some point, I'd hate to waste the time I've spent on this.
> > > 
> > > Hello Laurent,
> > > 
> > > many thanks for the quick reply.
> > > 
> > > I'm still a beginner, so please excuse that I have to ask you once again
> > > just to understand the subdev-api and the isp exactly.
> > 
> > No worries. As long as people do a bit of research and read
documentation by 
> > themselves beforehand, I'm happy to answer questions and share knowledge.
> > 
> > > Is the implementation within the board-overo.c file correct to use the isp
> > > along with your camera driver?
> > > 
> > > And would it be enough to just open the isp video device within my
> > > application or do I need to open the subdev-device, too when calling
ioctl?
> > 
> > You will need to access the subdevs directly to configure the OMAP3 ISP 
> > pipeline before starting the video stream. This task can be performed
> directly 
> > in a custom application using the media controller and V4L2 subdevs
userspace 
> > APIs, or using the media-ctl command line tool 
> > (http://git.ideasonboard.org/media-ctl.git). The topic has been discussed 
> > extensively before and information is available online, both in web
pages or 
> > in the linux-media mailing list archives. I don't have exact URLs, so it
> would 
> > be nice if you could post a couple of pointers in reply to this thread
after 
> > searching for information, to help future newcomers.
> > 
> > Once the pipeline is configured you can then capture video frames from the 
> > OMAP3 ISP output using the V4L2 API on the appropriate video node.
> > 
> > > Best Regards, Tom
> > > 
> > > 
> > > My Code Snippet board-overo.c:
> > > 
> > > #define LM3553_SLAVE_ADDRESS	0x53
> > > #define OV3640_I2C_ADDR		(0x78 >> 1)
> > > int omap3evm_ov3640_platform_data;
> > > int lm3553_platform_data;
> > > 
> > > static struct i2c_board_info omap3_i2c_boardinfo_ov3640 = {
> > > 		I2C_BOARD_INFO("ov3640", OV3640_I2C_ADDR),
> > > 		.platform_data = &omap3evm_ov3640_platform_data,
> > > };
> > > 
> > > static struct i2c_board_info omap3_i2c_boardinfo_lm3553 = {
> > > 		I2C_BOARD_INFO("lm3553",LM3553_SLAVE_ADDRESS),
> > > 		.platform_data = &lm3553_platform_data,
> > > };
> > > 
> > > static struct i2c_board_info mt9v032_i2c_device = {
> > > 	I2C_BOARD_INFO("mt9v032", MT9V032_I2C_ADDR),
> > > 	.platform_data = &mt9v032_platform_data,
> > > };
> > > 
> > > /*static struct isp_subdev_i2c_board_info mt9v032_subdevs[] = {
> > > 	{
> > > 		.board_info = &mt9v032_i2c_device,
> > > 		.i2c_adapter_id = MT9V032_I2C_BUS_NUM,
> > > 	},
> > > 	{ NULL, 0, },
> > > };*/
> > > 
> > > static struct isp_subdev_i2c_board_info overo_subdevs[] = {
> > > 	/*{
> > > 		.board_info = &mt9v032_i2c_device,
> > > 		.i2c_adapter_id = MT9V032_I2C_BUS_NUM,
> > > 	},*/
> > > 	{
> > > 		.board_info = &omap3_i2c_boardinfo_ov3640,
> > > 		.i2c_adapter_id = MT9V032_I2C_BUS_NUM,
> > > 	},
> > > 	{ NULL, 0, },
> > > };
> > > 
> > > static struct isp_v4l2_subdevs_group overo_camera_subdevs[] = {
> > > 	{
> > > 		//.subdevs = mt9v032_subdevs,
> > > 		.subdevs = overo_subdevs,
> > > 		.interface = ISP_INTERFACE_PARALLEL,
> > > 		.bus = {
> > > 				.parallel = {
> > > 					.data_lane_shift = 0,
> > > 					.clk_pol = 0,
> > > 					.bridge = ISPCTRL_PAR_BRIDGE_DISABLE,
> > > 				}
> > > 		},
> > > 	},
> > > 	{ NULL, 0, },
> > > };
> > > 
> > > static struct isp_platform_data overo_isp_platform_data = {
> > 
> > I had forgotten to update the ISP platform data in the patches available
> in my 
> > sensors/ov3640 branch. I've pushed the (still untested) updated code to my
> git 
> > tree. Only the "board-omap3beagle: Add support for the OV3640 sensor
module" 
> > patch has been modified. You need to add
> > 
> >         .xclks = {
> >                 [0] = {
> >                         .dev_id = "3-003c",
> >                 },
> >         },
> > 
> > here. 3 should be the I2C bus number your sensor is connected to, and 003c 
> > should be the sensor I2C address. Please fix that if I got the bus number 
> > wrong.
> > 
> > > 	.subdevs = overo_camera_subdevs,
> > > };
> > 
> > > static int __init overo_camera_init(void)
> > > {
> > >        return omap3_init_camera(&overo_isp_platform_data);
> > > }
> > 

Would you please help me out again? I tried to test the ov3640 driver along
with your test tools media-ctl and yavta, but I got no luck. 

what I did with media-ctl:

root@overo2:~/media_test/bin# sudo ./media-ctl -p -v -r -l '"ov3640
3-003c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC
output":0[1]'
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Media controller API version 0.0.0

Media device information
------------------------
driver          omap3isp
model           TI OMAP3 ISP
serial          
bus info        
hw revision     0xf0
driver version  0.0.0

Device topology
- entity 1: OMAP3 ISP CCP2 (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev0
    pad0: Sink
        [fmt:SGRBG10/4096x4096]
        <- "OMAP3 ISP CCP2 input":0 []
    pad1: Source
        [fmt:SGRBG10/4096x4096]
        -> "OMAP3 ISP CCDC":0 []

- entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
    pad0: Source
        -> "OMAP3 ISP CCP2":0 []

- entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev1
    pad0: Sink
        [fmt:SGRBG10/4096x4096]
    pad1: Source
        [fmt:SGRBG10/4096x4096]
        -> "OMAP3 ISP CSI2a output":0 []
        -> "OMAP3 ISP CCDC":0 []

- entity 4: OMAP3 ISP CSI2a output (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video1
    pad0: Sink
        <- "OMAP3 ISP CSI2a":1 []

- entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev2
    pad0: Sink
        [fmt:SBGGR10/640x480]
        <- "OMAP3 ISP CCP2":1 []
        <- "OMAP3 ISP CSI2a":1 []
        <- "ov3640 3-003c":0 [ENABLED]
    pad1: Source
        [fmt:SBGGR10/640x480
         crop.bounds:(0,0)/640x480
         crop:(0,0)/640x480]
        -> "OMAP3 ISP CCDC output":0 [ENABLED]
        -> "OMAP3 ISP resizer":0 []
    pad2: Source
        [fmt:SBGGR10/640x479]
        -> "OMAP3 ISP preview":0 []
        -> "OMAP3 ISP AEWB":0 [ENABLED,IMMUTABLE]
        -> "OMAP3 ISP AF":0 [ENABLED,IMMUTABLE]
        -> "OMAP3 ISP histogram":0 [ENABLED,IMMUTABLE]

- entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video2
    pad0: Sink
        <- "OMAP3 ISP CCDC":1 [ENABLED]

- entity 7: OMAP3 ISP preview (2 pads, 4 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev3
    pad0: Sink
        [fmt:SGRBG10/4096x4096
         crop.bounds:(8,4)/4082x4088
         crop:(8,4)/4082x4088]
        <- "OMAP3 ISP CCDC":2 []
        <- "OMAP3 ISP preview input":0 []
    pad1: Source
        [fmt:YUYV/4082x4088]
        -> "OMAP3 ISP preview output":0 []
        -> "OMAP3 ISP resizer":0 []

- entity 8: OMAP3 ISP preview input (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video3
    pad0: Source
        -> "OMAP3 ISP preview":0 []

- entity 9: OMAP3 ISP preview output (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video4
    pad0: Sink
        <- "OMAP3 ISP preview":1 []

- entity 10: OMAP3 ISP resizer (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev4
    pad0: Sink
        [fmt:YUYV/4095x4095
         crop.bounds:(4,6)/4086x4082
         crop:(4,6)/4086x4082]
        <- "OMAP3 ISP CCDC":1 []
        <- "OMAP3 ISP preview":1 []
        <- "OMAP3 ISP resizer input":0 []
    pad1: Source
        [fmt:YUYV/4096x4095]
        -> "OMAP3 ISP resizer output":0 []

- entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video5
    pad0: Source
        -> "OMAP3 ISP resizer":0 []

- entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video6
    pad0: Sink
        <- "OMAP3 ISP resizer":1 []

- entity 13: OMAP3 ISP AEWB (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev5
    pad0: Sink
        <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 14: OMAP3 ISP AF (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev6
    pad0: Sink
        <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 15: OMAP3 ISP histogram (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev7
    pad0: Sink
        <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 16: ov3640 3-003c (1 pad, 1 link)
             type V4L2 subdev subtype Sensor flags 0
             device node name /dev/v4l-subdev8
    pad0: Source
        [fmt:SBGGR10/640x480
         crop:(32,20)/640x480]
        -> "OMAP3 ISP CCDC":0 [ENABLED]


Resetting all links to inactive
Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]

Then I did:

root@overo2:~/media_test/bin# sudo ./media-ctl -p -v -V '"ov3640 3-003c":0
[SBGGR10 640x480 (32,20)/640x480], "OMAP3 ISP CCDC":1 [SBGGR10 640x480]'
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Media controller API version 0.0.0

Media device information
------------------------
driver          omap3isp
model           TI OMAP3 ISP
serial          
bus info        
hw revision     0xf0
driver version  0.0.0

Device topology
- entity 1: OMAP3 ISP CCP2 (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev0
    pad0: Sink
        [fmt:SGRBG10/4096x4096]
        <- "OMAP3 ISP CCP2 input":0 []
    pad1: Source
        [fmt:SGRBG10/4096x4096]
        -> "OMAP3 ISP CCDC":0 []

- entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
    pad0: Source
        -> "OMAP3 ISP CCP2":0 []

- entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev1
    pad0: Sink
        [fmt:SGRBG10/4096x4096]
    pad1: Source
        [fmt:SGRBG10/4096x4096]
        -> "OMAP3 ISP CSI2a output":0 []
        -> "OMAP3 ISP CCDC":0 []

- entity 4: OMAP3 ISP CSI2a output (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video1
    pad0: Sink
        <- "OMAP3 ISP CSI2a":1 []

- entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev2
    pad0: Sink
        [fmt:SBGGR10/640x480]
        <- "OMAP3 ISP CCP2":1 []
        <- "OMAP3 ISP CSI2a":1 []
        <- "ov3640 3-003c":0 [ENABLED]
    pad1: Source
        [fmt:SBGGR10/640x480
         crop.bounds:(0,0)/640x480
         crop:(0,0)/640x480]
        -> "OMAP3 ISP CCDC output":0 [ENABLED]
        -> "OMAP3 ISP resizer":0 []
    pad2: Source
        [fmt:SBGGR10/640x479]
        -> "OMAP3 ISP preview":0 []
        -> "OMAP3 ISP AEWB":0 [ENABLED,IMMUTABLE]
        -> "OMAP3 ISP AF":0 [ENABLED,IMMUTABLE]
        -> "OMAP3 ISP histogram":0 [ENABLED,IMMUTABLE]

- entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video2
    pad0: Sink
        <- "OMAP3 ISP CCDC":1 [ENABLED]

- entity 7: OMAP3 ISP preview (2 pads, 4 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev3
    pad0: Sink
        [fmt:SGRBG10/4096x4096
         crop.bounds:(8,4)/4082x4088
         crop:(8,4)/4082x4088]
        <- "OMAP3 ISP CCDC":2 []
        <- "OMAP3 ISP preview input":0 []
    pad1: Source
        [fmt:YUYV/4082x4088]
        -> "OMAP3 ISP preview output":0 []
        -> "OMAP3 ISP resizer":0 []

- entity 8: OMAP3 ISP preview input (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video3
    pad0: Source
        -> "OMAP3 ISP preview":0 []

- entity 9: OMAP3 ISP preview output (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video4
    pad0: Sink
        <- "OMAP3 ISP preview":1 []

- entity 10: OMAP3 ISP resizer (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev4
    pad0: Sink
        [fmt:YUYV/4095x4095
         crop.bounds:(4,6)/4086x4082
         crop:(4,6)/4086x4082]
        <- "OMAP3 ISP CCDC":1 []
        <- "OMAP3 ISP preview":1 []
        <- "OMAP3 ISP resizer input":0 []
    pad1: Source
        [fmt:YUYV/4096x4095]
        -> "OMAP3 ISP resizer output":0 []

- entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video5
    pad0: Source
        -> "OMAP3 ISP resizer":0 []

- entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video6
    pad0: Sink
        <- "OMAP3 ISP resizer":1 []

- entity 13: OMAP3 ISP AEWB (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev5
    pad0: Sink
        <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 14: OMAP3 ISP AF (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev6
    pad0: Sink
        <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 15: OMAP3 ISP histogram (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev7
    pad0: Sink
        <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 16: ov3640 3-003c (1 pad, 1 link)
             type V4L2 subdev subtype Sensor flags 0
             device node name /dev/v4l-subdev8
    pad0: Source
        [fmt:SBGGR10/640x480
         crop:(32,20)/640x480]
        -> "OMAP3 ISP CCDC":0 [ENABLED]


Setting up selection target 0 rectangle (32,20)/640x480 on pad ov3640 3-003c/0
Selection rectangle set: (32,20)/640x480
Setting up format SBGGR10 640x480 on pad ov3640 3-003c/0
Format set: SBGGR10 640x480
Setting up format SBGGR10 640x480 on pad OMAP3 ISP CCDC/0
Format set: SBGGR10 640x480
Setting up format SBGGR10 640x480 on pad OMAP3 ISP CCDC/1
Format set: SBGGR10 640x480




with yavta I did:

root@overo2:~/yavta-HEAD-d9b7cfc# sudo ./yavta -f SBGGR10 -s 640x480
--capture=1 --file=image  /dev/video2
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
Video format set: SBGGR10 (30314742) 640x480 (stride 1280) buffer size 614400
Video format: SBGGR10 (30314742) 640x480 (stride 1280) buffer size 614400
8 buffers requested.
length: 614400 offset: 0 timestamp type: unknown
Buffer 0 mapped at address 0xb6d05000.
length: 614400 offset: 614400 timestamp type: unknown
Buffer 1 mapped at address 0xb6c6f000.
length: 614400 offset: 1228800 timestamp type: unknown
Buffer 2 mapped at address 0xb6bd9000.
length: 614400 offset: 1843200 timestamp type: unknown
Buffer 3 mapped at address 0xb6b43000.
length: 614400 offset: 2457600 timestamp type: unknown
Buffer 4 mapped at address 0xb6aad000.
length: 614400 offset: 3072000 timestamp type: unknown
Buffer 5 mapped at address 0xb6a17000.
length: 614400 offset: 3686400 timestamp type: unknown
Buffer 6 mapped at address 0xb6981000.
length: 614400 offset: 4300800 timestamp type: unknown
Buffer 7 mapped at address 0xb68eb000.

with "strace":

root@overo2:~/yavta-HEAD-d9b7cfc# sudo strace ./yavta -f SBGGR10 -s 640x480
--capture=1 --file=image  /dev/video2
execve("./yavta", ["./yavta", "-f", "SBGGR10", "-s", "640x480",
"--capture=1", "--file=image", "/dev/video2"], [/* 13 vars */]) = 0
brk(0)                                  = 0x131000
uname({sys="Linux", node="overo2", ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0xb6efe000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/var/run/ld.so.cache", O_RDONLY)  = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=63134, ...}) = 0
mmap2(NULL, 63134, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb6ecb000
close(3)                                = 0
open("/lib/librt.so.1", O_RDONLY)       = 3
read(3,
"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\240\26\0\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=26572, ...}) = 0
mmap2(NULL, 57876, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
0xb6ebc000
mprotect(0xb6ec2000, 28672, PROT_NONE)  = 0
mmap2(0xb6ec9000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x5) = 0xb6ec9000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\fR\1\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1168720, ...}) = 0
mmap2(NULL, 1204784, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
0xb6d95000
mprotect(0xb6eae000, 32768, PROT_NONE)  = 0
mmap2(0xb6eb6000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x119) = 0xb6eb6000
mmap2(0xb6eb9000, 8752, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb6eb9000
close(3)                                = 0
open("/lib/libpthread.so.0", O_RDONLY)  = 3
read(3,
"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\300B\0\0004\0\0\0"..., 512)
= 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=84340, ...}) = 0
mmap2(NULL, 123396, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
0xb6d76000
mprotect(0xb6d8a000, 28672, PROT_NONE)  = 0
mmap2(0xb6d91000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x13) = 0xb6d91000
mmap2(0xb6d93000, 4612, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb6d93000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0xb6efd000
set_tls(0xb6efd820, 0xb6efd820, 0x684, 0xb6efdef8, 0xb6f00050) = 0
mprotect(0xb6d91000, 4096, PROT_READ)   = 0
mprotect(0xb6eb6000, 8192, PROT_READ)   = 0
mprotect(0xb6ec9000, 4096, PROT_READ)   = 0
mprotect(0xb6eff000, 4096, PROT_READ)   = 0
munmap(0xb6ecb000, 63134)               = 0
set_tid_address(0xb6efd3c8)             = 1824
set_robust_list(0xb6efd3d0, 0xc)        = 0
futex(0xbe8c8d04, FUTEX_WAKE_PRIVATE, 1) = 0
rt_sigaction(SIGRTMIN, {0xb6d7a1c8, [], SA_SIGINFO|0x4000000}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0xb6d79d44, [], SA_RESTART|SA_SIGINFO|0x4000000},
NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
open("/dev/video2", O_RDWR)             = 3
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0xb6efc000
write(1, "Device /dev/video2 opened.\n", 27Device /dev/video2 opened.
) = 27
ioctl(3, VIDIOC_QUERYCAP or VT_OPENQRY, 0xbe8c89f0) = 0
write(1, "Device `OMAP3 ISP CCDC output' o"..., 69Device `OMAP3 ISP CCDC
output' on `media' is a video capture device.
) = 69
ioctl(3, VIDIOC_S_FMT or VT_RELDISP, 0xbe8c8898) = 0
write(1, "Video format set: SBGGR10 (30314"..., 78Video format set: SBGGR10
(30314742) 640x480 (stride 1280) buffer size 614400
) = 78
ioctl(3, VIDIOC_G_FMT or VT_SENDSIG, 0xbe8c87cc) = 0
write(1, "Video format: SBGGR10 (30314742)"..., 74Video format: SBGGR10
(30314742) 640x480 (stride 1280) buffer size 614400
) = 74
ioctl(3, VIDIOC_REQBUFS or VT_DISALLOCATE, 0xbe8c8bb8) = 0
write(1, "8 buffers requested.\n", 218 buffers requested.
)  = 21
brk(0)                                  = 0x131000
brk(0x152000)                           = 0x152000
ioctl(3, VIDIOC_QUERYBUF or VT_RESIZE, 0xbe8c8aa8) = 0
write(1, "length: 614400 offset: 0 timesta"..., 49length: 614400 offset: 0
timestamp type: unknown
) = 49
mmap2(NULL, 614400, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) = 0xb6ce0000
write(1, "Buffer 0 mapped at address 0xb6c"..., 39Buffer 0 mapped at address
0xb6ce0000.
) = 39
ioctl(3, VIDIOC_QUERYBUF or VT_RESIZE, 0xbe8c8aa8) = 0
write(1, "length: 614400 offset: 614400 ti"..., 54length: 614400 offset:
614400 timestamp type: unknown
) = 54
mmap2(NULL, 614400, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0x96) = 0xb6c4a000
write(1, "Buffer 1 mapped at address 0xb6c"..., 39Buffer 1 mapped at address
0xb6c4a000.
) = 39
ioctl(3, VIDIOC_QUERYBUF or VT_RESIZE, 0xbe8c8aa8) = 0
write(1, "length: 614400 offset: 1228800 t"..., 55length: 614400 offset:
1228800 timestamp type: unknown
) = 55
mmap2(NULL, 614400, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0x12c) = 0xb6bb4000
write(1, "Buffer 2 mapped at address 0xb6b"..., 39Buffer 2 mapped at address
0xb6bb4000.
) = 39
ioctl(3, VIDIOC_QUERYBUF or VT_RESIZE, 0xbe8c8aa8) = 0
write(1, "length: 614400 offset: 1843200 t"..., 55length: 614400 offset:
1843200 timestamp type: unknown
) = 55
mmap2(NULL, 614400, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0x1c2) = 0xb6b1e000
write(1, "Buffer 3 mapped at address 0xb6b"..., 39Buffer 3 mapped at address
0xb6b1e000.
) = 39
ioctl(3, VIDIOC_QUERYBUF or VT_RESIZE, 0xbe8c8aa8) = 0
write(1, "length: 614400 offset: 2457600 t"..., 55length: 614400 offset:
2457600 timestamp type: unknown
) = 55
mmap2(NULL, 614400, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0x258) = 0xb6a88000
write(1, "Buffer 4 mapped at address 0xb6a"..., 39Buffer 4 mapped at address
0xb6a88000.
) = 39
ioctl(3, VIDIOC_QUERYBUF or VT_RESIZE, 0xbe8c8aa8) = 0
write(1, "length: 614400 offset: 3072000 t"..., 55length: 614400 offset:
3072000 timestamp type: unknown
) = 55
mmap2(NULL, 614400, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0x2ee) = 0xb69f2000
write(1, "Buffer 5 mapped at address 0xb69"..., 39Buffer 5 mapped at address
0xb69f2000.
) = 39
ioctl(3, VIDIOC_QUERYBUF or VT_RESIZE, 0xbe8c8aa8) = 0
write(1, "length: 614400 offset: 3686400 t"..., 55length: 614400 offset:
3686400 timestamp type: unknown
) = 55
mmap2(NULL, 614400, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0x384) = 0xb695c000
write(1, "Buffer 6 mapped at address 0xb69"..., 39Buffer 6 mapped at address
0xb695c000.
) = 39
ioctl(3, VIDIOC_QUERYBUF or VT_RESIZE, 0xbe8c8aa8) = 0
write(1, "length: 614400 offset: 4300800 t"..., 55length: 614400 offset:
4300800 timestamp type: unknown
) = 55
mmap2(NULL, 614400, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0x41a) = 0xb68c6000
write(1, "Buffer 7 mapped at address 0xb68"..., 39Buffer 7 mapped at address
0xb68c6000.
) = 39
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0xbe8c860c) = 0
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0xbe8c860c) = 0
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0xbe8c860c) = 0
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0xbe8c860c) = 0
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0xbe8c860c) = 0
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0xbe8c860c) = 0
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0xbe8c860c) = 0
ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0xbe8c860c) = 0
ioctl(3, VIDIOC_STREAMON, 0xbe8c857c)   = 0
clock_gettime(CLOCK_MONOTONIC, {19689, 264307351}) = 0
ioctl(3, VIDIOC_DQBUF

and here it hangs...

starting from the fact that other sensors seems to work with the pipeline
configuration of sensor->ccdc->memory the problem should belong to the
ov3640 driver. Am I right? My personal problem is that I have no idea what
causes this problem. Could you give me a hint where and how I could find the
source of the problem?

Best Regards, Tom


