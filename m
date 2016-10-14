Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33966 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752443AbcJNPO3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 11:14:29 -0400
Received: by mail-it0-f67.google.com with SMTP id e203so941190itc.1
        for <linux-media@vger.kernel.org>; Fri, 14 Oct 2016 08:14:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161014123914.GA10745@e106950-lin.cambridge.arm.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
 <6e794da8-49de-0440-ea70-272bfe47332b@codeaurora.org> <20161014123914.GA10745@e106950-lin.cambridge.arm.com>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Fri, 14 Oct 2016 16:56:25 +0200
Message-ID: <CAKMK7uHYgZQsWg6GQ9nwknNfAc0PV+WPgP9VBoiVhT+Eij0Seg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] Introduce writeback connectors
To: Brian Starkey <brian.starkey@arm.com>
Cc: Archit Taneja <architt@codeaurora.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
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

On Fri, Oct 14, 2016 at 2:39 PM, Brian Starkey <brian.starkey@arm.com> wrote:
>> - Besides the above property, writeback hardware can have provisions
>> for scaling, color space conversion and rotation. This would mean that
>> we'd eventually add more writeback specific props/params in
>> drm_connector/drm_connector_state. Would we be okay adding more such
>> props for connectors?
>
>
> I've wondered the same thing about bloating non-writeback connectors
> with writeback-specific stuff. If it does become significant, maybe
> we should subclass drm_connector and add a drm_writeback_state pointer
> to drm_connector_state.

No pionters needed, just embedded drm_connector_state into
drm_writeback_connector_state as the "base" member. Then we can
provide ready-made atomic_set/get_property functions for the aditional
writeback functionality.

But tbh I'd only start doing that once we have a few more. It's purely
an implementation change, with no effect on userspace. And if you go
with my drm_writeback_connector_init idea, it won't even be an issue
for drivers.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
