Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.bticino.it ([91.208.195.90]:55797 "EHLO bticino.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753691Ab2LKQdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 11:33:40 -0500
MIME-Version: 1.0
In-Reply-To: 
References: 
Subject: How to manage weighted sections for scene brightness calculation
From: davide.bonfanti@bticino.it
To: linux-media@vger.kernel.org
Date: Tue, 11 Dec 2012 17:18:29 +0100
Message-ID: <OFA252A5DF.4A272640-ONC1257AD1.0059955F-C1257AD1.00599561@grpleg.it>
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset="ISO-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm writing a driver for a CMOS sensor having the following feature:

the frame average brightness value is given by the weighted average of 16 sections.

In other words, the scene is divided into 16 square areas: each area can be weighted differently (from 1 to 4) to achieve the whole scene brightness.



How can I set the 16 weights of the sub-windows from userspace?

Which controls or ioctl can I use to implement such a function?



Thank you for the support,

Davide





Ce message, ainsi que tous les fichiers joints à ce message,

peuvent contenir des informations sensibles et/ ou confidentielles

ne devant pas être divulguées. Si vous n'êtes pas le destinataire

de ce message (ou que vous recevez ce message par erreur), nous

vous remercions de le notifier immédiatement à son expéditeur, et

de détruire ce message. Toute copie, divulgation, modification,

utilisation ou diffusion, non autorisée, directe ou indirecte, de

tout ou partie de ce message, est strictement interdite.



This e-mail, and any document attached hereby, may contain

confidential and/or privileged information. If you are not the

intended recipient (or have received this e-mail in error) please

notify the sender immediately and destroy this e-mail. Any

unauthorized, direct or indirect, copying, disclosure, distribution

or other use of the material or parts thereof is strictly

forbidden.
