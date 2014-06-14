Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:57460 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbaFNMpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jun 2014 08:45:10 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N7500B2CSR96K20@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 14 Jun 2014 08:45:09 -0400 (EDT)
Date: Sat, 14 Jun 2014 09:45:04 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: em28xx submit of urb 0 failed (error=-27)
Message-id: <20140614094504.6b5695f4.m.chehab@samsung.com>
In-reply-to: <5398F646.70102@iki.fi>
References: <5398F2ED.4080309@iki.fi> <5398F646.70102@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 12 Jun 2014 03:37:26 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> I just ran blind scan using w_scan and it interrupted scanning, with 
> following error (ioctl DMX_SET_FILTER failed: 27 File too large).
> 
> 602000: (time: 00:58.973)
>          (0.308sec): SCL (0x1F)
>          (0.308sec) signal
>          (0.308sec) lock
>          signal ok:	QAM_AUTO f = 602000 kHz I999B8C999D999T999G999Y999 
> (0:0:0)
>          initial PAT lookup..
> start_filter:1644: ERROR: ioctl DMX_SET_FILTER failed: 27 File too large
> 
> regards
> Antti
> 
> 
> On 06/12/2014 03:23 AM, Antti Palosaari wrote:
> > Do you have any idea about that bug?
> > kernel: submit of urb 0 failed (error=-27)
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=72891
> >
> > I have seen it recently very often when I try start streaming DVB. When
> > it happens, device is unusable. I have feeling that it could be coming
> > from recent 28xx big changes where it was modularised. IIRC I reported
> > that at the time and Mauro added error number printing to log entry.
> > Anyhow, it is very annoying and occurs very often. And people have
> > started pinging me as I have added very many DVB devices to em28xx.

Well, according with USB documentation (Documentation/usb/URB.txt),
EFBIG means:
- Too many requested ISO frames

Perhaps the logic that calculates the number of URBs has a bug. In
the past, the URB size was hardcoded. Nowadays, em28xx dynamically
calculate it based on the USB descriptors, and the endpoints found.

>From what I know, different versions of em28xx chips have different
max limits. We need to identify on what chip version this error is
occurring, and reduce the number of ISOC frames there (with will
reduce the max bandwidth supported by such chip).

Regards,
Mauro
