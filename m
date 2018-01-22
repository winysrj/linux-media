Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:35995 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750926AbeAVJ4q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 04:56:46 -0500
Subject: Re: [PATCH v6 3/9] v4l: platform: Add Renesas CEU driver
To: jacopo mondi <jacopo@jmondi.org>
References: <1516139101-7835-1-git-send-email-jacopo+renesas@jmondi.org>
 <1516139101-7835-4-git-send-email-jacopo+renesas@jmondi.org>
 <d056343b-46be-436a-e316-0a588a182eb9@xs4all.nl>
 <20180121095323.GL24926@w540>
 <55c3ab66-0886-4b2b-6842-ac07fc9138f3@xs4all.nl>
 <e9623e9c-6444-2531-62c0-feed622c6e3b@xs4all.nl>
 <20180121172907.GO24926@w540>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c91b4aa3-23e7-248b-00ee-c219185fe716@xs4all.nl>
Date: Mon, 22 Jan 2018 10:56:43 +0100
MIME-Version: 1.0
In-Reply-To: <20180121172907.GO24926@w540>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/01/18 18:29, jacopo mondi wrote:
> Hi Hans,
> 
> On Sun, Jan 21, 2018 at 11:23:12AM +0100, Hans Verkuil wrote:
>> On 21/01/18 11:21, Hans Verkuil wrote:
>>> On 21/01/18 10:53, jacopo mondi wrote:
>>>> Hi Hans,
>>>>
>>>> On Fri, Jan 19, 2018 at 12:20:19PM +0100, Hans Verkuil wrote:
>>>>> static int ov7670_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
>>>>> {
>>>>>         struct v4l2_captureparm *cp = &parms->parm.capture;
>>>>>         struct ov7670_info *info = to_state(sd);
>>>>>
>>>>>         if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>>>>                 return -EINVAL;
>>>>>
>>>>> And parms->type is CAPTURE_MPLANE. Just drop this test from the ov7670 driver
>>>>> in the g/s_parm functions. It shouldn't test for that since a subdev driver
>>>>> knows nothing about buffer types.
>>>>>
>>>>
>>>> I will drop that test in an additional patch part of next iteration of this series,
>>>
>>> Replace g/s_parm by g/s_frame_interval. Consider g/s_parm for subdev drivers as
>>> deprecated (I'm working on a patch series to replace all g/s_parm uses by
>>> g/s_frame_interval).
>>
>> Take a look here:
>>
>> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=parm
>>
>> You probably want to use the patch 'v4l2-common: add g/s_parm helper functions'
>> for the new ceu driver in your patch series. Feel free to add it.
> 
> Thanks, I have now re-based my series on top of your 'parm' branch,
> and now I have silenced those errors on bad frame interval.
> 
> CEU g/s_parm now look like this:
> 
> static int ceu_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
> {
> 	struct ceu_device *ceudev = video_drvdata(file);
> 	int ret;
> 
> 	ret = v4l2_g_parm(V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
> 			  ceudev->sd->v4l2_sd, a);
> 	if (ret)
> 		return ret;
> 
> 	a->parm.capture.readbuffers = 0;
> 
> 	return 0;
> }
> 
> Very similar to what you've done on other platform drivers in this
> commit:
> https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=parm&id=a58956ef45cebaa5ce43a5f740fe04517b24a853
> 
> I have a question though (please bear with me a little more :)
> I had to manually set a->parm.capture.readbuffers to 0 to silence the following
> error in v4l2_compliance (which I have now updated to the most recent
> remote HEAD):
> 
>  fail: v4l2-test-formats.cpp(1114): cap->readbuffers
>                 test VIDIOC_G/S_PARM: FAIL
> 
> 		fail_on_test(cap->readbuffers > VIDEO_MAX_FRAME);
> 		if (!(node->g_caps() & V4L2_CAP_READWRITE))
> 			fail_on_test(cap->readbuffers);
> 		else if (node->g_caps() & V4L2_CAP_STREAMING)
> 			fail_on_test(!cap->readbuffers);
> 
> CEU does not support CAP_READWRITE, as it seems atmel-isc/isi do not, so
> v4l2-compliance wants to have readbuffers set to 0. I wonder why in
> the previously mentioned commit you didn't have to set readbuffers
> explicitly to 0 for atmel-isc/isi as I had to for CEU. Will v4l2-compliance
> fail if run on atmel-isc/isi with your commit, or am I missing something?

I've reworked the g/s_parm helper functions so they will now check for
the READWRITE capability and set readbuffers accordingly. I'll post a new
version later today.

Thanks for testing this, I missed that corner case.

Regards,

	Hans
