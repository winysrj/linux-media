Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:48875 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101Ab1HDLOB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2011 07:14:01 -0400
Received: by mail-pz0-f44.google.com with SMTP id 36so1577639pzk.17
        for <linux-media@vger.kernel.org>; Thu, 04 Aug 2011 04:14:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKMK7uECwB70CnAaoTTfG0X5tMTcsYGZvvTaMxHE654bYNJyyQ@mail.gmail.com>
References: <4E37C7D7.40301@samsung.com>
	<4E381B73.8050706@codeaurora.org>
	<20E136AF98049A48A90A7417B4343D5E1DF747A563@BUNGLE.Emea.Arm.com>
	<4E396569.30708@codeaurora.org>
	<CAKMK7uECwB70CnAaoTTfG0X5tMTcsYGZvvTaMxHE654bYNJyyQ@mail.gmail.com>
Date: Thu, 4 Aug 2011 06:14:00 -0500
Message-ID: <CAO8GWq=6djefOgQGWf4fkRryWM2e7qOMA5qeZOGkUVx7VWf-wg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] Buffer sharing proof-of-concept
From: "Clark, Rob" <rob@ti.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jordan Crouse <jcrouse@codeaurora.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 4, 2011 at 3:58 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Wed, Aug 3, 2011 at 17:12, Jordan Crouse <jcrouse@codeaurora.org> wrote:
>> On 08/03/2011 03:33 AM, Tom Cooksey wrote:
>>> Passing buffer meta-data around was also discussed yesterday. Again, the
>>> general consensus seemed to be that this data should be kept out of the
>>> kernel. The userspace application should know what the buffer format
>>> etc. is and can provide that information to the relevant device APIs
>>> when is passes in the buffer.
>>
>> True, but APIs change slowly. Some APIs *cough* OpenMAX *cough* are damn
>> near immutable over the life time of a average software release. A blob of
>> data attached to a buffer can evolve far more rapidly and be far more
>> extensible and much more vendor specific. This isn't an new idea, I think
>> the DRM/GEM guys have tossed it around too.
>
> Erh, no. For sharing gem buffers between process (i.e. between direct
> rendering clients and the compositor, whatever that is) we just hand
> around the gem id in the kernel. Some more stuff gets passed around in
> userspace in a generic way (e.g. DRI2 passes the buffer type (depth,
> stencil, color, ...) and the stride), but that's it.
>
> Everything else is driver specific and mostly not even passed around
> explicitly and just agreed upon implicitly. E.g. running the wrong
> XvMC decoder lib for your Xorg Intel driver will result in garbage on
> the screen. There's a bit more leeway between Mesa and the Xorg driver
> because they're released independantly, but it's very ad-hoc (i.e.
> oops, that buffer doesn't fit the requirements of the new code, must
> be an old Xorg driver, so switch to the compat paths in Mesa).
>
> But my main fear with the "blob attached to the buffer" idea is that
> sooner or later it'll be part of the kernel/userspace interface of the
> buffer sharing api ("hey, it's there, why not use it?"). And the
> timeframe for deprecating the kernel abi is 5-10 years and yes I've
> tried to dodge that and got shot at.

hmm, there would be a dmabuf->private ptr in struct dmabuf.  Normally
that should be for private data of the buffer allocator, but I guess
it could be (ab)used for under the hood communication between drivers
a platform specific way.  It does seem a bit hacky, but at least it
does not need to be exposed to userspace.

(Or maybe a better option is just 'rm -rf omx' ;-))

BR,
-R

> Imo a better approach is to spec
> (_after_ the kernel buffer sharing works) a low-level userspace api
> that drivers need to implement (like the EGL Mesa extensions used to
> make Wayland work on gem drivers).
> -Daniel
> --
> Daniel Vetter
> daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
>
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
>
