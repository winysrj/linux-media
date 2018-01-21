Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:35194 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750822AbeAUKVI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Jan 2018 05:21:08 -0500
Subject: Re: [PATCH v6 3/9] v4l: platform: Add Renesas CEU driver
To: jacopo mondi <jacopo@jmondi.org>
References: <1516139101-7835-1-git-send-email-jacopo+renesas@jmondi.org>
 <1516139101-7835-4-git-send-email-jacopo+renesas@jmondi.org>
 <d056343b-46be-436a-e316-0a588a182eb9@xs4all.nl>
 <20180121095323.GL24926@w540>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <55c3ab66-0886-4b2b-6842-ac07fc9138f3@xs4all.nl>
Date: Sun, 21 Jan 2018 11:21:05 +0100
MIME-Version: 1.0
In-Reply-To: <20180121095323.GL24926@w540>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/01/18 10:53, jacopo mondi wrote:
> Hi Hans,
> 
> On Fri, Jan 19, 2018 at 12:20:19PM +0100, Hans Verkuil wrote:
>> static int ov7670_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
>> {
>>         struct v4l2_captureparm *cp = &parms->parm.capture;
>>         struct ov7670_info *info = to_state(sd);
>>
>>         if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>                 return -EINVAL;
>>
>> And parms->type is CAPTURE_MPLANE. Just drop this test from the ov7670 driver
>> in the g/s_parm functions. It shouldn't test for that since a subdev driver
>> knows nothing about buffer types.
>>
> 
> I will drop that test in an additional patch part of next iteration of this series,

Replace g/s_parm by g/s_frame_interval. Consider g/s_parm for subdev drivers as
deprecated (I'm working on a patch series to replace all g/s_parm uses by
g/s_frame_interval).

Regards,

	Hans
