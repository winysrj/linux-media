Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep19.mx.upcmail.net ([62.179.121.39]:44091 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab2AZNpo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 08:45:44 -0500
Date: Thu, 26 Jan 2012 14:45:33 +0100
From: Kovacs Balazs <basq@bitklub.hu>
Message-ID: <1318986665.20120126144533@bitklub.hu>
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: linux-media@vger.kernel.org
Subject: Re: CI/CAM support for offline (from file) decoding
In-Reply-To: <20257.17724.917769.890215@morden.metzler>
References: <18710154015.20120125181510@bitklub.hu> <4F20429F.6030003@maindata.sk> <1528925641.20120125233437@bitklub.hu> <20257.17724.917769.890215@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1250
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Kovacs Balazs writes:
 >> Yes,  i  thought about that, but i need the Hardware CAM + CI, because
 >> it's chip paired encryption. It means in my situation that the EMM and
 >> ECM is also encrypted so it's hard to use in a SoftCam configuration.
 >> 
 >> I hope there's a solution in the DVB driver space.
 >> 
 >> I receive the signal via RF or IP. If via RF i think it can be decoded
 >> via  the  HW,  and  the  record  it  to  disk,  but i need the full TS
 >> decrypted, and i think it's not possible (to decrypt all the encrypted
 >> ES  which  can be 20-30-40 in real time when i receive the signal). In
 >> IP  configuration  it's also not possible. So i have the recorded full
 >> TS  pieces  and somehow i have to decrypt with a CAM+Card paired to each
 >> other.  Of  course  i know that the decryption is only possible if the
 >> Smartcard  has  the  authorization in those date ranges when the files
 >> was recorded. I have seen this kind of solution in Windows, but i need
 >> it on Linux now.

> Yes, you can do that, but only if the hardware supports it. Most cards
> with CAM/CI are hardwired in such a way that the transport stream
> comes from the demodulator, goes through the CAM/CI and then into the
> PCIe/PCI bridge. There are only a few cards where you can send a TS from
> memory to the CAM/CI and back.

Can you suggest some kind of hardware?

> -Ralph



>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

