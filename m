Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:60106 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbZGORiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jul 2009 13:38:13 -0400
Received: by an-out-0708.google.com with SMTP id d40so7495800and.1
        for <linux-media@vger.kernel.org>; Wed, 15 Jul 2009 10:38:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A5E11B9.9010504@stanford.edu>
References: <15157053.23861247590158808.JavaMail.root@mailx.crc.ricoh.com>
	 <4A5CBF3D.80002@stanford.edu>
	 <bb2708720907141351o585bc140r2bf2e3abbe71a526@mail.gmail.com>
	 <4A5E11B9.9010504@stanford.edu>
Date: Wed, 15 Jul 2009 13:38:10 -0400
Message-ID: <bb2708720907151038q295be88w7c5edb4574b8d1fb@mail.gmail.com>
Subject: Re: Problems configuring OMAP35x ISP driver
From: John Sarman <johnsarman@gmail.com>
To: Eino-Ville Talvala <talvala@stanford.edu>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Eddy
Here is the config
static struct isp_interface_config ov5620_if_config = {
        .ccdc_par_ser = ISP_PARLL,
        .dataline_shift = 0x1,
        .hsvs_syncdetect = ISPCTRL_SYNC_DETECT_VSRISE,
        .strobe = 0x0,
        .prestrobe = 0x0,
        .shutter = 0x0,
        .prev_sph = 2,
        .prev_slv = 0,
        .wenlog = ISPCCDC_CFG_WENLOG_OR,
        .u.par.par_bridge = 0x0,
        .u.par.par_clk_pol = 0x0,
};

My sensor has pos edge Vsync and pos edge h sync,  positive clock,
wenlog was originally  ISPCCDC_CFG_WENLOG_AND

I am using the latest patches from Sergio.

Maybe I should backport my driver to the older release.  Are you using
the RAW input or another input format ?

Thanks
John Sarman
Tetracam Inc.

