Return-path: <linux-media-owner@vger.kernel.org>
Received: from cavspool01.kulnet.kuleuven.be ([134.58.240.41]:60909 "EHLO
	cavspool01.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753412Ab0BHQa3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 11:30:29 -0500
Received: from cavuit02.kulnet.kuleuven.be (cavuit02.kulnet.kuleuven.be [134.58.240.44])
	by cavspool01.kulnet.kuleuven.be (Postfix) with ESMTP id 930E6D01C3
	for <linux-media@vger.kernel.org>; Mon,  8 Feb 2010 16:57:57 +0100 (CET)
Received: from smtps01.kuleuven.be (smtpshost01.kulnet.kuleuven.be [134.58.240.74])
	by cavuit02.kulnet.kuleuven.be (Postfix) with ESMTP id DA24351C009
	for <linux-media@vger.kernel.org>; Mon,  8 Feb 2010 16:56:41 +0100 (CET)
Received: from hydrogen.esat.kuleuven.be (hydrogen.esat.kuleuven.be [134.58.56.153])
	by smtps01.kuleuven.be (Postfix) with ESMTP id E490331E703
	for <linux-media@vger.kernel.org>; Mon,  8 Feb 2010 16:56:41 +0100 (CET)
Received: from matar.esat.kuleuven.be (matar.esat.kuleuven.be [10.33.133.74])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by hydrogen.esat.kuleuven.be (Postfix) with ESMTP id CF9F248002
	for <linux-media@vger.kernel.org>; Mon,  8 Feb 2010 16:56:41 +0100 (CET)
From: Markus Moll <markus.moll@esat.kuleuven.be>
To: linux-media@vger.kernel.org
Subject: Terratec H5 / Micronas
Date: Mon, 8 Feb 2010 16:56:36 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002081656.41640.markus.moll@esat.kuleuven.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I have just bought one of these terratec usb sticks (without looking at the 
list of supported devices first, my fault, I know) and I guess I'm unable to 
return it. Before I give it away for free or sell it at a much lower price, I 
wanted to ask a few things. Let me recapitulate the story as I understood it. 
Devin Heitmueller once worked on a driver implementation using official 
Micronas data-sheets and their reference implementation. The Micronas legal 
department then denied publication in a very late stage. Meanwhile, Markus 
Rechberger wrote his own user-space closed-source driver, but has now stopped 
distributing that and instead founded his own company Sundtek. Furthermore, 
parts of Micronas have been bought by Trident Microsystems.

I hope I'm correct up to here. I also saw an estimate of the amount of work 
required to write a reverse engineered driver, it ranged around 50hrs.
My question is, did the Micronas legal department intervene because the linux 
driver built on top of their reference implementation and they weren't willing 
to gpl that, or did they also oppose on using the data-sheets? If it was only 
the reference driver, wouldn't it be whorthwhile trying to again get the data 
sheets and build a driver based solely on these? I couldn't find any post that 
would clarify this.

I would be willing to invest some time, play with the device and see if I can 
improve the situation, probably even if I really had to reverse engineer. 
However, I'm in no way an expert in v4l driver writing, so I don't know where 
this will lead to or if I'm going to brick the device on the very first 
occasion ;-) (btw: how easy is that, generally?)

I know that the general advice is to dump these devices and buy something 
else, but as I said I'll have this hardware lying around anyway. So I'd like 
to know if I missed something, if there is any prior work (unaffected by the 
legal problems), or if I'm bound to fail because the task is just too big.

Markus
