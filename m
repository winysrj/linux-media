Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33088 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2DJQK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 12:10:29 -0400
Received: by vbbff1 with SMTP id ff1so3115943vbb.19
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2012 09:10:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <jwv1unvwrtn.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
References: <jwv4nsyx9pr.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
	<CAGoCfiwKU1doqvdcHFpVoc2xuRQKdQirWze0oB2QQyXSQcYrKw@mail.gmail.com>
	<jwv1unvwrtn.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
Date: Tue, 10 Apr 2012 12:10:27 -0400
Message-ID: <CAGoCfix+YHc3wPUvdwudqk5rAed09BroPX6wf-5N6BxXV5fV0Q@mail.gmail.com>
Subject: Re: Unknown eMPIA tuner
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Stefan Monnier <monnier@iro.umontreal.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 10, 2012 at 11:24 AM, Stefan Monnier
<monnier@iro.umontreal.ca> wrote:
>>> I just got a USB tuner ("HD TV ATSC USB stick") which lsusb describes as
>>> "ID eb1a:1111 eMPIA Technology, Inc." and was wondering how to try to
>>> get it working.
>>> Would the em28xx driver be able to handle it?  If so, how should I modify
>>> it to try it out?
>> You would probably have to start by taking it apart and seeing which
>> demodulator and tuner chips it contained.
>
> Hmm... how would I go about taking it apart without destroying it?
> ...hhmmm... apparently, a bit of brute force did the trick (at least
> for the "taking it apart" bit, not sure about the "without destroying
> it" yet).
>
> On one side I see a small IC that says something like "Trident \n DRX
> 3933J B2".
>
> On the other side I see 2 ICs that say respectively "eMPIA \n ?M2874B"
> and "NXP \n TDA182?1HDC2 \n P3KNR" (the ? might be a slash or a 7) plus
> a third tiny "24C??? \n FTG..." but I don't think that one
> is significant.

Ok, so it's an em2874/drx-j/tda18271 design, which in terms of the
components is very similar to the PCTV 80e (which I believe Mauro got
into staging recently).  I would probably recommend looking at that
code as a starting point.  That said, you'll need to figure out the
correct IF frequency, the drx-j configuration block, the GPIO layout,
and the correct tuner config.  If those terms don't mean anything to
you, then you are best to wait until some developer stumbles across
the device and has the time to add the needed support.

In other words, all the core chips are supported, but you would have
to be able to figure out the correct glue that describes how the
components are actually wired up in this particular hardware design.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
