Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48049 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226Ab3GaN0B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1V4WPf-0003k2-Ve
	for linux-media@vger.kernel.org; Wed, 31 Jul 2013 15:26:00 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 31 Jul 2013 15:25:59 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 31 Jul 2013 15:25:59 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: Re: implement ov3640 driver using subdev-api with omap3-isp
Date: Wed, 31 Jul 2013 13:25:42 +0000 (UTC)
Message-ID: <loom.20130731T145356-176@post.gmane.org>
References: <loom.20130715T104602-373@post.gmane.org> <3305303.jznjHFUBkl@avalon> <loom.20130716T155926-399@post.gmane.org> <4492814.VvG9cMpqVU@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart <laurent.pinchart <at> ideasonboard.com> writes:

> 
> Hi Tom,
> 
> On Tuesday 16 July 2013 14:24:59 Tom wrote:
> > Laurent Pinchart <laurent.pinchart <at> ideasonboard.com> writes:
> > > On Monday 15 July 2013 09:23:19 Tom wrote:
> > > > Hello,
> > > > 
> > > > I am working with a gumstix overo board connected with a e-con-systems
> > > > camera module using a ov3640 camera sensor.
> > > > 
> > > > Along with the board I got a camera driver
> > > > (https://github.com/scottellis/econ-cam-driver)
> > > > which can be used with linux kernel 2.6.34, but I want to use the camera
> > > > along with the linux kernel 3.5.
> > > > 
> > > > So I tried to implement the driver into the kernel sources by referring
> > > > to a existing drivers like /driver/media/video/ov9640.c and
> > > > /driver/media/video/mt9v032.c.
> > > > 
> > > > The old driver has an isp implementation integrated and it registers
> > > > itself once as a video device. So the application which is going to use
> > > > the camera sensor just needs to open the right video device and by
> > > > calling ioctl the corresponding functions will be called.
> > > > 
> > > > By going through the linux 3.5 kernel sources I found out that the
> > > > omap3-isp registers itself as an video-device and should support
> > > > sensors using the v4l2-subdev interface.
> > > > 
> > > > So am I right when I think that I just need to add the ov3640 subdev to
> > > > the isp_v4l2_subdevs_group in the board-overo.c file and then just open
> > > > thevideo device of the isp to use it via application (ioctl)?
> > > > 
> > > > I read an article which told me that I need to use the
> > > > v4l2_subdev_pad_ops to interact from isp with the ov3640 subdev, but it
> > > > does not work. I don't know what I am doing wrong.
> > > > 
> > > > Is there already an implemenation of the ov3640 using subdev-api which I
> > > > couldn't find or can someone give me a hint what I need to do to get the
> > > > sensor with the isp working?
> > > 
> > > As a matter of fact there's one. You can't be blamed for not finding it,
> > > as it was stored on my computer.
> > > 
> > > I've rebased the patches on top of the latest linuxtv master branch and
> > > pushed the patches to
> > > 
> > > 	git://linuxtv.org/pinchartl/media.git sensors/ov3640
> > > 
> > > Two caveats:
> > > 
> > > - The rebased patches have been compile-tested only, I haven't had time to
> > > test them on the hardware. One particular point that might break is the
> > > use of the clock API as a replacement for the OMAP3 ISP .set_xclk()
> > > callback. Any problem that may arise from this shouldn't be too difficult
> > > to fix.
> > > 
> > > - The driver doesn't work in all resolutions and formats. This is really
> > > work in progress that I haven't had time to finish. The code should be
> > > relatively clean, but the lack of support from Omnivision killed the
> > > schedule (which I've planned too optimistically I have to confess).
> > > 
> > > Fixes would be very welcome. I'd like to push this driver to mainline at
> > > some point, I'd hate to waste the time I've spent on this.
> > 
> > Hello Laurent,
> > 
> > many thanks for the quick reply.
> > 
> > I'm still a beginner, so please excuse that I have to ask you once again
> > just to understand the subdev-api and the isp exactly.
> 
> No worries. As long as people do a bit of research and read documentation by 
> themselves beforehand, I'm happy to answer questions and share knowledge.
> 
> > Is the implementation within the board-overo.c file correct to use the isp
> > along with your camera driver?
> > 
> > And would it be enough to just open the isp video device within my
> > application or do I need to open the subdev-device, too when calling ioctl?
> 
> You will need to access the subdevs directly to configure the OMAP3 ISP 
> pipeline before starting the video stream. This task can be performed
directly 
> in a custom application using the media controller and V4L2 subdevs userspace 
> APIs, or using the media-ctl command line tool 
> (http://git.ideasonboard.org/media-ctl.git). The topic has been discussed 
> extensively before and information is available online, both in web pages or 
> in the linux-media mailing list archives. I don't have exact URLs, so it
would 
> be nice if you could post a couple of pointers in reply to this thread after 
> searching for information, to help future newcomers.
> 
> Once the pipeline is configured you can then capture video frames from the 
> OMAP3 ISP output using the V4L2 API on the appropriate video node.
> 
> > Best Regards, Tom
> > 
> > 
> > My Code Snippet board-overo.c:
> > 
> > #define LM3553_SLAVE_ADDRESS	0x53
> > #define OV3640_I2C_ADDR		(0x78 >> 1)
> > int omap3evm_ov3640_platform_data;
> > int lm3553_platform_data;
> > 
> > static struct i2c_board_info omap3_i2c_boardinfo_ov3640 = {
> > 		I2C_BOARD_INFO("ov3640", OV3640_I2C_ADDR),
> > 		.platform_data = &omap3evm_ov3640_platform_data,
> > };
> > 
> > static struct i2c_board_info omap3_i2c_boardinfo_lm3553 = {
> > 		I2C_BOARD_INFO("lm3553",LM3553_SLAVE_ADDRESS),
> > 		.platform_data = &lm3553_platform_data,
> > };
> > 
> > static struct i2c_board_info mt9v032_i2c_device = {
> > 	I2C_BOARD_INFO("mt9v032", MT9V032_I2C_ADDR),
> > 	.platform_data = &mt9v032_platform_data,
> > };
> > 
> > /*static struct isp_subdev_i2c_board_info mt9v032_subdevs[] = {
> > 	{
> > 		.board_info = &mt9v032_i2c_device,
> > 		.i2c_adapter_id = MT9V032_I2C_BUS_NUM,
> > 	},
> > 	{ NULL, 0, },
> > };*/
> > 
> > static struct isp_subdev_i2c_board_info overo_subdevs[] = {
> > 	/*{
> > 		.board_info = &mt9v032_i2c_device,
> > 		.i2c_adapter_id = MT9V032_I2C_BUS_NUM,
> > 	},*/
> > 	{
> > 		.board_info = &omap3_i2c_boardinfo_ov3640,
> > 		.i2c_adapter_id = MT9V032_I2C_BUS_NUM,
> > 	},
> > 	{ NULL, 0, },
> > };
> > 
> > static struct isp_v4l2_subdevs_group overo_camera_subdevs[] = {
> > 	{
> > 		//.subdevs = mt9v032_subdevs,
> > 		.subdevs = overo_subdevs,
> > 		.interface = ISP_INTERFACE_PARALLEL,
> > 		.bus = {
> > 				.parallel = {
> > 					.data_lane_shift = 0,
> > 					.clk_pol = 0,
> > 					.bridge = ISPCTRL_PAR_BRIDGE_DISABLE,
> > 				}
> > 		},
> > 	},
> > 	{ NULL, 0, },
> > };
> > 
> > static struct isp_platform_data overo_isp_platform_data = {
> 
> I had forgotten to update the ISP platform data in the patches available
in my 
> sensors/ov3640 branch. I've pushed the (still untested) updated code to my
git 
> tree. Only the "board-omap3beagle: Add support for the OV3640 sensor module" 
> patch has been modified. You need to add
> 
>         .xclks = {
>                 [0] = {
>                         .dev_id = "3-003c",
>                 },
>         },
> 
> here. 3 should be the I2C bus number your sensor is connected to, and 003c 
> should be the sensor I2C address. Please fix that if I got the bus number 
> wrong.
> 
> > 	.subdevs = overo_camera_subdevs,
> > };
> 
> > static int __init overo_camera_init(void)
> > {
> >        return omap3_init_camera(&overo_isp_platform_data);
> > }
> 


Hello Laurent,
many thanks for your advise. Due to illness I was unable to continue the
tests with the ov3640 sensor. You said that at first I need to configure the
pipeline for the isp. I tried that, but unfortunately some errors and
ambiguity emerged. I tried to manually set the pipeline like this:


VS_printf(_T("TOM APPL 1 ##########\n"));

	if ((cam->fd_v4l2_media = open("/dev/media0", O_RDWR, 0)) < 0)
	{
			//if ((cam->fd_v4l2 = open("/dev/video0", O_RDWR, 0)) < 0)
		printf("TOM APPL OPEN MEDIA0 FAILED ##########\n");
		return ERR_ERROR;
	}

	VS_printf(_T("TOM APPL 2 ##########\n"));

	#define ENTITY_COUNT  20
	#define MEDIA_ENT_ID_FLAG_NEXT          (1 << 31)
	#define MEDIA_PAD_FL_INPUT		(1 << 0)
	#define MEDIA_PAD_FL_OUTPUT		(1 << 1)
	#define P_CCDC_SOURCE	1
	#define P_VIDEO		0
	//#define OV3640_FORMAT_DEF		V4L2_MBUS_FMT_YUYV8_2X8
	#define OV3640_FORMAT_DEF		V4L2_PIX_FMT_RGB565
	#define OV3640_WIDTH_DEF		640
	#define OV3640_HEIGHT_DEF		480
	//#define OV3640_WIDTH_DEF		2048
	//#define OV3640_HEIGHT_DEF		1536
	#define P_CCDC_SINK	0 /* sink pad of ccdc */

	struct media_entity_desc entity[ENTITY_COUNT];

	int E_VIDEO;
	int E_OV3640;
	int E_CCDC;
	int ret;
	int entities_count;

	int index = 0;
	do {
		memset(&entity[index], 0, sizeof(struct media_entity_desc));
		entity[index].id = index | MEDIA_ENT_ID_FLAG_NEXT;

		ret = ioctl(cam->fd_v4l2_media, MEDIA_IOC_ENUM_ENTITIES, &entity[index]);
		if (ret < 0) {
			if (errno == EINVAL)
				break;
		}else {
			VS_printf(_T("TOM APPL ENTITY NAME: %s ##########\n"),entity[index].name);
			//printf("TOM APPL ENTITY NAME: %s ##########\n",entity[index].name);

			if (!strcmp(entity[index].name, "OMAP3 ISP CCDC output")) {
				E_VIDEO =  entity[index].id;
			}
			else if (!strcmp(entity[index].name, "ov3640 3-003c")) {
				E_OV3640 =  entity[index].id;
			}
			else if (!strcmp(entity[index].name, "OMAP3 ISP CCDC")) {
				E_CCDC =  entity[index].id;
			}
			printf("[%x]:%s\n", entity[index].id, entity[index].name);
		}

		index++;
	} while (ret == 0 && index < ENTITY_COUNT);
	entities_count = index;
	printf("total number of entities: %x\n", entities_count);

	VS_printf(_T("TOM APPL 3 ##########\n"));
	// 6. enable 'ov3640-->ccdc' link

		struct media_link_desc link;

		//link = calloc(sizeof(struct media_link),sizeof(UINT8));
		//*link = (struct media_link*)calloc(sizeof(struct media_link),sizeof(UINT8));

		printf("6. ENABLEing link [ov3640]----------->[ccdc]\n");
		memset(&link, 0, sizeof(link));

		link.flags |=  MEDIA_LNK_FL_ENABLED;
		link.source.entity = E_OV3640;
		link.source.index = 0;	//nur ein pad
		link.source.flags = MEDIA_PAD_FL_OUTPUT;

		link.sink.entity = E_CCDC;
		link.sink.index = 0;
		link.sink.flags = MEDIA_PAD_FL_INPUT;

		ret = ioctl(cam->fd_v4l2_media, MEDIA_IOC_SETUP_LINK, &link);
		if(ret) {
			VS_printf(_T("failed to enable link between ov3640 and ccdc\n"));
			return ERR_ERROR;
		} else
			VS_printf(_T("[ov3640]----------->[ccdc]\tENABLED\n"));

		VS_printf(_T("TOM APPL 4 ##########\n"));

	// 7. enable 'ccdc->memory' link
		printf("7. ENABLEing link [ccdc]----------->[video_node]\n");
		memset(&link, 0, sizeof(link));

		link.flags |=  MEDIA_LNK_FL_ENABLED;
		link.source.entity = E_CCDC;
		link.source.index = P_CCDC_SOURCE;
		link.source.flags = MEDIA_PAD_FL_OUTPUT;

		link.sink.entity = E_VIDEO;
		link.sink.index = P_VIDEO;
		link.sink.flags = MEDIA_PAD_FL_INPUT;

		ret = ioctl(cam->fd_v4l2_media, MEDIA_IOC_SETUP_LINK, &link);
		if(ret) {
			VS_printf(_T("failed to enable link between ccdc and video node\n"));
			return ERR_ERROR;
		} else
			VS_printf(_T("[ccdc]----------->[video_node]\t ENABLED\n"));

		printf("**********************************************\n");


		// 14.open capture device
		if ((cam->fd_v4l2 = open("/dev/video2", O_RDWR | O_NONBLOCK, 0)) <= -1) {
			VS_printf(_T("failed to open /dev/video2"));
			return ERR_ERROR;
		}

		struct v4l2_input input;

		/* 15.enumerate inputs supported by capture*/
			printf("15.enumerating INPUTS\n");
			bzero(&input, sizeof(struct v4l2_input));
			input.type = V4L2_INPUT_TYPE_CAMERA;
			input.index = 0;
			index = 0;
		  	while (1) {

				ret = ioctl(cam->fd_v4l2, VIDIOC_ENUMINPUT, &input);
				if(ret != 0)
					break;

				printf("[%x].%s\n", index, input.name);

				bzero(&input, sizeof(struct v4l2_input));
				index++;
				input.index = index;
		  	}

		/* 16.setting CAMERA as input */
			printf("16. setting CAMERA as input. . .\n");
			bzero(&input, sizeof(struct v4l2_input));
			input.type = V4L2_INPUT_TYPE_CAMERA;
			input.index = 0;
			if (-1 == ioctl (cam->fd_v4l2, VIDIOC_S_INPUT, &input.index)) {
				VS_printf(_T("failed to set CAMERA with capture device\n"));
				//goto cleanup;
				return ERR_ERROR;
			} else
				VS_printf(_T("successfully set CAMERA input\n"));


			/* 8. set format on pad of mt9p031 */
			cam->fd_v4l2_ov3640 = open("/dev/v4l-subdev8", O_RDWR);
			if(cam->fd_v4l2_ov3640 == -1) {
				VS_printf(_T("failed to open /dev/v4l-subdev8"));
				//goto cleanup;
				return ERR_ERROR;
			}

			struct v4l2_subdev_format fmt;

			VS_printf(_T("8. setting format on pad of mt9p031 entity. . .\n"));
			memset(&fmt, 0, sizeof(fmt));

			fmt.pad = 0;
			fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
			fmt.format.code = OV3640_FORMAT_DEF;
			fmt.format.width = OV3640_WIDTH_DEF;
			fmt.format.height = OV3640_HEIGHT_DEF;
			fmt.format.field = V4L2_FIELD_NONE;

			ret = ioctl(cam->fd_v4l2_ov3640, VIDIOC_SUBDEV_S_FMT, &fmt);
			if(ret) {
				VS_printf(_T("failed to set format on pad %x\n"), fmt.pad);
				//goto cleanup;
				return ERR_ERROR;
			}
			else
				VS_printf(_T("successfully format is set on pad %x\n"), fmt.pad);


			/* 9. set format on sink-pad of ccdc */
				cam->fd_v4l2_isp_ccdc = open("/dev/v4l-subdev2", O_RDWR);
				if(cam->fd_v4l2_isp_ccdc == -1) {
					VS_printf(_T("failed to open /dev/v4l-subdev2"));
					//goto cleanup;
					return ERR_ERROR;
				}
				// set format on sink pad of ccdc
				VS_printf(_T("12. setting format on sink-pad of ccdc entity. . .\n"));
				memset(&fmt, 0, sizeof(fmt));

				fmt.pad = P_CCDC_SINK;
				fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
				fmt.format.code = OV3640_FORMAT_DEF;
				fmt.format.width = OV3640_WIDTH_DEF;
				fmt.format.height = OV3640_HEIGHT_DEF;
				fmt.format.field = V4L2_FIELD_NONE;

				ret = ioctl(cam->fd_v4l2_isp_ccdc, VIDIOC_SUBDEV_S_FMT, &fmt);
				if(ret) {
					VS_printf(_T("failed to set format on pad %x\n"), fmt.pad);
					//goto cleanup;
					return ERR_ERROR;
				}
				else
					VS_printf(_T("successfully format is set on pad %x\n"), fmt.pad);

			/* 13. set format on source-pad of ccdc */
				printf("13. setting format on OF-pad of ccdc entity. . . \n");
				memset(&fmt, 0, sizeof(fmt));

				fmt.pad = P_CCDC_SOURCE;
				fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
				fmt.format.code = OV3640_FORMAT_DEF;
				fmt.format.width = OV3640_WIDTH_DEF;
				fmt.format.height = OV3640_HEIGHT_DEF;
				fmt.format.colorspace = V4L2_COLORSPACE_JPEG;
				fmt.format.field = V4L2_FIELD_NONE;

				ret = ioctl(cam->fd_v4l2_isp_ccdc, VIDIOC_SUBDEV_S_FMT, &fmt);
				if(ret) {
					VS_printf(_T("failed to set format on pad %x\n"), fmt.pad);
					//goto cleanup;
					return ERR_ERROR;
				}
				else
					VS_printf(_T("successfully format is set on pad %x\n"), fmt.pad);


struct v4l2_format v4l2_fmt;
				int capture_pitch;

				VS_printf(_T("17. setting format V4L2_PIX_FMT_SBGGR16\n"));
					//CLEAR(v4l2_fmt);
					v4l2_fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
					v4l2_fmt.fmt.pix.width = OV3640_WIDTH_DEF;
					v4l2_fmt.fmt.pix.height = OV3640_HEIGHT_DEF;
					//v4l2_fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SBGGR16;
					v4l2_fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB565;
					v4l2_fmt.fmt.pix.field = V4L2_FIELD_NONE;

					if (-1 == ioctl(cam->fd_v4l2, VIDIOC_S_FMT, &v4l2_fmt)) {
						VS_printf(_T("failed to set format on captute device \n"));
						return ERR_ERROR;
					} else
						VS_printf(_T("successfully set the format\n"));

					/* 15.call G_FMT for knowing picth */
					if (-1 == ioctl(cam->fd_v4l2, VIDIOC_G_FMT, &v4l2_fmt)) {
						VS_printf(_T("failed to get format from captute device \n"));
						return ERR_ERROR;
					} else {
						VS_printf(_T("capture_pitch: %x\n"), v4l2_fmt.fmt.pix.bytesperline);
						capture_pitch = v4l2_fmt.fmt.pix.bytesperline;
					}



				/* 18.make sure 3 buffers are supported for streaming */
				printf("18. Requesting for 3 buffers\n");

				 struct v4l2_requestbuffers req;
				//CLEAR(req);
				req.count = 3;
				req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
				req.memory = V4L2_MEMORY_USERPTR;

				if (-1 == ioctl(cam->fd_v4l2, VIDIOC_REQBUFS, &req)) {
					VS_printf(_T("call to VIDIOC_REQBUFS failed\n"));
					return ERR_ERROR;
				}

				if (req.count != 3) {
					VS_printf(_T("3 buffers not supported by capture device"));
					return ERR_ERROR;
				} else
					VS_printf(_T("3 buffers are supported for streaming\n"));

				VS_printf(_T("TOM APPL 900 ##########\n"));


				/* 20.start streaming */

				enum v4l2_buf_type type;
				
				type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
				if (-1 == ioctl(cam->fd_v4l2, VIDIOC_STREAMON, &type)) {
					VS_printf(_T("failed to start streaming on capture device"));
					return ERR_ERROR;
				} else
					VS_printf(_T("streaming started successfully\n"));



				/* ENDE */
				VS_printf(_T("TOM APPL 1000 ##########\n"));


my output loglooks like this:

TOM APPL 1 ##########
TOM APPL 2 ##########
TOM APPL ENTITY NAME: OMAP3 ISP CCP2 ##########
TOM APPL ENTITY NAME: OMAP3 ISP CCP2 input ##########
TOM APPL ENTITY NAME: OMAP3 ISP CSI2a ##########
TOM APPL ENTITY NAME: OMAP3 ISP CSI2a output ##########
TOM APPL ENTITY NAME: OMAP3 ISP CCDC ##########
TOM APPL ENTITY NAME: OMAP3 ISP CCDC output ##########
TOM APPL ENTITY NAME: OMAP3 ISP preview ##########
TOM APPL ENTITY NAME: OMAP3 ISP preview input ##########
TOM APPL ENTITY NAME: OMAP3 ISP preview output ##########
TOM APPL ENTITY NAME: OMAP3 ISP resizer ##########
TOM APPL ENTITY NAME: OMAP3 ISP resizer input ##########
TOM APPL ENTITY NAME: OMAP3 ISP resizer output ##########
TOM APPL ENTITY NAME: OMAP3 ISP AEWB ##########
TOM APPL ENTITY NAME: OMAP3 ISP AF ##########
TOM APPL ENTITY NAME: OMAP3 ISP histogram ##########
TOM APPL ENTITY NAME: ov3640 3-003c ##########
TOM APPL 3 ##########
[tvp7002]----------->[ccdc]	ENABLED
TOM APPL 4 ##########
[ccdc]----------->[video_node]	 ENABLED
successfully set CAMERA input
8. setting format on pad of mt9p031 entity. . .
successfully format is set on pad 0
12. setting format on sink-pad of ccdc entity. . .
successfully format is set on pad 0
successfully format is set on pad 1
17. setting format V4L2_PIX_FMT_SBGGR16
successfully set the format
capture_pitch: 500
3 buffers are supported for streaming
TOM APPL 900 ##########
 overo2 [  916.723297] Internal error: Oops: 17 [#1] PREEMPT ARM
 overo2 [  916.798278] Process MBVisionCameraS (pid: 1309, stack limit =
0xcd9122f0)
 overo2 [  916.805358] Stack: (0xcd913a00 to 0xcd914000)
 overo2 [  916.809906] 3a00: ceec6440 cd913a68 cd913a10 bf01d320 00000001
00000000 00000280 000001e0
 overo2 [  916.818420] 3a20: 00002008 00000000 00000000 00000000 00000000
00000000 00000000 00000000
 overo2 [  916.826965] 3a40: 00000000 00000000 00000004 00000101 00000009
c0765b80 cd912000 c003a448
 overo2 [  916.835510] 3a60: cec06170 c025d4b4 00000001 00000000 00000280
000001e0 0000300a 00000001
 overo2 [  916.844024] 3a80: 00000008 00000000 00000000 00000000 00000000
00000000 00000000 00000000
 overo2 [  916.852569] 3aa0: cd913ac4 cdaf02ac 00000001 cd913ad4 cd92da10
cdaf9148 cdaf9148 cdaf02ac
 overo2 [  916.861114] 3ac0: 00000009 cdaf8fd8 cdaf9148 bf0013f8 c06d943c
00000000 00000001 cdaf9148
 overo2 [  916.869628] 3ae0: 00000001 cdaf8fd8 00000009 cd92da10 00000001
00000000 60000013 cd913b10
 overo2 [  916.878173] 3b00: c0033b4c c0034584 60000013 ffffffff 00000000
00000000 00000000 00000000
 overo2 [  916.886718] 3b20: c0725248 00000021 ccc4c080 00000000 cd913e68
cd913b40 c048eb6c c005db38
 overo2 [  916.895233] 3b40: 22222222 22222222 22222222 22222222 cd933000
00000001 00000001 cccb1bc0
 overo2 [  916.903778] 3b60: 00000001 cdaf9148 cccb1bc0 cdaf93f4 cd933000
cdaf9148 cd913e68 bf03d92c
 overo2 [  916.912292] 3b80: cdaf942c 00000402 00000000 00000000 4ae3160d
12b63f0f 00000000 000001c9
 overo2 [  916.920837] 3ba0: 00000008 ccc4c080 60000113 c00e0b00 ccc4c080
00000020 ccc4c080 cd8e1c80
 overo2 [  916.929382] 3bc0: 00000020 c0424340 00000020 cd8e1c80 ccc4c080
cd8e1c80 ccc4c080 cda29de4
 overo2 [  916.937896] 3be0: 00000016 32c213ac 00000002 c042bd08 ccc4c080
c0416064 00000000 00000000
 overo2 [  916.946441] 3c00: cd8e1c80 c0710b20 00000000 ccc4c080 cda29dd0
cd913c20 c042c474 c005db38
 overo2 [  916.954986] 3c20: 32c213ac 00000016 00000002 00000101 00000009
c0765b80 cd912000 c0710b20
 overo2 [  916.963500] 3c40: cec06170 00000006 c0710b20 c04edac4 00000000
cd8e1c80 c06c5b30 c0710b20
 overo2 [  916.972045] 3c60: 00000001 c040e110 cda29dd0 00000008 cd8e1c80
00000000 c06c51f8 cd913cb4
 overo2 [  916.980590] 3c80: cd913cbc c040dbe0 cee91800 00000001 00000008
c06c51d8 00000008 cee91800
 overo2 [  916.989105] 3ca0: c06c51d8 c03ea784 cee91c80 00000046 00000001
cd8e1c80 00000010 c06c51f8
 overo2 [  916.997650] 3cc0: 00000010 cd913cd0 c030a484 c005db38 00000010
cd913ce0 c030c950 c005db38
 overo2 [  917.006195] 3ce0: 00000000 c0765b80 cee91d4c cd912000 00000010
00000101 c0864860 c00afd10
 overo2 [  917.014709] 3d00: cdb68b78 cd913d10 c00b0944 c005db38 cd912000
00000003 cd913d58 ceac7e30
 overo2 [  917.023254] 3d20: 0000000a 85ac318f 00085ac3 c00dad54 00000000
c0016514 c0864860 00000000
 overo2 [  917.031799] 3d40: 00000000 c00cd138 00025000 00000001 cd933000
00000000 cccb1bc0 bf04c1dc
 overo2 [  917.040313] 3d60: ffffffe7 cdaf9148 cd913e68 bf0143ac cdad8000
cce08e40 00025000 00000000
 overo2 [  917.048858] 3d80: 00025000 cdb68b78 00000028 c00cde14 0000001d
c06c8878 00000000 c0057a98
 overo2 [  917.057403] 3da0: 000000d5 40045612 cccb1bc0 cd933000 c0723b88
cce08e40 cd913dec cd913dc8
 overo2 [  917.065948] 3dc0: c005f364 c005db38 cee95570 00000000 00000019
ced69ac0 cee95540 cce08e40
 overo2 [  917.074462] 3de0: cd913e7c cd913df0 c048fe78 c005db38 a0000093
00000000 00000000 c0059f24
 overo2 [  917.083007] 3e00: c0490004 cd912000 cee95540 00000000 cd913e44
cd913e20 c005fcf0 c005db38
 overo2 [  917.091552] 3e20: cd913ee4 cd92fcd8 00000000 00000001 cd92fce4
00000000 40045612 00000000
 overo2 [  917.100067] 3e40: cccb1bc0 00000000 00000000 cd913e68 00000000
bf012774 00000004 bf012908
 overo2 [  917.108612] 3e60: be9755fc 00000001 00000001 cd913e78 c005eccc
c005db38 00000004 c048f8d8
 overo2 [  917.117156] 3e80: c004ca7c 00000002 cd92fc00 cdbe3000 00000001
cd912000 cd92f400 cd913ea8
 overo2 [  917.125671] 3ea0: c029e2b8 c005ec84 0000000a 00001f00 00000002
c048e7a0 cd92f400 cd913ec8
 overo2 [  917.134216] 3ec0: c0052530 cefd7e08 00000003 00000001 00000000
60000013 00000000 00000018
 overo2 [  917.142761] 3ee0: cceff248 cd913ef0 c0057588 cccb1bc0 cdaf9148
00000000 40045612 be9755fc
 overo2 [  917.151306] 3f00: cd912000 00000000 be97564c bf010708 ccc5a0e8
cccb1bc0 00000004 00000004
 overo2 [  917.159820] 3f20: be9755fc c00f9c18 c0299a28 00000000 00000000
00000000 00000006 cceff248
 overo2 [  917.168365] 3f40: 00000018 00000002 c8906148 00000000 cd912000
00000000 be974024 c00ea8ec
 overo2 [  917.176910] 3f60: 00000000 00000000 00000000 be9755fc 40045612
00000004 cccb1bc0 cd912000
 overo2 [  917.185424] 3f80: 00000000 c00f9ccc cd913fb0 00000000 010deae0
00000000 0000ceb8 00000036
 overo2 [  917.193969] 3fa0: c000e984 c000e800 010deae0 00000000 00000004
40045612 be9755fc 00000004
 overo2 [  917.202514] 3fc0: 010deae0 00000000 0000ceb8 00000036 00000000
00000000 b6fd3000 be97564c
 overo2 [  917.211029] 3fe0: 00000000 be974040 0000f66c b671e45c 60000010
00000004 8f2fe821 8f2fec21
 overo2 [  917.321228] Code: ebffebaf e1a05000 e1a00004 ebffebac (e595200c)



Do you see what is missing or what I might have done wrong?

And I have one additional question. When I want to change the format through
my application. Do I need to change the format on all three pads or would it
be enought to call the ioctl just for the video device (video2)?

I still hope that I don't annoy you too much.

Best Regards, Tom



