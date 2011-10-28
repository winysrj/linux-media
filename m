Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:22637 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1J1Hyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Oct 2011 03:54:45 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <20138.24513.451159.783078@morden.metzler>
Date: Fri, 28 Oct 2011 09:54:41 +0200
To: S=?iso-8859-1?B?6Q==?=bastien RAILLARD (COEXSI) <sr@coexsi.fr>
Cc: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
Subject: RE: [DVB] Digital Devices Cine CT V6 support
In-Reply-To: <000b01cc9487$9e48aac0$dada0040$@coexsi.fr>
References: <004c01cc7a03$064111c0$12c33540$@coexsi.fr>
	<201110240906.24543@orion.escape-edv.de>
	<004e01cc9247$0a8da4d0$1fa8ee70$@coexsi.fr>
	<20133.44781.388484.71473@morden.metzler>
	<000b01cc9487$9e48aac0$dada0040$@coexsi.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sébastien RAILLARD (COEXSI) writes:
 >                      CineS2 v6 + 2 CAM Readers
 > 
 >                         +----------------+
 >   Tuner 0 -> Input 0 -> |                |
 >                         | Port 0 - TAB 1 | -> Output 0
 >   Tuner 1 -> Input 1 -> |     DVB-S2     |
 >                         +----------------+
 >              Input 2 -> |                |
 >                         | Port 1 - TAB 2 | -> Output 1
 >              Input 3 -> |                |
 >                         +----------------+
 >     CAM 0 -> Input 4 -> |                |
 >                         | Port 2 - TAB 3 | -> Output 2 -> CAM 0
 >              Input 5 -> |       CAM      |
 >                         +----------------+
 >     CAM 1 -> Input 6 -> |                |
 >                         | Port 3 - TAB 4 | -> Output 3 -> CAM 1
 >              Input 7 -> |       CAM      |
 >                         +----------------+
 > 
 > Two redirections to set : 
 > 
 > * "X0 X2" (input #0 to port #2)
 > * "X1 X3" (input #1 to port #3)
 > 
 > Where X is the device number.


Correct, except that the CineS2 V6 only has TAB2 and TAB3 on board.


Btw., I also added the module parameter adapter_alloc, which lets you
specifiy how many adapters are to be allocated:

0 = one adapter per io if modules are present
1 = one adapter for each tab on which a module was detected
2 = one per tab even if no modules were detected
3 = one adapter for all devices of one card

If you use adapter_alloc=3 for a config like above (2 tuners 2 CAMS)
you will get all the devices in one /dev/dvb/adapterX/ 
and most programs should now work with CI out of the box (at least
with the first tuner) if the redirections are set properly. 


Regards,
Ralph
