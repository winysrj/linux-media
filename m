Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:62224 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaGZPrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 11:47:45 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9B00J2QT7J7C70@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 26 Jul 2014 11:47:43 -0400 (EDT)
Date: Sat, 26 Jul 2014 12:47:39 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Niels Laukens <niels@dest-unreach.be>
Cc: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/media/rc/ir-nec-decode : add toggle feature
Message-id: <20140726124739.6c3e25bb.m.chehab@samsung.com>
In-reply-to: <53A2D0B5.4050003@dest-unreach.be>
References: <53A29E5A.9030304@dest-unreach.be>
 <53A29E79.2000304@dest-unreach.be> <20140619090540.GC13952@hardeman.nu>
 <53A2D0B5.4050003@dest-unreach.be>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 19 Jun 2014 13:59:49 +0200
Niels Laukens <niels@dest-unreach.be> escreveu:

> On 2014-06-19 11:05, David Härdeman wrote:
> > On Thu, Jun 19, 2014 at 10:25:29AM +0200, Niels Laukens wrote:
> >> Made the distinction between repeated key presses, and a single long
> >> press. The NEC-protocol does not have a toggle-bit (cfr RC5/RC6), but
> >> has specific repeat-codes.
> > 
> > Not all NEC remotes use repeat codes. Some just transmit the full code
> > at fixed intervals...IIRC, Pioneer remotes is (was?) one example... 
> 
> A way to cover this, is to make this mechanism optional, and
> auto-activate as soon as a repeat code is seen. But that will only work
> reliably with a single (type of) remote per system. Is this a better
> solution?

No, auto-activating is a very bad idea, as it means that any NEC remote,
if ever pressed in the room, will change the driver behavior. We should be
able to support both cases: the one with specific repeat codes and the
ones that don't support, at the same time.

Regards,
Mauro
