Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f54.google.com ([209.85.210.54]:60557 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab3B1PJi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Feb 2013 10:09:38 -0500
Message-ID: <512F732B.4070804@gmail.com>
Date: Thu, 28 Feb 2013 23:09:31 +0800
From: Lonsn <lonsn2005@gmail.com>
MIME-Version: 1.0
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: SMDKV210 support issue in kernel 3.8 (dma-pl330 and HDMI failed)
References: <51275DF7.4010600@gmail.com> <512CB1BE.1070401@gmail.com> <512D160D.1050706@gmail.com> <512D1BFB.4000700@gmail.com> <512E22AA.8020006@gmail.com> <512E2ABF.1080206@gmail.com> <512E7D97.4000608@gmail.com> <512F4D5E.5090900@gmail.com>
In-Reply-To: <512F4D5E.5090900@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HDMI output is OK now, it's a variable init question in 'struct 
v4l2_buffer buf' when call ioctl(fd, VIDIOC_DQBUF, &buf) in the hdmi 
example application. Add m.planes in buf then OK.
Thanks all!
I will continue to test the mfc decoder for s5pv210.

Regards,

于 2013/2/28 20:28, Lonsn 写道:
> 于 2013/2/28 5:41, Sylwester Nawrocki 写道:
>> On 02/27/2013 04:48 PM, Lonsn wrote:
>>> 于 2013/2/27 23:13, Lonsn 写道:
>>>>> On 02/26/2013 09:07 PM, Sylwester Nawrocki wrote:
>>>>>> On 02/26/2013 01:59 PM, Lonsn wrote:
>> [...]
>>>> Now kernel prints the following HDMI related:
>>>> m2m-testdev m2m-testdev.0: mem2mem-testdevDevice registered as
>>>> /dev/video0
>>>> s5p-jpeg s5p-jpeg.0: encoder device registered as /dev/video1
>>>> s5p-jpeg s5p-jpeg.0: decoder device registered as /dev/video2
>>>> s5p-jpeg s5p-jpeg.0: Samsung S5P JPEG codec
>>>> s5p-mfc s5p-mfc: decoder registered as /dev/video3
>>>> s5p-mfc s5p-mfc: encoder registered as /dev/video4
>>>> s5p-hdmi s5pv210-hdmi: probe start
>>>> s5p-hdmi s5pv210-hdmi: HDMI resource init
>>>> s5p-hdmiphy 3-0038: probe successful
>>>> s5p-hdmi s5pv210-hdmi: probe successful
>>>> Samsung TV Mixer driver, (c) 2010-2011 Samsung Electronics Co., Ltd.
>>>>
>>>> s5p-mixer s5p-mixer: probe start
>>>> s5p-mixer s5p-mixer: resources acquired
>>>> s5p-mixer s5p-mixer: added output 'S5P HDMI connector' from module
>>>> 's5p-hdmi'
>>>> s5p-mixer s5p-mixer: module s5p-sdo provides no subdev!
>>>> s5p-mixer s5p-mixer: registered layer graph0 as /dev/video5
>>>> s5p-mixer s5p-mixer: registered layer graph1 as /dev/video6
>>>> s5p-mixer s5p-mixer: registered layer video0 as /dev/video7
>>>> s5p-mixer s5p-mixer: probe successful
>>>>
>>>> How can I test the HDMI output whether it's OK? Which /dev/video is
>>>> real
>>>> HDMI output? I have used
>>>> http://git.infradead.org/users/kmpark/public-apps hdmi test program buf
>>>> failed:
>>>> root@linaro-developer:/opt# ./tvdemo /dev/video7 720 480 0 0
>>>> ERROR(main.c:80) : VIDIOC_S_FMT failed: Invalid argument
>>
>> It failed because you've opened device node of the Video Processor, which
>> supports only NV12/21(MT) formats. I believe the v4l2-hdmi-example
>> application, which renders some simple test images, needs to be run with
>> one
>> the graphics layer video nodes as an argument.  Doesn't it work when you
>> try
>> on /dev/video5 or /dev/video6 ?
> I have tested /dev/video5 and /dev/video6, the same output as following:
> root@linaro-developer:/opt# ./tvdemo /dev/video5 720 480 0 0
> start
> ERROR(main.c:256) : VIDIOC_DQBUF failed: Invalid argument
> Aborted
> root@linaro-developer:/opt# dmesg
> s5p-mixer s5p-mixer: mxr_video_open:762
> s5p-mixer s5p-mixer: resume - start
> s5p-mixer s5p-mixer: resume - finished
> s5p-hdmi s5pv210-hdmi: hdmi_g_mbus_fmt
> s5p-mixer s5p-mixer: src.full_size = (720, 480)
> s5p-mixer s5p-mixer: src.size = (720, 480)
> s5p-mixer s5p-mixer: src.offset = (0, 0)
> s5p-mixer s5p-mixer: dst.full_size = (720, 480)
> s5p-mixer s5p-mixer: dst.size = (720, 480)
> s5p-mixer s5p-mixer: dst.offset = (0, 0)
> s5p-mixer s5p-mixer: ratio = (0, 0)
> s5p-mixer s5p-mixer: src.full_size = (720, 480)
> s5p-mixer s5p-mixer: src.size = (720, 480)
> s5p-mixer s5p-mixer: src.offset = (0, 0)
> s5p-mixer s5p-mixer: dst.full_size = (720, 480)
> s5p-mixer s5p-mixer: dst.size = (720, 480)
> s5p-mixer s5p-mixer: dst.offset = (0, 0)
> s5p-mixer s5p-mixer: ratio = (0, 0)
> s5p-mixer s5p-mixer: mxr_s_fmt:322
> s5p-mixer s5p-mixer: src.full_size = (720, 480)
> s5p-mixer s5p-mixer: src.size = (720, 480)
> s5p-mixer s5p-mixer: src.offset = (0, 0)
> s5p-mixer s5p-mixer: dst.full_size = (720, 480)
> s5p-mixer s5p-mixer: dst.size = (720, 480)
> s5p-mixer s5p-mixer: dst.offset = (0, 0)
> s5p-mixer s5p-mixer: ratio = (0, 0)
> s5p-mixer s5p-mixer: src.full_size = (720, 480)
> s5p-mixer s5p-mixer: src.size = (720, 480)
> s5p-mixer s5p-mixer: src.offset = (0, 0)
> s5p-mixer s5p-mixer: dst.full_size = (720, 480)
> s5p-mixer s5p-mixer: dst.size = (720, 480)
> s5p-mixer s5p-mixer: dst.offset = (0, 0)
> s5p-mixer s5p-mixer: ratio = (0, 0)
> s5p-mixer s5p-mixer: src.full_size = (720, 480)
> s5p-mixer s5p-mixer: src.size = (720, 480)
> s5p-mixer s5p-mixer: src.offset = (0, 0)
> s5p-mixer s5p-mixer: dst.full_size = (720, 480)
> s5p-mixer s5p-mixer: dst.size = (720, 480)
> s5p-mixer s5p-mixer: dst.offset = (0, 0)
> s5p-mixer s5p-mixer: ratio = (0, 0)
> s5p-mixer s5p-mixer: mxr_g_fmt:301
> s5p-mixer s5p-mixer: mxr_g_fmt:301
> s5p-mixer s5p-mixer: mxr_reqbufs:672
> s5p-mixer s5p-mixer: queue_setup
> s5p-mixer s5p-mixer: fmt = ARGB8888
> s5p-mixer s5p-mixer: size[0] = 00151800
> s5p-mixer s5p-mixer: mxr_querybuf:680
> s5p-mixer s5p-mixer: mxr_video_mmap:829
> s5p-mixer s5p-mixer: mxr_querybuf:680
> s5p-mixer s5p-mixer: mxr_video_mmap:829
> s5p-mixer s5p-mixer: mxr_querybuf:680
> s5p-mixer s5p-mixer: mxr_video_mmap:829
> s5p-mixer s5p-mixer: mxr_s_selection: rect: 720x480@0,0
> s5p-mixer s5p-mixer: src.full_size = (720, 480)
> s5p-mixer s5p-mixer: src.size = (720, 480)
> s5p-mixer s5p-mixer: src.offset = (0, 0)
> s5p-mixer s5p-mixer: dst.full_size = (720, 480)
> s5p-mixer s5p-mixer: dst.size = (720, 480)
> s5p-mixer s5p-mixer: dst.offset = (0, 0)
> s5p-mixer s5p-mixer: ratio = (0, 0)
> s5p-mixer s5p-mixer: mxr_qbuf:688(0)
> s5p-mixer s5p-mixer: mxr_qbuf:688(1)
> s5p-mixer s5p-mixer: mxr_qbuf:688(2)
> s5p-mixer s5p-mixer: mxr_streamon:713
> s5p-mixer s5p-mixer: queuing buffer
> s5p-mixer s5p-mixer: queuing buffer
> s5p-mixer s5p-mixer: queuing buffer
> s5p-mixer s5p-mixer: start_streaming
> s5p-mixer s5p-mixer: mxr_output_get(1)
> s5p-hdmi s5pv210-hdmi: hdmi_runtime_resume
> s5p-hdmi s5pv210-hdmi: poweron succeed
> s5p-hdmi s5pv210-hdmi: hdmi_g_mbus_fmt
> s5p-mixer s5p-mixer: src.full_size = (720, 480)
> s5p-mixer s5p-mixer: src.size = (720, 480)
> s5p-mixer s5p-mixer: src.offset = (0, 0)
> s5p-mixer s5p-mixer: dst.full_size = (720, 480)
> s5p-mixer s5p-mixer: dst.size = (720, 480)
> s5p-mixer s5p-mixer: dst.offset = (0, 0)
> s5p-mixer s5p-mixer: ratio = (0, 0)
> s5p-mixer s5p-mixer: mxr_streamer_get(1)
> s5p-hdmi s5pv210-hdmi: hdmi_g_mbus_fmt
> s5p-hdmi s5pv210-hdmi: hdmi_s_stream(1)
> s5p-hdmi s5pv210-hdmi: hdmi_streamon
> s5p-hdmi s5pv210-hdmi: hdmi_conf_apply
> s5p-hdmiphy 3-0038: s_dv_preset(preset = 1)
> s5p-tv (hdmi_drv): unplugged
> s5p-hdmiphy 3-0038: s_stream(1)
> s5p-hdmi s5pv210-hdmi: streamon: ---- CONTROL REGISTERS ----
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_INTC_FLAG = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_INTC_CON = 0000004c
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_HPD_STATUS = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_PHY_RSTOUT = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_PHY_VPLL = 0000008c
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_PHY_CMU = 00000080
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_CORE_RSTOUT = 00000001
> s5p-hdmi s5pv210-hdmi: streamon: ---- CORE REGISTERS ----
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_CON_0 = 00000001
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_CON_1 = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_CON_2 = 00000022
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_SYS_STATUS = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_PHY_STATUS = 00000001
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_STATUS_EN = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_HPD = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_MODE_SEL = 00000001
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_HPD_GEN = 00000001
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_DC_CONTROL = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_VIDEO_PATTERN_GEN = 00000000
> s5p-hdmi s5pv210-hdmi: streamon: ---- CORE SYNC REGISTERS ----
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_H_BLANK_0 = 0000008a
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_H_BLANK_1 = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_BLANK_0 = 0000000d
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_BLANK_1 = 0000006a
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_BLANK_2 = 00000001
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_H_V_LINE_0 = 0000000d
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_H_V_LINE_1 = 000000a2
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_H_V_LINE_2 = 00000035
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_VSYNC_POL = 00000001
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_INT_PRO_MODE = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_BLANK_F_0 = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_BLANK_F_1 = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_BLANK_F_2 = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_H_SYNC_GEN_0 = 00000010
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_H_SYNC_GEN_1 = 00000038
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_H_SYNC_GEN_2 = 00000011
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_SYNC_GEN_1_0 = 0000000f
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_SYNC_GEN_1_1 = 00000090
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_SYNC_GEN_1_2 = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_SYNC_GEN_2_0 = 00000001
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_SYNC_GEN_2_1 = 00000010
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_SYNC_GEN_2_2 = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_SYNC_GEN_3_0 = 00000001
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_SYNC_GEN_3_1 = 00000010
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_V_SYNC_GEN_3_2 = 00000000
> s5p-hdmi s5pv210-hdmi: streamon: ---- TG REGISTERS ----
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_CMD = 00000001
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_H_FSZ_L = 0000005a
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_H_FSZ_H = 00000003
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_HACT_ST_L = 0000008a
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_HACT_ST_H = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_HACT_SZ_L = 000000d0
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_HACT_SZ_H = 00000002
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_V_FSZ_L = 0000000d
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_V_FSZ_H = 00000002
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VSYNC_L = 00000009
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VSYNC_H = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VSYNC2_L = 00000033
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VSYNC2_H = 00000002
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VACT_ST_L = 0000002d
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VACT_ST_H = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VACT_SZ_L = 000000e0
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VACT_SZ_H = 00000001
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_FIELD_CHG_L = 00000033
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_FIELD_CHG_H = 00000002
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VACT_ST2_L = 00000048
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VACT_ST2_H = 00000002
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VSYNC_TOP_HDMI_L = 00000009
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VSYNC_TOP_HDMI_H = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VSYNC_BOT_HDMI_L = 00000033
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_VSYNC_BOT_HDMI_H = 00000002
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_FIELD_TOP_HDMI_L = 00000009
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_FIELD_TOP_HDMI_H = 00000000
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_FIELD_BOT_HDMI_L = 00000033
> s5p-hdmi s5pv210-hdmi: streamon:HDMI_TG_FIELD_BOT_HDMI_H = 00000002
> s5p-mixer s5p-mixer: MXR_STATUS = 00000085
> s5p-mixer s5p-mixer: MXR_CFG = 00000194
> s5p-mixer s5p-mixer: MXR_INT_EN = 00000700
> s5p-mixer s5p-mixer: MXR_INT_STATUS = 00000000
> s5p-mixer s5p-mixer: MXR_LAYER_CFG = 00000312
> s5p-mixer s5p-mixer: MXR_VIDEO_CFG = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC0_CFG = 003007ff
> s5p-mixer s5p-mixer: MXR_GRAPHIC0_BASE = 4d600000
> s5p-mixer s5p-mixer: MXR_GRAPHIC0_SPAN = 000002d0
> s5p-mixer s5p-mixer: MXR_GRAPHIC0_WH = 02d001e0
> s5p-mixer s5p-mixer: MXR_GRAPHIC0_SXY = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC0_DXY = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC1_CFG = 003000ff
> s5p-mixer s5p-mixer: MXR_GRAPHIC1_BASE = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC1_SPAN = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC1_WH = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC1_SXY = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC1_DXY = 00000000
> s5p-mixer s5p-mixer: VP_ENABLE = 00000002
> s5p-mixer s5p-mixer: VP_SRESET = 00000000
> s5p-mixer s5p-mixer: VP_SHADOW_UPDATE = 00000001
> s5p-mixer s5p-mixer: VP_FIELD_ID = 00000000
> s5p-mixer s5p-mixer: VP_MODE = 00000000
> s5p-mixer s5p-mixer: VP_IMG_SIZE_Y = 00000000
> s5p-mixer s5p-mixer: VP_IMG_SIZE_C = 00000000
> s5p-mixer s5p-mixer: VP_PER_RATE_CTRL = 00000000
> s5p-mixer s5p-mixer: VP_TOP_Y_PTR = 00000000
> s5p-mixer s5p-mixer: VP_BOT_Y_PTR = 00000000
> s5p-mixer s5p-mixer: VP_TOP_C_PTR = 00000000
> s5p-mixer s5p-mixer: VP_BOT_C_PTR = 00000000
> s5p-mixer s5p-mixer: VP_ENDIAN_MODE = 00000000
> s5p-mixer s5p-mixer: VP_SRC_H_POSITION = 00000000
> s5p-mixer s5p-mixer: VP_SRC_V_POSITION = 00000000
> s5p-mixer s5p-mixer: VP_SRC_WIDTH = 00000000
> s5p-mixer s5p-mixer: VP_SRC_HEIGHT = 00000000
> s5p-mixer s5p-mixer: VP_DST_H_POSITION = 00000000
> s5p-mixer s5p-mixer: VP_DST_V_POSITION = 00000000
> s5p-mixer s5p-mixer: VP_DST_WIDTH = 00000000
> s5p-mixer s5p-mixer: VP_DST_HEIGHT = 00000000
> s5p-mixer s5p-mixer: VP_H_RATIO = 00000000
> s5p-mixer s5p-mixer: VP_V_RATIO = 00000000
> s5p-mixer s5p-mixer: mxr_dqbuf:696
> s5p-mixer s5p-mixer: wait_unlock
> s5p-mixer s5p-mixer: wait_lock
> s5p-mixer s5p-mixer: mxr_video_release:842
> s5p-mixer s5p-mixer: stop_streaming
> s5p-mixer s5p-mixer: mxr_streamer_put(0)
> s5p-hdmi s5pv210-hdmi: hdmi_s_stream(0)
> s5p-hdmi s5pv210-hdmi: hdmi_streamoff
> s5p-hdmiphy 3-0038: s_stream(0)
> s5p-hdmi s5pv210-hdmi: streamoff: ---- CONTROL REGISTERS ----
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_INTC_FLAG = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_INTC_CON = 0000004c
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_HPD_STATUS = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_PHY_RSTOUT = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_PHY_VPLL = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_PHY_CMU = 00000080
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_CORE_RSTOUT = 00000001
> s5p-hdmi s5pv210-hdmi: streamoff: ---- CORE REGISTERS ----
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_CON_0 = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_CON_1 = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_CON_2 = 00000022
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_SYS_STATUS = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_PHY_STATUS = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_STATUS_EN = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_HPD = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_MODE_SEL = 00000001
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_HPD_GEN = 00000001
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_DC_CONTROL = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_VIDEO_PATTERN_GEN = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff: ---- CORE SYNC REGISTERS ----
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_H_BLANK_0 = 0000008a
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_H_BLANK_1 = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_BLANK_0 = 0000000d
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_BLANK_1 = 0000006a
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_BLANK_2 = 00000001
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_H_V_LINE_0 = 0000000d
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_H_V_LINE_1 = 000000a2
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_H_V_LINE_2 = 00000035
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_VSYNC_POL = 00000001
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_INT_PRO_MODE = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_BLANK_F_0 = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_BLANK_F_1 = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_BLANK_F_2 = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_H_SYNC_GEN_0 = 00000010
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_H_SYNC_GEN_1 = 00000038
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_H_SYNC_GEN_2 = 00000011
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_SYNC_GEN_1_0 = 0000000f
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_SYNC_GEN_1_1 = 00000090
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_SYNC_GEN_1_2 = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_SYNC_GEN_2_0 = 00000001
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_SYNC_GEN_2_1 = 00000010
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_SYNC_GEN_2_2 = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_SYNC_GEN_3_0 = 00000001
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_SYNC_GEN_3_1 = 00000010
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_V_SYNC_GEN_3_2 = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff: ---- TG REGISTERS ----
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_CMD = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_H_FSZ_L = 0000005a
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_H_FSZ_H = 00000003
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_HACT_ST_L = 0000008a
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_HACT_ST_H = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_HACT_SZ_L = 000000d0
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_HACT_SZ_H = 00000002
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_V_FSZ_L = 0000000d
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_V_FSZ_H = 00000002
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VSYNC_L = 00000009
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VSYNC_H = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VSYNC2_L = 00000033
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VSYNC2_H = 00000002
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VACT_ST_L = 0000002d
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VACT_ST_H = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VACT_SZ_L = 000000e0
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VACT_SZ_H = 00000001
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_FIELD_CHG_L = 00000033
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_FIELD_CHG_H = 00000002
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VACT_ST2_L = 00000048
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VACT_ST2_H = 00000002
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VSYNC_TOP_HDMI_L = 00000009
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VSYNC_TOP_HDMI_H = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VSYNC_BOT_HDMI_L = 00000033
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_VSYNC_BOT_HDMI_H = 00000002
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_FIELD_TOP_HDMI_L = 00000009
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_FIELD_TOP_HDMI_H = 00000000
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_FIELD_BOT_HDMI_L = 00000033
> s5p-hdmi s5pv210-hdmi: streamoff:HDMI_TG_FIELD_BOT_HDMI_H = 00000002
> s5p-mixer s5p-mixer: MXR_STATUS = 00000086
> s5p-mixer s5p-mixer: MXR_CFG = 00000184
> s5p-mixer s5p-mixer: MXR_INT_EN = 00000700
> s5p-mixer s5p-mixer: MXR_INT_STATUS = 00000000
> s5p-mixer s5p-mixer: MXR_LAYER_CFG = 00000312
> s5p-mixer s5p-mixer: MXR_VIDEO_CFG = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC0_CFG = 003007ff
> s5p-mixer s5p-mixer: MXR_GRAPHIC0_BASE = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC0_SPAN = 000002d0
> s5p-mixer s5p-mixer: MXR_GRAPHIC0_WH = 02d001e0
> s5p-mixer s5p-mixer: MXR_GRAPHIC0_SXY = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC0_DXY = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC1_CFG = 003000ff
> s5p-mixer s5p-mixer: MXR_GRAPHIC1_BASE = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC1_SPAN = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC1_WH = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC1_SXY = 00000000
> s5p-mixer s5p-mixer: MXR_GRAPHIC1_DXY = 00000000
> s5p-mixer s5p-mixer: VP_ENABLE = 00000002
> s5p-mixer s5p-mixer: VP_SRESET = 00000000
> s5p-mixer s5p-mixer: VP_SHADOW_UPDATE = 00000000
> s5p-mixer s5p-mixer: VP_FIELD_ID = 00000000
> s5p-mixer s5p-mixer: VP_MODE = 00000000
> s5p-mixer s5p-mixer: VP_IMG_SIZE_Y = 00000000
> s5p-mixer s5p-mixer: VP_IMG_SIZE_C = 00000000
> s5p-mixer s5p-mixer: VP_PER_RATE_CTRL = 00000000
> s5p-mixer s5p-mixer: VP_TOP_Y_PTR = 00000000
> s5p-mixer s5p-mixer: VP_BOT_Y_PTR = 00000000
> s5p-mixer s5p-mixer: VP_TOP_C_PTR = 00000000
> s5p-mixer s5p-mixer: VP_BOT_C_PTR = 00000000
> s5p-mixer s5p-mixer: VP_ENDIAN_MODE = 00000000
> s5p-mixer s5p-mixer: VP_SRC_H_POSITION = 00000000
> s5p-mixer s5p-mixer: VP_SRC_V_POSITION = 00000000
> s5p-mixer s5p-mixer: VP_SRC_WIDTH = 00000000
> s5p-mixer s5p-mixer: VP_SRC_HEIGHT = 00000000
> s5p-mixer s5p-mixer: VP_DST_H_POSITION = 00000000
> s5p-mixer s5p-mixer: VP_DST_V_POSITION = 00000000
> s5p-mixer s5p-mixer: VP_DST_WIDTH = 00000000
> s5p-mixer s5p-mixer: VP_DST_HEIGHT = 00000000
> s5p-mixer s5p-mixer: VP_H_RATIO = 00000000
> s5p-mixer s5p-mixer: VP_V_RATIO = 00000000
> s5p-mixer s5p-mixer: mxr_output_put(0)
> s5p-hdmi s5pv210-hdmi: hdmi_runtime_suspend
> s5p-mixer s5p-mixer: suspend - start
> s5p-mixer s5p-mixer: suspend - finished
>>
>>>> root@linaro-developer:/opt#
>>>> Maybe I still miss some configuration in mach-smdkv210.c.
>>
>> I don't think so, it all looks more or less OK now :)
>>
>>> The kernel print when run tvdemo:
>>> root@linaro-developer:/opt# ./tvdemo /dev/video7 720 480 0 0
>>> ERROR(main.c:80) : VIDIOC_S_FMT failed: Invalid argument
>>> Aborted
>>> root@linaro-developer:/opt# dmesg
>>> s5p-mixer s5p-mixer: mxr_video_open:762
>>> s5p-mixer s5p-mixer: resume - start
>>> s5p-mixer s5p-mixer: resume - finished
>>> s5p-hdmi s5pv210-hdmi: hdmi_g_mbus_fmt
>>> s5p-mixer s5p-mixer: src.full_size = (720, 480)
>>> s5p-mixer s5p-mixer: src.size = (720, 480)
>>> s5p-mixer s5p-mixer: src.offset = (0, 0)
>>> s5p-mixer s5p-mixer: dst.full_size = (720, 480)
>>> s5p-mixer s5p-mixer: dst.size = (720, 480)
>>> s5p-mixer s5p-mixer: dst.offset = (0, 0)
>>> s5p-mixer s5p-mixer: ratio = (0, 0)
>>> s5p-mixer s5p-mixer: src.full_size = (720, 480)
>>> s5p-mixer s5p-mixer: src.size = (720, 480)
>>> s5p-mixer s5p-mixer: src.offset = (0, 0)
>>> s5p-mixer s5p-mixer: dst.full_size = (720, 480)
>>> s5p-mixer s5p-mixer: dst.size = (720, 480)
>>> s5p-mixer s5p-mixer: dst.offset = (0, 0)
>>> s5p-mixer s5p-mixer: ratio = (65536, 65536)
>>> s5p-mixer s5p-mixer: mxr_s_fmt:322
>>> s5p-mixer s5p-mixer: not recognized fourcc: 34524742
>>
>> Yes, it must definitely be incorrect video node. Only the graph0/1
>> devices support RGB.
>>
>> Regards,
>> Sylwester
>

