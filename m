Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34589 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753154AbcJKQ3W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 12:29:22 -0400
Received: by mail-it0-f67.google.com with SMTP id e203so1939403itc.1
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2016 09:29:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161011162559.GR4329@intel.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com> <20161011162559.GR4329@intel.com>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Tue, 11 Oct 2016 18:29:20 +0200
Message-ID: <CAKMK7uF5AbmAMdcWNGor5K5zR2EMcS-j9z-CwsV7KchT381Kbw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] Introduce writeback connectors
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: Brian Starkey <brian.starkey@arm.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>,
        "Clark, Rob" <robdclark@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Eric Anholt <eric@anholt.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 11, 2016 at 6:25 PM, Ville Syrj=C3=A4l=C3=A4
<ville.syrjala@linux.intel.com> wrote:
>> Writeback connector usage:
>> --------------------------
>> Due to connector routing changes being treated as "full modeset"
>> operations, any client which wishes to use a writeback connector
>> should include the connector in every modeset. The writeback will not
>> actually become active until a framebuffer is attached.
>>
>> The writeback itself is enabled by attaching a framebuffer to the
>> FB_ID property of the connector. The driver must then ensure that the
>> CRTC content of that atomic commit is written into the framebuffer.
>>
>> The writeback works in a one-shot mode with each atomic commit. This
>> prevents the same content from being written multiple times.
>> In some cases (front-buffer rendering) there might be a desire for
>> continuous operation - I think a property could be added later for
>> this kind of control.
>
> I though people agreed that this sort of thing would go through v4l.
> Continously writing to the same buffer isn't perhaps all that sensible
> anyway, and so we'd need queueing, which is what v4l has already. Well,
> I guess we might add some queueing to atomic eventually?
>
> I guess for front buffer rendering type of thing you might have some
> use for a continuous mode targeting a single fb. Though I think
> peridically triggering a new write could do as well. Of course either
> way would likely tear horribly, and having multiple buffers seems like
> the better option

Yeah, momentarily entirely forgot about v4l. I think making FB_ID
one-shot (perhaps better to call it WRITEBACK_FB_ID to avoid
confusion) is the right thing to do, and then push everything
continuous to some form of drm/v4l integration.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