On Wed, Jul 15, 2009 at 1:28 PM, Eino-Ville Talvala<talvala@stanford.edu> wrote:
> John,
>
> I don't have any magic cures to offer right off - if I had to guess, I'd say
> something in the ISP is misconfigured.  Do you call isp_configure_interface
> in your board file, and does the struct you pass it match what the sensor
> puts out?
>
> I'm not actually sure which kernel version you're using - we here at
> Stanford have been using Vaibhav Hiremath's git repository at:
> http://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git
> (the ti_display part), with the ISP patches from Sergio from a few months
> ago applied on top.  It's a bit of a mess, if you ask me - I hope all of
> this gets integrated into the mainline soon, keeping track of it all takes
> far too much time.
>
> -Eddy
>
> On 7/14/2009 1:51 PM, John Sarman wrote:
>>
>> Eddy and anyone who may be able to help,
>>   I am currently working on an Omnivision OV5620 and have used the
>> ov3640 driver as a starting point.  I have the June 18( latest ? )
>> code from the gitorious git repo.  I have thouroughly tested my i2c
>> driver setup using a 500 Mhz oscilloscope and have configured the
>> sensor to 640 x 480.  The only mode this supports is RAW
>> V4L2_PIX_FMT_SGRBG10 and I have that as the only available format.  So
>> far so good.  Sensor powers, configures etc, etc.  However when I run
>> the sensor I get ISPCTRL: HS_VS_IRQ<6>ISPCTRL: OVF_IRQ<6>ISPCTRL:
>> To test this I used the example code provided with v4l2 documentation.
>>  I have attached a complete log with all my added printk's set up as a
>> poor mans stacktrace.
>>
>> Stuck trying to determine where to go from here, I feel like I am so
>> close to getting an image.
>>
>> Thanks,
>> John Sarman
>>
>> v4l2_open
>> omap34xx: Opening device
>> isp_get
>> ISPCTRL: isp_get: old 0
>> isp_enable_clocks
>> isp_restore_ctx
>> isp_restore_context
>> isp_restore_context
>> iommu_restore_ctx
>> ISPHIST:  Restoring context
>> isp_restore_context
>> ISPH3A:  Restoring context
>> isp_restore_context
>> isp_restore_context
>> ISPRESZ: Restoring context
>> isp_restore_context
>> ISPCTRL: isp_get: new 1
>> omap34xxcam_slave_power_set
>> OV5620: ioctl_s_power
>> isp_set_xclk
>> isp_reg_and_or
>> ISPCTRL: isp_set_xclk(): cam_xclka set to 24000000 Hz
>> BOARD_OVERO_CAMERA: Switching Power to 1
>> OV5620: POWER ON
>> isp_configure_interface
>> isp_buf_init
>> OV5620: Sensor Detected, calling configure
>> ov5620:configure
>> omap34xxcam_slave_power_set
>> OV5620: ioctl_s_power
>> BOARD_OVERO_CAMERA: Switching Power to 2
>> OV5620: POWER STANDBY
>> isp_set_xclk
>> isp_reg_and_or
>> ISPCTRL: isp_set_xclk(): cam_xclka set to 0 Hz
>> OV5620: ioctl_g_fmt_cap
>> omap34xxcam_s_pix_parm
>> omap34xxcam_try_pix_parm
>> omap34xxcam_try_pix_parm fps = 1
>> OV5620: ioctl_enum_fmt_cap
>> OV5620: ioctl_enum_fmt_cap index 0 type 1
>> video4linux video0: trying fmt 30314142 (0)
>> OV5620: ioctl_enum_framesizes
>> isp_try_fmt_cap
>> isp_try_pipeline
>> video4linux video0: this w 640  h 480   fmt 30314142    ->  w 640       h
>> 480    fmt
>> 30314142        wanted w 640    h 480    fmt 30314142
>> video4linux video0: renegotiate: w 640  h 480   w 1073741823    h
>> 1073741823
>> OV5620: ioctl_enum_frameintervals
>> video4linux video0: fps 60
>> the demoninator is 0
>> video4linux video0: best_pix_in: w 640  h 480   fmt 30314142    ival 1/60
>> OV5620: ioctl_enum_frameintervals
>> video4linux video0: fps 30
>> video4linux video0: closer fps: fps 29   fps 59
>> video4linux video0: best_pix_in: w 640  h 480   fmt 30314142    ival 1/30
>> OV5620: ioctl_enum_frameintervals
>> video4linux video0: fps 7
>> video4linux video0: closer fps: fps 6    fps 29
>> video4linux video0: best_pix_in: w 640  h 480   fmt 30314142    ival 2/15
>> OV5620: ioctl_enum_frameintervals
>> OV5620: ioctl_enum_framesizes
>> isp_try_fmt_cap
>> isp_try_pipeline
>> video4linux video0: this w 1280 h 960   fmt 30314142    ->  w 1280      h
>> 960
>> fmt 30314142    wanted w 640    h 480    fmt 30314142
>> video4linux video0: size diff bigger: w 1280    h 960   w 640   h 480
>> OV5620: ioctl_enum_framesizes
>> OV5620: ioctl_enum_fmt_cap
>> OV5620: ioctl_enum_fmt_cap index 1 type 1
>> video4linux video0: w 640, h 480, fmt 30314142 ->  w 640, h 480
>> video4linux video0: Wanted w 640, h 480, fmt 30314142
>> omap34xxcam_s_pix_parm 1 0
>> isp_s_fmt_cap
>> isp_s_pipeline
>> isp_release_resources
>> isp_try_pipeline
>> isp_reg_or
>> isp_reg_or
>> isp_reg_and_or
>> isp_reg_and_or
>> isp_reg_and
>> isp_print_status
>> ISPCTRL: ###ISP_CTRL=0x29c140
>> ISPCTRL: ###ISP_TCTRL_CTRL=0x0
>> ISPCTRL: ###ISP_SYSCONFIG=0x2000
>> ISPCTRL: ###ISP_SYSSTATUS=0x1
>> ISPCTRL: ###ISP_IRQ0ENABLE=0x0
>> ISPCTRL: ###ISP_IRQ0STATUS=0x80000000
>> isp_reg_and
>> isp_reg_and
>> isp_reg_and
>> omap34xxcam_s_pix_parm 2 0
>> OV5620: ioctl_g_fmt_cap
>> OV5620: ioctl_s_fmt_cap
>> OV5620: ioctl_try_fmt_cap
>> OV5620: ioctl_try_fmt_cap WIDTH = 640
>> OV5620: ioctl_try_fmt_cap HEIGHT = 480
>> omap34xxcam_s_pix_parm 3 0
>> OV5620: ioctl_s_parm
>> OV5620 desired_fps = 7
>> omap34xxcam_s_pix_parm 4 0
>> omap34xx: Opened device
>> video_do_ioctl
>> omap34xxcam_vidioc_querycap
>> video_do_ioctl
>> omap34xxcam_cropcap
>> OV5620: ioctl_g_fmt_cap
>> video_do_ioctl
>> omap34xxcam_vidioc_s_crop
>> isp_s_crop
>> video_do_ioctl
>> omap34xxcam_vidioc_s_fmt_vid_cap
>> omap34xxcam_s_pix_parm
>> omap34xxcam_try_pix_parm
>> omap34xxcam_try_pix_parm fps = 1
>> OV5620: ioctl_enum_fmt_cap
>> OV5620: ioctl_enum_fmt_cap index 0 type 1
>> video4linux video0: trying fmt 30314142 (0)
>> OV5620: ioctl_enum_framesizes
>> isp_try_fmt_cap
>> isp_try_pipeline
>> video4linux video0: this w 640  h 480   fmt 30314142    ->  w 640       h
>> 480    fmt
>> 56595559        wanted w 640    h 480    fmt 56595559
>> video4linux video0: renegotiate: w 640  h 480   w 1073741823    h
>> 1073741823
>> OV5620: ioctl_enum_frameintervals
>> video4linux video0: fps 60
>> the demoninator is 0
>> video4linux video0: best_pix_in: w 640  h 480   fmt 30314142    ival 1/60
>> OV5620: ioctl_enum_frameintervals
>> video4linux video0: fps 30
>> video4linux video0: closer fps: fps 29   fps 59
>> video4linux video0: best_pix_in: w 640  h 480   fmt 30314142    ival 1/30
>> OV5620: ioctl_enum_frameintervals
>> video4linux video0: fps 7
>> video4linux video0: closer fps: fps 6    fps 29
>> video4linux video0: best_pix_in: w 640  h 480   fmt 30314142    ival 2/15
>> OV5620: ioctl_enum_frameintervals
>> OV5620: ioctl_enum_framesizes
>> isp_try_fmt_cap
>> isp_try_pipeline
>> video4linux video0: this w 1280 h 960   fmt 30314142    ->  w 640       h
>> 480    fmt
>> 56595559        wanted w 640    h 480    fmt 56595559
>> OV5620: ioctl_enum_frameintervals
>> video4linux video0: fps 60
>> video4linux video0: falling through
>> OV5620: ioctl_enum_frameintervals
>> OV5620: ioctl_enum_framesizes
>> OV5620: ioctl_enum_fmt_cap
>> OV5620: ioctl_enum_fmt_cap index 1 type 1
>> video4linux video0: w 640, h 480, fmt 30314142 ->  w 640, h 480
>> video4linux video0: Wanted w 640, h 480, fmt 30314142
>> omap34xxcam_s_pix_parm 1 0
>> isp_s_fmt_cap
>> isp_s_pipeline
>> isp_release_resources
>> isp_reg_and
>> isp_try_pipeline
>> isp_reg_or
>> isp_reg_or
>> isp_reg_and_or
>> isp_reg_and
>> isp_print_status
>> ISPCTRL: ###ISP_CTRL=0x29c140
>> ISPCTRL: ###ISP_TCTRL_CTRL=0x0
>> ISPCTRL: ###ISP_SYSCONFIG=0x2000
>> ISPCTRL: ###ISP_SYSSTATUS=0x1
>> ISPCTRL: ###ISP_IRQ0ENABLE=0x0
>> ISPCTRL: ###ISP_IRQ0STATUS=0x80000000
>> isp_reg_and
>> isp_reg_or
>> isp_reg_and_or
>> isp_reg_or
>> isp_reg_and
>> isp_reg_and
>> isp_reg_or
>> isp_reg_or
>> isp_reg_or
>> isp_reg_and
>> ISPRESZ: ispresizer_config_datapath()+
>> isp_reg_or
>> ISPRESZ: ispresizer_config_ycpos()+
>> isp_reg_and_or
>> ISPRESZ: ispresizer_config_ycpos()-
>> ISPRESZ: ispresizer_config_filter_coef()+
>> ISPRESZ: ispresizer_config_filter_coef()-
>> ISPRESZ: ispresizer_enable_cbilin()+
>> isp_reg_and_or
>> ISPRESZ: ispresizer_enable_cbilin()-
>> ISPRESZ: ispresizer_config_luma_enhance()+
>> ISPRESZ: ispresizer_config_luma_enhance()-
>> ISPRESZ: ispresizer_config_datapath()-
>> ISPRESZ: ispresizer_config_inlineoffset()+
>> ISPRESZ: ispresizer_config_inlineoffset()-
>> ISPRESZ: ispresizer_set_inaddr()+
>> ISPRESZ: ispresizer_set_inaddr()-
>> ISPRESZ: ispresizer_config_outlineoffset()+
>> ISPRESZ: ispresizer_config_outlineoffset()-
>> ISPRESZ: ispresizer_config_ycpos()+
>> isp_reg_and_or
>> ISPRESZ: ispresizer_config_ycpos()-
>> ISPRESZ: ispresizer_config_size()-
>> omap34xxcam_s_pix_parm 2 0
>> OV5620: ioctl_g_fmt_cap
>> OV5620: ioctl_s_fmt_cap
>> OV5620: ioctl_try_fmt_cap
>> OV5620: ioctl_try_fmt_cap WIDTH = 640
>> OV5620: ioctl_try_fmt_cap HEIGHT = 480
>> omap34xxcam_s_pix_parm 3 0
>> OV5620: ioctl_s_parm
>> OV5620 desired_fps = 7
>> omap34xxcam_s_pix_parm 4 0
>> video_do_ioctl
>> omap34xxcam_vidioc_reqbufs
>> omap34xxcam_vbq_setup
>> SETTING UP with SIZEIMAGE = 614400
>> isp_vbq_setup
>> isp_tmp_buf_alloc
>> isp_tmp_buf_free
>> ISPRESZ: ispresizer_set_inaddr()+
>> ISPRESZ: ispresizer_set_inaddr()-
>> video_do_ioctl
>> omap34xxcam_vidioc_querybuf
>> omap34xxcam_mmap
>> video_do_ioctl
>> omap34xxcam_vidioc_querybuf
>> omap34xxcam_mmap
>> video_do_ioctl
>> omap34xxcam_vidioc_querybuf
>> omap34xxcam_mmap
>> video_do_ioctl
>> omap34xxcam_vidioc_querybuf
>> omap34xxcam_mmap
>> video_do_ioctl
>> omap34xxcam_vidioc_qbuf
>> omap34xxcam_vbq_prepare
>> isp_vbq_prepare
>> isp_ispmmu_vmap
>> video_do_ioctl
>> omap34xxcam_vidioc_qbuf
>> omap34xxcam_vbq_prepare
>> isp_vbq_prepare
>> isp_ispmmu_vmap
>> video_do_ioctl
>> omap34xxcam_vidioc_qbuf
>> omap34xxcam_vbq_prepare
>> isp_vbq_prepare
>> isp_ispmmu_vmap
>> video_do_ioctl
>> omap34xxcam_vidioc_qbuf
>> omap34xxcam_vbq_prepare
>> isp_vbq_prepare
>> isp_ispmmu_vmap
>> video_do_ioctl
>> omap34xxcam_vidioc_streamon
>> omap34xxcam_slave_power_set
>> OV5620: ioctl_s_power
>> isp_set_xclk
>> isp_reg_and_or
>> ISPCTRL: isp_set_xclk(): cam_xclka set to 24000000 Hz
>> BOARD_OVERO_CAMERA: Switching Power to 1
>> OV5620: POWER ON
>> OV5620: Sensor Detected, calling configure
>> ov5620:configure
>> isp_start
>> omap34xxcam_vbq_queue
>> isp_buf_queue
>> isp_vbq_sync
>> isp_enable_int
>> isp_set_buf
>> ISPRESZ: ispresizer_set_outaddr()+
>> ISPRESZ: ispresizer_set_outaddr()-
>> isp_reg_and_or
>> ISPCTRL:<1>isp_buf_queue: queue 0 vb 0, mmu 000a4000
>> omap34xxcam_vbq_queue
>> isp_buf_queue
>> isp_vbq_sync
>> ISPCTRL:<1>isp_buf_queue: queue 1 vb 1, mmu 0013a000
>> omap34xxcam_vbq_queue
>> isp_buf_queue
>> isp_vbq_sync
>> ISPCTRL:<1>isp_buf_queue: queue 2 vb 2, mmu 001d0000
>> omap34xxcam_vbq_queue
>> isp_buf_queue
>> isp_vbq_sync
>> ISPCTRL:<1>isp_buf_queue: queue 3 vb 3, mmu 00266000
>> omap34xxcam_poll
>> omap34xxcam_poll
>> ISPCTRL: HS_VS_IRQ<6>ISPCTRL: OVF_IRQ<6>ISPCTRL:
>> -------!These were repeated several times!----------------------------
>> ISPCTRL: HS_VS_IRQ<6>ISPCTRL: OVF_IRQ<6>ISPCTRL:
>> omap34xxcam_poll
>> ISPCTRL: HS_VS_IRQ<6>ISPCTRL: OVF_IRQ<6>ISPCTRL:
>> omap34xxcam_vbq_release
>> omap34xxcam_vbq_release
>> omap34xxcam_vbq_release
>> omap34xxcam_vbq_release
>> omap34xxcam_release
>> isp_stop
>> isp_disable_int
>> isp_stop_modules
>> isp_disable_modules
>> ISPH3A:     H3A disabled
>> ISPHIST:    histogram disabled
>> isp_reg_and_or
>> ISPRESZ: +ispresizer_enable()+
>> ISPRESZ: +ispresizer_enable()-
>> isp_reg_and
>> isp_reg_and_or
>> omap3isp omap3isp: __isp_disable_modules: can't stop ccdc
>> isp_icsi_enable
>> isp_reg_and_or
>> isp_buf_init
>> isp_vbq_sync
>> omap34xxcam_vbq_complete
>> isp_vbq_sync
>> omap34xxcam_vbq_complete
>> isp_vbq_sync
>> omap34xxcam_vbq_complete
>> isp_vbq_sync
>> omap34xxcam_vbq_complete
>> isp_save_ctx
>> isp_save_context
>> isp_save_context
>> iommu_save_ctx
>> ISPHIST:  Saving context
>> isp_save_context
>> ISPH3A:  Saving context
>> isp_save_context
>> isp_save_context
>> ISPRESZ: Saving context
>> isp_save_context
>> isp_reset
>> isp_restore_ctx
>> isp_restore_context
>> isp_restore_context
>> iommu_restore_ctx
>> ISPHIST:  Restoring context
>> isp_restore_context
>> ISPH3A:  Restoring context
>> isp_restore_context
>> isp_restore_context
>> ISPRESZ: Restoring context
>> isp_restore_context
>> omap34xxcam_vbq_release
>> isp_vbq_release
>> isp_vunmap
>> omap34xxcam_vbq_release
>> isp_vbq_release
>> isp_vunmap
>> omap34xxcam_vbq_release
>> isp_vbq_release
>> isp_vunmap
>> omap34xxcam_vbq_release
>> isp_vbq_release
>> isp_vunmap
>> omap34xxcam_slave_power_set
>> OV5620: ioctl_s_power
>> BOARD_OVERO_CAMERA: Switching Power to 2
>> OV5620: POWER STANDBY
>> isp_set_xclk
>> isp_reg_and_or
>> ISPCTRL: isp_set_xclk(): cam_xclka set to 0 Hz
>> omap34xxcam_slave_power_set
>> OV5620: ioctl_s_power
>> OV5620: POWER OFF
>> BOARD_OVERO_CAMERA: Switching Power to 0
>> OV5620: POWER OFF
>> isp_set_xclk
>> isp_reg_and_or
>> ISPCTRL: isp_set_xclk(): cam_xclka set to 0 Hz
>> isp_put
>> ISPCTRL: isp_put: old 1
>> isp_save_ctx
>> isp_save_context
>> isp_save_context
>> iommu_save_ctx
>> ISPHIST:  Saving context
>> isp_save_context
>> ISPH3A:  Saving context
>> isp_save_context
>> isp_save_context
>> ISPRESZ: Saving context
>> isp_save_context
>> isp_tmp_buf_free
>> isp_release_resources
>> isp_reg_and
>> isp_reg_and
>> isp_reg_and
>> isp_disable_clocks
>> ISPCTRL: isp_put: new 0
>>
>>
>> On Tue, Jul 14, 2009 at 1:24 PM, Eino-Ville Talvala
>> <talvala@stanford.edu>  wrote:
>>
>>>
>>> Zach,
>>>
>>> We've gotten a Aptina MT9P031 driver working with the latest ISP
>>> patchset, both with YUV and RAW data.
>>> I don't know what the problem might be with YUYV data - we get useful
>>> YUYV data without any changes to the ISP defaults.
>>> However, to request RAW data, that simply uses the CCDC and bypasses all
>>> the processing in the ISP, request the pixelformat of V4L2_PIX_FMT_SGRBG10.
>>>  This will give you two bytes per pixel, at least in our case (although we
>>> have a 12-bit sensor cut down to 10 bits), so be prepared to throw out every
>>> other byte.
>>>
>>> Hope this helps,
>>>
>>> Eino-Ville (Eddy) Talvala
>>> Computer Graphics Lab
>>> Stanford University
>>>
>>> On 7/14/2009 9:49 AM, Zach LeRoy wrote:
>>>
>>>>
>>>> Hello Sergio,
>>>>
>>>> I spoke with you earlier about using the ISP and omap34xxcam drivers
>>>> with a micron mt9d111 SOC sensor.  I have since been able to take pictures,
>>>> but the sensor data is not making it through the ISP data-path correctly.  I
>>>> know the problem is in the ISP data-path because I am configuring the sensor
>>>> the exact same way as I have been on my working PXA system.  I am expecting
>>>> 4:2:2 packed YUV data, but all of the U and V data is no more than 2 bits
>>>> where it should be 8.  I know the ISP has a lot of capabilities, but all I
>>>> want to use it for is grabbing 8-bit data from my sensor and putting it in a
>>>> buffer untouched using the CCDC interface (and of course clocking and
>>>> timing).  What are the key steps to take to get this type of configuration?
>>>>
>>>> Other Questions:
>>>>
>>>> Is there any processing done on YUV data in the ISP driver by default
>>>> that I am missing?
>>>> Has any one else experienced similar problems while adding new sensor
>>>> support?
>>>>
>>>> Any help here would be greatly appreciated.
>>>>
>>>> Thank you,
>>>>
>>>> Zach LeRoy
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>
>
