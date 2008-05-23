Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JzaTr-0004OK-5r
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 18:51:03 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Frederic CAND <frederic.cand@anevia.com>
In-Reply-To: <4836DD93.50805@anevia.com>
References: <4836DD93.50805@anevia.com>
Date: Fri, 23 May 2008 18:50:34 +0200
Message-Id: <1211561434.2791.12.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [HVR1300] issue with VLC
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Frederic,

Am Freitag, den 23.05.2008, 17:06 +0200 schrieb Frederic CAND:
> I post again cause I did not get any reply at my late mail : anybody 
> encountering picture / sound issues with VLC after some time running 
> (let's say half an hour) reading the MPEG PS output ?
> I tried many different v4l-dvb tarballs, including latest repository, 
> but I could not make it work more that 30 minutes (or 20, it depends).
> Stopping VLC and restarting it "solves" this issue but I'm looking for 
> someone who could confirm this behaviour, and then maybe fix this.
> My VLC works fine , btw , with other MPEG PS or TS live streaming.
> 
> Cheers.

can't tell much on it, but it might be related to this recently heard
from Dean and Mauro.

- quote -
V4L1 compat will still be kept for some time after the end of V4L1
drivers.

>  I had problems running the VIVI (virtual video 
> driver) driver with VideoLan/VLC 0.8.6a-f, but it worked with VLC 9.0 
> with the new V4L2 interface.

VLC V4L1 implementation were broken. It first starts DMA and streaming,
then,
it calls some ioctls that changes the buffer size. The compat handler
doesn't
accept this behaviour, since it would cause buffer overflow. AFAIK, only
bttv
driver used to support this behaviour. On V4L1 mode, bttv were
allocating
enough memory for the maximum resolution. So, subsequent buffer changes
works
properly. 

It would be valuable if you could work on a safe way to implement
backward
compat for this broken behaviour. In this case, you would need to change
the
compat implementation at videobuf, and let v4l1-compat module to be
aware that
it is safe to allow buffer size changes.

Yet, this seems to much work for something that should be already
removed from
kernel (V4L1).
-------

You will meet some more people with HVR1300 cards posting also to the
video4linux-list. Does it also happen with the mplayer v4l2 driver?

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
