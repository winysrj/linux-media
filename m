Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:62650 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbZBWP1H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 10:27:07 -0500
Received: by yx-out-2324.google.com with SMTP id 8so799072yxm.1
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2009 07:27:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902231052.25875.j@jannau.net>
References: <200902231052.25875.j@jannau.net>
Date: Mon, 23 Feb 2009 10:27:05 -0500
Message-ID: <412bdbff0902230727t5f6ce694l30c85d5130208635@mail.gmail.com>
Subject: Re: Haupauge Nova-T 500 2.6.28 regression dib0700
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Janne Grunau <j@jannau.net>
Cc: linux-media@vger.kernel.org, dheitmueller@linuxtv.org,
	pb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 23, 2009 at 4:52 AM, Janne Grunau <j@jannau.net> wrote:
> Hi,
>
> I have some difficulties with the Hauppauge Nova-T 500 and 2.6.28 kernels.
>
> Following USB errors appear with 2.6.28.4 every 100ms:
>
> Feb 15 02:46:03 golem [ 7720.876132] usb 2-1: events/3 timed out on ep1in len=0/6
> Feb 15 02:46:03 golem [ 7720.976039] usb 2-1: events/3 timed out on ep1in len=0/6
> Feb 15 02:46:03 golem [ 7721.076068] usb 2-1: events/3 timed out on ep1in len=0/6
>
> The device is still useable but occasionally I see the same error
>  with additional usb errors (iirc same kernel and config)
>
> Feb 17 20:33:17 golem [   14.733031] ehci_hcd 0000:01:06.2: reused qh ffff8800bf80d140 schedule
> Feb 17 20:33:17 golem [   14.733040] usb 2-1: link qh64-0001/ffff8800bf80d140 start 63 [2/0 us]
> Feb 17 20:33:17 golem [   14.783035] usb 2-1: unlink qh64-0001/ffff8800bf80d140 start 63 [2/0 us]
> Feb 17 20:33:17 golem [   14.783107] usb 2-1: events/3 timed out on ep1in len=0/6
> ...
> Feb 17 20:34:12 golem [  128.130059] ehci_hcd 0000:01:06.2: reused qh ffff8800bf80d140 schedule
> Feb 17 20:34:12 golem [  128.130069] usb 2-1: link qh64-0001/ffff8800bf80d140 start 63 [2/0 us]
> Feb 17 20:34:12 golem [  128.131007] ehci_hcd 0000:01:06.2: force halt; handhake ffffc20000050014 00
> 004000 00000000 -> -110
>
> ehci gives up and the device is unuseabe.
>
> This is still the case with 2.6.28.7.
>
> git bisect blames following change:
>
> | commit 99afb989b05b9fb1c7b3831ce4b7a000b214acdb
> | Author: Devin Heitmueller <devin.heitmueller@gmail.com>
> | Date:   Sat Nov 15 07:13:07 2008 -0300
> |
> |     V4L/DVB (9639): Make dib0700 remote control support work with firmware v1.20
>
> 2.6.28.x with DVB drivers from v4l-dvb hg works as expected bu I fail
> to see which changeset fixed it. If you have an idea I'll test it.
> Otherwise I'll bisect v4l-dvb hg.
>
> This should be fixed in 2.6.28-stable.
>
> Janne

Hello Janneg,

Thank you for reporting this issue.

We actually rely on the bulk endpoint timing out to query the IR port
if there is no keypress.  I wonder if they introduced a new kernel
warning in 2.6.28.4 when this occurs.

Regarding the other issue, is there any correlation with the errors to
plugging/unplugging the devices?  Perhaps there is an issue with
cancellation of the thread that does the polling when the device is
disconnected.

I actually don't have a Nova-T 500.  I did all the development on the
dib0700 based Pinnacle 801e.

Devin



-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
