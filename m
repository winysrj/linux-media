Return-path: <mchehab@gaivota>
Received: from DSL01.212.114.205.243.ip-pool.NEFkom.net ([212.114.205.243]:55627
	"EHLO enzo.pibbs.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751989Ab1ADQqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jan 2011 11:46:12 -0500
Received: from trixi.localnet (trixi.pibbs.org [192.168.20.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by enzo.pibbs.org (Postfix) with ESMTPS id 18826DCE8C
	for <linux-media@vger.kernel.org>; Tue,  4 Jan 2011 17:56:20 +0100 (CET)
From: Martin Seekatz <martin@pibbs.de>
To: linux-media@vger.kernel.org
Subject: Re: Problem with em28xx driver in Gumstix Overo
Date: Tue, 4 Jan 2011 17:46:08 +0100
References: <AANLkTinPEYyLrTWqt1r0QgoYmsv2Xg16qGKo5yTqu9FO@mail.gmail.com> <AANLkTi=AVjhEbsqZOWJbwkYRo+HLoHfdWxuFO7Bs_a7H@mail.gmail.com> <AANLkTiknspxdjZNZW=h7NWTffzCZ4uEJmADU=tYPZSNe@mail.gmail.com>
In-Reply-To: <AANLkTiknspxdjZNZW=h7NWTffzCZ4uEJmADU=tYPZSNe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101041746.09136.martin@pibbs.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Am Montag 03 Januar 2011 schrieb Devin Heitmueller:
> On Mon, Jan 3, 2011 at 3:13 PM, Linus Torvalds
> 
> <torvalds@linux-foundation.org> wrote:
> >> // if (!dev->progressive)
> >> // height >>= norm_maxh(dev);
> 
> This would suggest that the device is providing progressive video
> and there is a mismatch between the board profile and the actual
> hardware, which is certainly possible but I know absolutely
> nothing about the product in question.
> 
> It would be helpful if we could get the output of dmesg for
> starters, so we can see which board profile is being used.

This main problem seems to be similare to the problem I reportet on 
2011-01-01 to the ML, subject: 
Silver Crest VG2000  "USB 2.0 Video Grabber", USB-Id: eb1a:2863 - does 
not work

In the meantime the figures of the partikular device, including dmesg 
output,  is been included in the linuxtv wiki as
http://www.linuxtv.org/wiki/index.php/SilverCrest_USB_2.0_Video_Grabber_VG_2000

Best regards
Martin

-- 
"Was ist der Unterschied zwischen Franken und Oberbayern?" -
"Die Franken haben weniger Berge, aber dafür mehr Horizont."
