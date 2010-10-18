Return-path: <mchehab@pedra>
Received: from cnxtsmtp1.conexant.com ([198.62.9.252]:42900 "EHLO
	Cnxtsmtp1.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab0JRXbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 19:31:08 -0400
Received: from cps (nbwsmx1.bbnet.ad [157.152.183.211]) (using TLSv1 with cipher RC4-MD5 (128/128
 bits)) (No client certificate requested) by Cnxtsmtp1.conexant.com (Tumbleweed MailGate 3.7.1) with
 ESMTP id 2A45612BEA0 for <linux-media@vger.kernel.org>; Mon, 18 Oct 2010 16:13:14 -0700 (PDT)
From: "Sri Deevi" <Srinivasa.Deevi@conexant.com>
To: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
	"jarod@redhat.com" <jarod@redhat.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
Date: Mon, 18 Oct 2010 16:13:15 -0700
Subject: RE: [PATCH 0/3]  Fix IR support at cx231xx
Message-ID: <34B38BE41EDBA046A4AFBB591FA3113202486A7AA3@NBMBX01.bbnet.ad>
References: <20101018205300.23e0da75@pedra>
In-Reply-To: <20101018205300.23e0da75@pedra>
Content-Language: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

All the patches are OK with me. Also, it does not make sense to write another driver if there is one for MCE IR remote.

Sri

-----Original Message-----
From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com] 
Sent: Monday, October 18, 2010 3:53 PM
To: Sri Deevi; jarod@redhat.com; Linux Media Mailing List
Subject: [PATCH 0/3] Fix IR support at cx231xx

cx231xx has a stub for IR handling, but this is incomplete. However, as
the IR were designed to work with a standard MCE driver on another OS,
the better is to just drop the cx231xx internal handling, and let the
mceusb driver take care of the protocol.

Maybe some adjustments may be needed, to be sure that we're using the right
generation of the MCE protocol.

Mauro Carvalho Chehab (3):
  mceusb: add support for cx231xx-based IR (e. g. Polaris)
  cx231xx: Only register USB interface 1
  cx231xx: Remove IR support from the driver

 drivers/media/IR/mceusb.c                   |   20 ++
 drivers/media/video/cx231xx/cx231xx-cards.c |   49 +-----
 drivers/media/video/cx231xx/cx231xx-input.c |  251 ---------------------------
 drivers/media/video/cx231xx/cx231xx.h       |    4 -
 4 files changed, 28 insertions(+), 296 deletions(-)
 delete mode 100644 drivers/media/video/cx231xx/cx231xx-input.c


Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------

