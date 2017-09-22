Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:47208 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752261AbdIVRRM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 13:17:12 -0400
Subject: Re: [PATCH v2 0/4] BCM283x Camera Receiver driver
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
References: <cover.1505140980.git.dave.stevenson@raspberrypi.org>
 <CAAoAYcM6puYbYTzyjqzmOzMPQMDZRENZskbvwgqQsuEFDNAU6A@mail.gmail.com>
 <cf31b493-3f8a-8e0d-0e45-0b70898dd8b1@xs4all.nl>
 <CAAoAYcNZvS-0ikrO9yOubM67hEEAN9ATOeX-+nh89cNKrqbzTQ@mail.gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4570fde5-db67-1066-597c-698e7886a756@xs4all.nl>
Date: Fri, 22 Sep 2017 19:17:06 +0200
MIME-Version: 1.0
In-Reply-To: <CAAoAYcNZvS-0ikrO9yOubM67hEEAN9ATOeX-+nh89cNKrqbzTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/09/17 18:31, Dave Stevenson wrote:
> On 22 September 2017 at 12:00, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 13/09/17 17:49, Dave Stevenson wrote:
>>> OV5647
>>>
>>> v4l2-compliance SHA   : f6ecbc90656815d91dc6ba90aac0ad8193a14b38
>>>
>>> Driver Info:
>>>     Driver name   : unicam
>>>     Card type     : unicam
>>>     Bus info      : platform:unicam 3f801000.csi1
>>>     Driver version: 4.13.0
>>>     Capabilities  : 0x85200001
>>>         Video Capture
>>>         Read/Write
>>>         Streaming
>>>         Extended Pix Format
>>>         Device Capabilities
>>>     Device Caps   : 0x05200001
>>>         Video Capture
>>>         Read/Write
>>>         Streaming
>>>         Extended Pix Format
>>>
>>> Compliance test for device /dev/video0 (not using libv4l2):
>>>
>>> Required ioctls:
>>>     test VIDIOC_QUERYCAP: OK
>>>
>>> Allow for multiple opens:
>>>     test second video open: OK
>>>     test VIDIOC_QUERYCAP: OK
>>>     test VIDIOC_G/S_PRIORITY: OK
>>>     test for unlimited opens: OK
>>>
>>> Debug ioctls:
>>>     test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>>>     test VIDIOC_LOG_STATUS: OK
>>>
>>> Input ioctls:
>>>     test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>>>     test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>>     test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>>>     test VIDIOC_ENUMAUDIO: OK (Not Supported)
>>>     test VIDIOC_G/S/ENUMINPUT: OK
>>>     test VIDIOC_G/S_AUDIO: OK (Not Supported)
>>>     Inputs: 1 Audio Inputs: 0 Tuners: 0
>>>
>>> Output ioctls:
>>>     test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>>>     test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>>     test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>>>     test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>>>     test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>>>     Outputs: 0 Audio Outputs: 0 Modulators: 0
>>>
>>> Input/Output configuration ioctls:
>>>     test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>>>     test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>>>     test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>>>     test VIDIOC_G/S_EDID: OK (Not Supported)
>>>
>>> Test input 0:
>>>
>>>     Control ioctls:
>>>         test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>>>         test VIDIOC_QUERYCTRL: OK
>>>         test VIDIOC_G/S_CTRL: OK
>>>         fail: v4l2-test-controls.cpp(587): g_ext_ctrls does not
>>> support count == 0
>>
>> Huh. The issue here is that there are no controls at all, but the
>> control API is present. The class_check() function in v4l2-ctrls.c expects
>> that there are controls and if not it returns -EINVAL, causing this test
>> to fail.
>>
>> Try to apply this patch:
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index dd1db678718c..4e53a8654690 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -2818,7 +2818,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>>  static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
>>  {
>>         if (which == 0 || which == V4L2_CTRL_WHICH_DEF_VAL)
>> -               return list_empty(&hdl->ctrl_refs) ? -EINVAL : 0;
>> +               return 0;
>>         return find_ref_lock(hdl, which | 1) ? 0 : -EINVAL;
>>  }
>>
>>
>> and see if it will pass the compliance test. There may be other issues.
>> I think that the compliance test should handle the case where there are no
>> controls, so this is a good test.
> 
> Fails.
>         fail: v4l2-test-controls.cpp(589): g_ext_ctrls worked even
> when no controls are present
>         test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL

Try this patch:

-----------------
diff --git a/utils/v4l2-compliance/v4l2-test-controls.cpp b/utils/v4l2-compliance/v4l2-test-controls.cpp
index 7514459f..508daf05 100644
--- a/utils/v4l2-compliance/v4l2-test-controls.cpp
+++ b/utils/v4l2-compliance/v4l2-test-controls.cpp
@@ -585,8 +585,6 @@ int testExtendedControls(struct node *node)
 		return ret;
 	if (ret)
 		return fail("g_ext_ctrls does not support count == 0\n");
-	if (node->controls.empty())
-		return fail("g_ext_ctrls worked even when no controls are present\n");
 	if (ctrls.which)
 		return fail("field which changed\n");
 	if (ctrls.count)
@@ -600,8 +598,6 @@ int testExtendedControls(struct node *node)
 		return ret;
 	if (ret)
 		return fail("try_ext_ctrls does not support count == 0\n");
-	if (node->controls.empty())
-		return fail("try_ext_ctrls worked even when no controls are present\n");
 	if (ctrls.which)
 		return fail("field which changed\n");
 	if (ctrls.count)
@@ -687,6 +683,8 @@ int testExtendedControls(struct node *node)
 	}

 	ctrls.which = 0;
+	ctrls.count = 1;
+	ctrls.controls = &ctrl;
 	ctrl.id = 0;
 	ctrl.size = 0;
 	ret = doioctl(node, VIDIOC_G_EXT_CTRLS, &ctrls);
@@ -745,6 +743,9 @@ int testExtendedControls(struct node *node)
 	if (ret)
 		return fail("could not set all controls\n");

+	if (!which)
+		return 0;
+
 	ctrls.which = which;
 	ret = doioctl(node, VIDIOC_G_EXT_CTRLS, &ctrls);
 	if (ret && !multiple_classes)
----------------

Hans

> 
>> That said, another solution is that the driver detects that there are no
>> controls in unicam_probe_complete() and sets unicam->v4l2_dev.ctrl_handler
>> to NULL.
>>
>> I think you should do this in v4. Having control ioctls but no actual controls
>> is not wrong as such, but it is a bit misleading towards the application.
> 
> OK, will do.
> 
>   Dave
> 
