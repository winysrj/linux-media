Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:40531 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752125AbdIVQbG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 12:31:06 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8MGSue4005633
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 17:31:05 +0100
Received: from mail-pg0-f71.google.com (mail-pg0-f71.google.com [74.125.83.71])
        by mx07-00252a01.pphosted.com with ESMTP id 2d0sc03512-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 17:31:04 +0100
Received: by mail-pg0-f71.google.com with SMTP id m30so3067689pgn.2
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 09:31:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cf31b493-3f8a-8e0d-0e45-0b70898dd8b1@xs4all.nl>
References: <cover.1505140980.git.dave.stevenson@raspberrypi.org>
 <CAAoAYcM6puYbYTzyjqzmOzMPQMDZRENZskbvwgqQsuEFDNAU6A@mail.gmail.com> <cf31b493-3f8a-8e0d-0e45-0b70898dd8b1@xs4all.nl>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Fri, 22 Sep 2017 17:31:01 +0100
Message-ID: <CAAoAYcNZvS-0ikrO9yOubM67hEEAN9ATOeX-+nh89cNKrqbzTQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] BCM283x Camera Receiver driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22 September 2017 at 12:00, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 13/09/17 17:49, Dave Stevenson wrote:
>> OV5647
>>
>> v4l2-compliance SHA   : f6ecbc90656815d91dc6ba90aac0ad8193a14b38
>>
>> Driver Info:
>>     Driver name   : unicam
>>     Card type     : unicam
>>     Bus info      : platform:unicam 3f801000.csi1
>>     Driver version: 4.13.0
>>     Capabilities  : 0x85200001
>>         Video Capture
>>         Read/Write
>>         Streaming
>>         Extended Pix Format
>>         Device Capabilities
>>     Device Caps   : 0x05200001
>>         Video Capture
>>         Read/Write
>>         Streaming
>>         Extended Pix Format
>>
>> Compliance test for device /dev/video0 (not using libv4l2):
>>
>> Required ioctls:
>>     test VIDIOC_QUERYCAP: OK
>>
>> Allow for multiple opens:
>>     test second video open: OK
>>     test VIDIOC_QUERYCAP: OK
>>     test VIDIOC_G/S_PRIORITY: OK
>>     test for unlimited opens: OK
>>
>> Debug ioctls:
>>     test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>>     test VIDIOC_LOG_STATUS: OK
>>
>> Input ioctls:
>>     test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>>     test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>     test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>>     test VIDIOC_ENUMAUDIO: OK (Not Supported)
>>     test VIDIOC_G/S/ENUMINPUT: OK
>>     test VIDIOC_G/S_AUDIO: OK (Not Supported)
>>     Inputs: 1 Audio Inputs: 0 Tuners: 0
>>
>> Output ioctls:
>>     test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>>     test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>     test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>>     test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>>     test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>>     Outputs: 0 Audio Outputs: 0 Modulators: 0
>>
>> Input/Output configuration ioctls:
>>     test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>>     test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>>     test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>>     test VIDIOC_G/S_EDID: OK (Not Supported)
>>
>> Test input 0:
>>
>>     Control ioctls:
>>         test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>>         test VIDIOC_QUERYCTRL: OK
>>         test VIDIOC_G/S_CTRL: OK
>>         fail: v4l2-test-controls.cpp(587): g_ext_ctrls does not
>> support count == 0
>
> Huh. The issue here is that there are no controls at all, but the
> control API is present. The class_check() function in v4l2-ctrls.c expects
> that there are controls and if not it returns -EINVAL, causing this test
> to fail.
>
> Try to apply this patch:
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index dd1db678718c..4e53a8654690 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -2818,7 +2818,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
>  {
>         if (which == 0 || which == V4L2_CTRL_WHICH_DEF_VAL)
> -               return list_empty(&hdl->ctrl_refs) ? -EINVAL : 0;
> +               return 0;
>         return find_ref_lock(hdl, which | 1) ? 0 : -EINVAL;
>  }
>
>
> and see if it will pass the compliance test. There may be other issues.
> I think that the compliance test should handle the case where there are no
> controls, so this is a good test.

Fails.
        fail: v4l2-test-controls.cpp(589): g_ext_ctrls worked even
when no controls are present
        test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL

> That said, another solution is that the driver detects that there are no
> controls in unicam_probe_complete() and sets unicam->v4l2_dev.ctrl_handler
> to NULL.
>
> I think you should do this in v4. Having control ioctls but no actual controls
> is not wrong as such, but it is a bit misleading towards the application.

OK, will do.

  Dave
