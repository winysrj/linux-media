Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64858 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab1HDI6z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 04:58:55 -0400
Received: by vxi9 with SMTP id 9so40332vxi.19
        for <linux-media@vger.kernel.org>; Thu, 04 Aug 2011 01:58:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E396569.30708@codeaurora.org>
References: <4E37C7D7.40301@samsung.com>
	<4E381B73.8050706@codeaurora.org>
	<20E136AF98049A48A90A7417B4343D5E1DF747A563@BUNGLE.Emea.Arm.com>
	<4E396569.30708@codeaurora.org>
Date: Thu, 4 Aug 2011 10:58:53 +0200
Message-ID: <CAKMK7uECwB70CnAaoTTfG0X5tMTcsYGZvvTaMxHE654bYNJyyQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] Buffer sharing proof-of-concept
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Jordan Crouse <jcrouse@codeaurora.org>
Cc: Tom Cooksey <Tom.Cooksey@arm.com>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 3, 2011 at 17:12, Jordan Crouse <jcrouse@codeaurora.org> wrote:
> On 08/03/2011 03:33 AM, Tom Cooksey wrote:
>> Passing buffer meta-data around was also discussed yesterday. Again, the
>> general consensus seemed to be that this data should be kept out of the
>> kernel. The userspace application should know what the buffer format
>> etc. is and can provide that information to the relevant device APIs
>> when is passes in the buffer.
>
> True, but APIs change slowly. Some APIs *cough* OpenMAX *cough* are damn
> near immutable over the life time of a average software release. A blob of
> data attached to a buffer can evolve far more rapidly and be far more
> extensible and much more vendor specific. This isn't an new idea, I think
> the DRM/GEM guys have tossed it around too.

Erh, no. For sharing gem buffers between process (i.e. between direct
rendering clients and the compositor, whatever that is) we just hand
around the gem id in the kernel. Some more stuff gets passed around in
userspace in a generic way (e.g. DRI2 passes the buffer type (depth,
stencil, color, ...) and the stride), but that's it.

Everything else is driver specific and mostly not even passed around
explicitly and just agreed upon implicitly. E.g. running the wrong
XvMC decoder lib for your Xorg Intel driver will result in garbage on
the screen. There's a bit more leeway between Mesa and the Xorg driver
because they're released independantly, but it's very ad-hoc (i.e.
oops, that buffer doesn't fit the requirements of the new code, must
be an old Xorg driver, so switch to the compat paths in Mesa).

But my main fear with the "blob attached to the buffer" idea is that
sooner or later it'll be part of the kernel/userspace interface of the
buffer sharing api ("hey, it's there, why not use it?"). And the
timeframe for deprecating the kernel abi is 5-10 years and yes I've
tried to dodge that and got shot at. Imo a better approach is to spec
(_after_ the kernel buffer sharing works) a low-level userspace api
that drivers need to implement (like the EGL Mesa extensions used to
make Wayland work on gem drivers).
-Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
