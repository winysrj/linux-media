Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:41423 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3C1NfE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 09:35:04 -0400
Received: by mail-ee0-f51.google.com with SMTP id c4so1729692eek.24
        for <linux-media@vger.kernel.org>; Thu, 28 Mar 2013 06:35:03 -0700 (PDT)
Date: Thu, 28 Mar 2013 15:35:56 +0200
From: Timo Teras <timo.teras@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Terratec Grabby hwrev 2
Message-ID: <20130328153556.0b58d1aa@vostro>
In-Reply-To: <20130328094052.26b7f3f5@redhat.com>
References: <20130325190846.3250fe98@vostro>
	<20130325143647.3da1360f@redhat.com>
	<20130325194820.7c122834@vostro>
	<20130325153220.3e6dbfe5@redhat.com>
	<20130325211238.7c325d5e@vostro>
	<20130326102056.63b55916@vostro>
	<20130327161049.683483f8@vostro>
	<20130328105201.7bcc7388@vostro>
	<20130328094052.26b7f3f5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 28 Mar 2013 09:40:52 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Em Thu, 28 Mar 2013 10:52:01 +0200
> Timo Teras <timo.teras@iki.fi> escreveu:
> 
> > On Wed, 27 Mar 2013 16:10:49 +0200
> > Timo Teras <timo.teras@iki.fi> wrote:
> > 
> > > On Tue, 26 Mar 2013 10:20:56 +0200
> > > Timo Teras <timo.teras@iki.fi> wrote:
> > > 
> > > > I did manage to get decent traces with USBlyzer evaluation
> > > > version.
> > > 
> > > Nothing _that_ exciting there. Though, there's quite a bit of
> > > differences on certain register writes. I tried copying the
> > > changed parts, but did not really help.
> > > 
> > > Turning on saa7115 debug gave:
> > > 
> > > saa7115 1-0025: chip found @ 0x4a (ID 000000000000000) does not
> > > match a known saa711x chip.
> > 
> > Well, I just made saa7115.c ignore this ID check, and defeault to
> > saa7113 which is apparently the chip used.
> > 
> > And now it looks like things start to work a lot better.
> > 
> > Weird that the saa7113 chip is missing the ID string. Will continue
> > testing.
> 
> That could happen if saa7113 is behind some I2C bridge and when
> saa7113 is not found when the detection code is called.

Smells to me that they replaced the saa7113 with cheaper clone that
does not support the ID string.

Sounds like the same issue as:
http://www.spinics.net/lists/linux-media/msg57926.html

Additionally noted that something is not initialized right:

With PAL signal:
- there's some junk pixel in beginning of each line (looks like pixes
  from previous lines end), sync issue?
- some junk lines at the end
- distorted colors when white and black change between pixels

With NTSC signal:
- unable to get a lock, and the whole picture looks garbled

On the W7 driver, I don't get any of the above mentioned problems.

I looked at the saa7113 register init sequence, and copied that over to
linux saa7113 init, but that did not remove the problems. There were
only few changes.

- Timo
