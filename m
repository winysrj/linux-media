Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35724 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752263AbcJKQ4P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 12:56:15 -0400
Received: by mail-io0-f194.google.com with SMTP id p26so1959735ioo.2
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2016 09:56:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161011164751.GB14337@e106950-lin.cambridge.arm.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
 <1476197648-24918-3-git-send-email-brian.starkey@arm.com> <20161011154448.GE20761@phenom.ffwll.local>
 <20161011164751.GB14337@e106950-lin.cambridge.arm.com>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Tue, 11 Oct 2016 18:56:14 +0200
Message-ID: <CAKMK7uE0FYUVAf8ARD+HXNTVVbzdOzzU1ot2UbFFLQ9EQiVnfA@mail.gmail.com>
Subject: Re: [RFC PATCH 02/11] drm/fb-helper: Skip writeback connectors
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>,
        "Clark, Rob" <robdclark@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Eric Anholt <eric@anholt.net>,
        "Syrjala, Ville" <ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 11, 2016 at 6:47 PM, Brian Starkey <brian.starkey@arm.com> wrote:
> On Tue, Oct 11, 2016 at 05:44:48PM +0200, Daniel Vetter wrote:
>>
>> On Tue, Oct 11, 2016 at 03:53:59PM +0100, Brian Starkey wrote:
>>>
>>> Writeback connectors aren't much use to the fbdev helpers, as they won't
>>> show anything to the user. Skip them when looking for candidate output
>>> configurations.
>>>
>>> Signed-off-by: Brian Starkey <brian.starkey@arm.com>
>>> ---
>>>  drivers/gpu/drm/drm_fb_helper.c |    4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/gpu/drm/drm_fb_helper.c
>>> b/drivers/gpu/drm/drm_fb_helper.c
>>> index 03414bd..dedf6e7 100644
>>> --- a/drivers/gpu/drm/drm_fb_helper.c
>>> +++ b/drivers/gpu/drm/drm_fb_helper.c
>>> @@ -2016,6 +2016,10 @@ static int drm_pick_crtcs(struct drm_fb_helper
>>> *fb_helper,
>>>         if (modes[n] == NULL)
>>>                 return best_score;
>>>
>>> +       /* Writeback connectors aren't much use for fbdev */
>>> +       if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
>>> +               return best_score;
>>
>>
>> I think we could handle this by always marking writeback connectors as
>> disconnected. Userspace and fbdev emulation should then avoid them,
>> always.
>> -Daniel
>>
>
> Good idea; I'll need to take a closer look at how it would interact
> with the probe helper (connector->force etc).
>
> Are you thinking instead-of or in-addition-to the client cap? I'd be
> worried about apps doing strange things and trying to use even
> disconnected connectors.

Apps shouldn't try to use disconnected connectors, at least by
default. I think we wouldn't need the cap in that case.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
