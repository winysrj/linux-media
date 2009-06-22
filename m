Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36927 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZFVA16 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2009 20:27:58 -0400
Date: Sun, 21 Jun 2009 21:27:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Dennis Campbell <denniscampbell73@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: dvb-t with kernel 2.6.15?
Message-ID: <20090621212756.09907f3f@pedra.chehab.org>
In-Reply-To: <1d41be3c0906211036r1235ee6bo5870cb4185f4ee38@mail.gmail.com>
References: <1d41be3c0906211036r1235ee6bo5870cb4185f4ee38@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 21 Jun 2009 19:36:42 +0200
Dennis Campbell <denniscampbell73@gmail.com> escreveu:

> Hello,
> I have seen that the v4l-dvb modules work only for kernel > 2.6.15. I
> have a Pinnacle 72e USB DVB-T stick i would like to use with a 2.6.15
> (ARM)kernel. This would be a dibcom 0700 driver. Is there any
> possibilty at all to get this working, or do I have to get a dvb-t usb
> stick that is supported by the 2.6.15 kernel? How good was the dvb-t
> support using the 2.6.15 kernel? Thanks for any help.

You may try to compile it with 2.6.15, by changing versions.txt file, or by
explicitly enabling support for older kernels via "make menuconfig".

It is a good idea to take a look at the changeset that stripped compat with
kernels older than 2.6.16:

changeset:   8240:fc86dc29e6a3
parent:      8235:9ff62c80bf4c
user:        Hans Verkuil <hverkuil@xs4all.nl>
date:        Tue Jul 08 17:40:58 2008 +0200
summary:     v4l-dvb: remove support for kernels < 2.6.16



Cheers,
Mauro
