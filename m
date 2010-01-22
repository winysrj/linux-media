Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:63141 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab0AVXbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 18:31:10 -0500
Received: by fxm20 with SMTP id 20so1900797fxm.21
        for <linux-media@vger.kernel.org>; Fri, 22 Jan 2010 15:31:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4A0C95.5000804@sgtwilko.f9.co.uk>
References: <3f3a053b1001021407k6ce936b8gd7d3e575a25e734d@mail.gmail.com>
	 <3f3a053b1001021411i2e9484d7rd2d13f1a355939fe@mail.gmail.com>
	 <846899811001021455u28fccb5cr66fd4258d3dddd4d@mail.gmail.com>
	 <d9def9db1001091811s6dbed557vfca9ce410e41d3d3@mail.gmail.com>
	 <4B49D1A4.4040702@gmail.com>
	 <1a297b361001100535u1875de01jfe2b724c6643dfc0@mail.gmail.com>
	 <846899811001100728x27eaf4faqd83373dd16ef58d3@mail.gmail.com>
	 <4B4A0C95.5000804@sgtwilko.f9.co.uk>
Date: Sat, 23 Jan 2010 03:31:06 +0400
Message-ID: <1a297b361001221531q4a2726ecm5952379c6ef08182@mail.gmail.com>
Subject: Re: CI USB
From: Manu Abraham <abraham.manu@gmail.com>
To: Ian Wilkinson <null@sgtwilko.f9.co.uk>
Cc: HoP <jpetrous@gmail.com>, Emmanuel <eallaud@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 10, 2010 at 9:21 PM, Ian Wilkinson <null@sgtwilko.f9.co.uk> wrote:
> HoP wrote:
>
> I don't know the details into the USB device, but each of those CAM's
> have bandwidth limits on them and they vary from one CAM to the other.
> Also, there is a limit on the number of simultaneous PID's that which
> you can decrypt.
>
> Some allow only 1 PID, some allow 3. Those are the basic CAM's for
> home usage.The most expensive CAM's allow a maximum of 24 PID's. But
>
>
> You, of course, ment number of descramblers not PIDS because it is evident
> that getting TV service descrambled, you need as minimum 2 PIDS for A/V.
>
> Anyway, it is very good note. Users, in general, don't know about it.
>

If it is using a CI+ plus chip (I heard from someone that it is a CI+
chip inside) :
http://www.smardtv.com/index.php?page=ciplus

After reading the CI+ specifications, I doubt that it can be supported
under Linux with open source support, without a paired decoder
hardware or software decoder. A paired open source software decoder
seems highly unlikely, as the output of the CI+ module is eventually
an encrypted stream which can be descrambled with the relevant keys.
The TS is not supposed to be stored on disk, or that's what the whole
concept is for CI+

http://www.ci-plus.com/data/ci-plus_overview_v2009-07-06.pdf

See pages 7, 8 , 12, 15

It could be possible to pair a software decoder with a key and hence
under Windows, but under Linux I would really doubt it, if it happens
to be a CI+ chip

Regards,
Manu
