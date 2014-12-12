Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:55422 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030233AbaLLQcN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 11:32:13 -0500
Message-ID: <548B1884.6090005@xs4all.nl>
Date: Fri, 12 Dec 2014 17:32:04 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Shuah Khan <shuahkh@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [REVIEW] au0828-video.c
References: <548AC061.3050700@xs4all.nl>	<20141212104942.0ea3c1d7@recife.lan>	<548AE5B2.1070306@xs4all.nl>	<20141212111424.0595125b@recife.lan>	<548B092F.2090803@osg.samsung.com>	<548B09A5.80506@xs4all.nl> <CAGoCfiw1pdJGGfG5Gs-3Jf2e48buzwEA1O3+j-E+2Pjj657eEQ@mail.gmail.com>
In-Reply-To: <CAGoCfiw1pdJGGfG5Gs-3Jf2e48buzwEA1O3+j-E+2Pjj657eEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2014 04:52 PM, Devin Heitmueller wrote:
>> No, tvtime no longer hangs if no frames arrive, so there is no need for
>> this timeout handling. I'd strip it out, which can be done in a separate
>> patch.
> 
> Did you actually try it?

Mauro tried it, not me. I'm not sure if he looked at whether the user
interface is blocked when waiting for a frame.

> Do you have some patches to tvtime which
> aren't upstream?
> 
> I wrote the comment in question (and added the associated code).  The
> issue is that tvtime does *everything* in a single thread (except the
> recent ALSA audio work), that includes servicing the video/vbi devices
> as well as the user interface.  That thread blocks on a DQBUF ioctl
> until data arrives, and thus if frames are not being delivered it will
> hang the entire tvtime user interface.
> 
> Now you can certainly argue that is a bad design decision, but it's
> been that way for 15+ years, so we can't break it now.  Hence why I
> generate dummy frames on a timeout if the decoder isn't delivering
> video.  Unfortunately the au8522 doesn't have a free running mode
> (i.e. blue screen if no video), which is why most of the other devices
> work fine (decoders by Conexant, NXP, Trident, etc all have such
> functionality).
> 
> Don't get me wrong - I *hate* that I had to put that timer crap in the
> driver, but it was necessary to be compatible with one of the most
> popular applications out there.
> 
> In short, that code cannot be removed.

Sure it can. I just tried tvtime and you are right, it blocks the GUI.
But the fix is very easy as well. So now I've updated tvtime so that
it timeouts and gives the GUI time to update itself.

No more need for such an ugly hack in au0828. The au0828 isn't the only
driver that can block, others do as well. Admittedly, they aren't very
common, but they do exist. So it is much better to fix the application
than adding application workarounds in the kernel.

Regards,

	Hans
