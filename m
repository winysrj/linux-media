Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:43693 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2AZMVi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 07:21:38 -0500
Received: from morden (ip-109-90-229-210.unitymediagroup.de [109.90.229.210])
	by smtp.strato.de (fruni mo19) (RZmta 27.5 DYNA|AUTH)
	with (AES128-SHA encrypted) ESMTPA id C07194o0QBWfve
	for <linux-media@vger.kernel.org>;
	Thu, 26 Jan 2012 13:21:17 +0100 (MET)
Received: from rjkm by morden with local (Exim 4.77)
	(envelope-from <rjkm@morden.metzler>)
	id 1RqOKL-00010Y-7P
	for linux-media@vger.kernel.org; Thu, 26 Jan 2012 13:21:17 +0100
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20257.17724.917769.890215@morden.metzler>
Date: Thu, 26 Jan 2012 13:21:16 +0100
To: linux-media@vger.kernel.org
Subject: Re: CI/CAM support for offline (from file) decoding
In-Reply-To: <1528925641.20120125233437@bitklub.hu>
References: <18710154015.20120125181510@bitklub.hu>
	<4F20429F.6030003@maindata.sk>
	<1528925641.20120125233437@bitklub.hu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kovacs Balazs writes:
 > Yes,  i  thought about that, but i need the Hardware CAM + CI, because
 > it's chip paired encryption. It means in my situation that the EMM and
 > ECM is also encrypted so it's hard to use in a SoftCam configuration.
 > 
 > I hope there's a solution in the DVB driver space.
 > 
 > I receive the signal via RF or IP. If via RF i think it can be decoded
 > via  the  HW,  and  the  record  it  to  disk,  but i need the full TS
 > decrypted, and i think it's not possible (to decrypt all the encrypted
 > ES  which  can be 20-30-40 in real time when i receive the signal). In
 > IP  configuration  it's also not possible. So i have the recorded full
 > TS  pieces  and somehow i have to decrypt with a CAM+Card paired to each
 > other.  Of  course  i know that the decryption is only possible if the
 > Smartcard  has  the  authorization in those date ranges when the files
 > was recorded. I have seen this kind of solution in Windows, but i need
 > it on Linux now.

Yes, you can do that, but only if the hardware supports it. Most cards
with CAM/CI are hardwired in such a way that the transport stream
comes from the demodulator, goes through the CAM/CI and then into the
PCIe/PCI bridge. There are only a few cards where you can send a TS from
memory to the CAM/CI and back.

-Ralph



 
