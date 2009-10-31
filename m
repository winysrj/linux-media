Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61208 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbZJaRk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 13:40:58 -0400
Received: by bwz27 with SMTP id 27so4738636bwz.21
        for <linux-media@vger.kernel.org>; Sat, 31 Oct 2009 10:41:03 -0700 (PDT)
Subject: Re: [linux-dvb] Possible error in firedtv-1394.o?
From: Andreas Breitbach <andreas.breitbach@gmail.com>
To: linux-media@vger.kernel.org
In-Reply-To: <829197380910301253w5e94a313idb942ad5336b2640@mail.gmail.com>
References: <1256932132.3563.12.camel@andy-laptop>
	 <829197380910301253w5e94a313idb942ad5336b2640@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Oct 2009 18:41:00 +0100
Message-ID: <1257010860.3095.4.camel@andy-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Huge thanks Devin,

now it's working again.

Andy

Am Freitag, den 30.10.2009, 15:53 -0400 schrieb Devin Heitmueller:
> On Fri, Oct 30, 2009 at 3:48 PM, Andreas Breitbach
> <andreas.breitbach@gmail.com> wrote:
> > Hello all.
> >
> > I subscribed to this mailing list to report a possible error in the
> > above mentioned module. For your better understanding, some details
> > about my situation: I upgraded yesterday from Jaunty(Ubuntu) to the new
> > Karmic. I had a "0ccd:0069 TerraTec Electronic GmbH Cinergy T XE DVB-T
> > Receiver"(lsusb output), which worked with the drivers avaible from
> > http://linuxtv.org/hg/~anttip/. After the upgrade, I tried to compile
> > and install the modules necessary for the stick by entering "make all".
> > It compiles til reaching firedtv-1394.o, I attached the output, which
> > complains about this specific module.
> > As I'm not a programmer, but rather a normal user who clued together how
> > to get this stick working once, I fear I can not be of much help in
> > debugging. Nonetheless, I'd be very interested in knowing about the
> > status of this and when my TV will be back working(or how I could
> > circumvent this error).
> 
> Hi Andy,
> 
> Yeah, this is a known issue with the build process under Karmic.  The
> iee1394 is enabled by default but Karmic's packaging of the kernel
> headers is missing some files that are needed by the firedtv driver.
> 
> To workaround the issue, I usually just open v4l/.config and change
> the firedtv driver from "=m" to "=n".
> 
> Devin
> 


