Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:54493 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaG0TmY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 15:42:24 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9D002SPYQMJ400@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 27 Jul 2014 15:42:22 -0400 (EDT)
Date: Sun, 27 Jul 2014 16:42:18 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: crope@iki.fi, linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8] cx231xx: Add digital support for [2040:b131] Hauppauge
 WinTV 930C-HD (model 1114xx)
Message-id: <20140727164218.3dd674e7.m.chehab@samsung.com>
In-reply-to: <20140727115911.0dde3d30.m.chehab@samsung.com>
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org>
 <1406059938-21141-7-git-send-email-zzam@gentoo.org>
 <20140726162718.660cf512.m.chehab@samsung.com> <53D4C72A.4010209@gentoo.org>
 <20140727104453.4578b353.m.chehab@samsung.com>
 <20140727113248.29dccc38.m.chehab@samsung.com>
 <20140727115911.0dde3d30.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 27 Jul 2014 11:59:11 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Em Sun, 27 Jul 2014 11:32:48 -0300
> Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
> 
> > Em Sun, 27 Jul 2014 10:44:53 -0300
> > Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
> > 
> > > Em Sun, 27 Jul 2014 11:32:26 +0200
> > > Matthias Schwarzott <zzam@gentoo.org> escreveu:
> > > 
> > > > 
> > > > Hi Mauro.
> > > > 
> > > > On 26.07.2014 21:27, Mauro Carvalho Chehab wrote:
> > > > > Tried to apply your patch series, but there's something wrong on it.
> > > > > 
> > > > > See the enclosed logs. I suspect that you missed a patch adding the
> > > > > proper tuner for this device.

The hole issue was due to that:
> [  326.770414] cx231xx #0: New device Hauppauge Hauppauge Device @ 12 Mbps (2040:b131) with 4 interfaces

The root cause seems to be a bad USB cable, causing errors at USB
detection.

Just send a patch series that avoids the driver to OOPS in such
case.

Regards,
Mauro
