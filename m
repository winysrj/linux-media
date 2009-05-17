Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:44110 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbZEQVzx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 17:55:53 -0400
Date: Sun, 17 May 2009 16:55:54 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Jean Delvare <khali@linux-fr.org>
cc: =?UTF-8?Q?Old=C5~Yich_Jedli=C4~Mka?= <oldium.pro@seznam.cz>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, Mike Isely <isely@isely.net>
Subject: Re: [PATCH 0/8] ir-kbd-i2c conversion to the new i2c binding model
 (v3)
In-Reply-To: <20090514212614.09d51a93@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0905171654030.17519@cnc.isely.net>
References: <20090513214559.0f009231@hyperion.delvare>
 <200905142125.02332.oldium.pro@seznam.cz> <20090514212614.09d51a93@hyperion.delvare>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811561-468494356-1242597354=:17519"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811561-468494356-1242597354=:17519
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 14 May 2009, Jean Delvare wrote:

> On Thu, 14 May 2009 21:25:02 +0200, Oldřich Jedlička wrote:
> > On Wednesday 13 of May 2009 at 21:45:59, Jean Delvare wrote:
> > > Hi all,
> > >
> > > Here comes an update of my conversion of ir-kbd-i2c to the new i2c
> > > binding model. I've split it into 8 pieces for easier review. Firstly
> > > there is 1 preliminary patch:
> > >
> > 
> > Hi Jean,
> > 
> > works for me, as usual :-) I've used the all-in-one patch and the up-to-date 
> > v4l-dvb tree (compiled yesterday for completeness).
> 
> Oldrich, thanks a lot for testing and reporting, this is very
> appreciated.
> 

Jean:

I tried the all-in-one patch here on a PVR-USB2 24xxx model (slightly 
older v4l-dvb repo and 2.6.27.13 vanilla kernel) and it worked fine.  
I'll add an acked-by to the corresponding (trivial) pvrusb2 patch that 
you've posted.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
---1463811561-468494356-1242597354=:17519--
