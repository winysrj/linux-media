Return-path: <mchehab@pedra>
Received: from DSL01.212.114.205.243.ip-pool.NEFkom.net ([212.114.205.243]:57532
	"EHLO enzo.pibbs.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750738Ab1BIXG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 18:06:58 -0500
From: Martin Seekatz <martin@pibbs.de>
To: linux-media@vger.kernel.org
Subject: Re: em28xx: board id [eb1a:2863 eMPIA Technology, Inc] Silver Crest VG2000 "USB 2.0 Video Grabber"
Date: Thu, 10 Feb 2011 00:06:54 +0100
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <201102082305.24897.martin@pibbs.de> <201102092336.20812.martin@pibbs.de> <AANLkTimST51rWpp9G3a6kds6eqM+dupWu=MyEJtTYZNs@mail.gmail.com>
In-Reply-To: <AANLkTimST51rWpp9G3a6kds6eqM+dupWu=MyEJtTYZNs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102100006.55133.martin@pibbs.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am Mittwoch 09 Februar 2011 schrieb Devin Heitmueller:
> On Wed, Feb 9, 2011 at 5:36 PM, Martin Seekatz <martin@pibbs.de> 
wrote:
> > Hello Devin,
> > 
> > I mean that list
> > http://www.kernel.org/doc/Documentation/video4linux/CARDLIST.em28
> > xx
> 
> It actually is there:
> 
> 29 -> EM2860/TVP5150 Reference Design

Yes, but the list refers to
 1 -> Unknown EM2750/28xx video grabber        (em2820/em2840) 
[eb1a:2710,eb1a:2820,eb1a:2821,eb1a:2860,eb1a:2861,eb1a:2862,eb1a:2863,eb1a:2870,eb1a:2881,eb1a:2883,eb1a:2868]

because of the usb-id: eb1a:2863

> 
> If the vendor did not build the hardware with its own unique USB ID
> (because they were lazy), the best we can do is refer to it by the
> above name (since we would not be able to distinguish between the
> Silvercrest and all the other clones).

For me it seams that this usb-id is unique.

Martin

-- 
"Was ist der Unterschied zwischen Franken und Oberbayern?" -
"Die Franken haben weniger Berge, aber dafür mehr Horizont."
