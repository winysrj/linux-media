Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep12.mx.upcmail.net ([62.179.121.32]:58624 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2AYWeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 17:34:50 -0500
Date: Wed, 25 Jan 2012 23:34:37 +0100
From: Kovacs Balazs <basq@bitklub.hu>
Message-ID: <1528925641.20120125233437@bitklub.hu>
To: Marek Ochaba <ochaba@maindata.sk>
CC: linux-media@vger.kernel.org
Subject: Re: CI/CAM support for offline (from file) decoding
In-Reply-To: <4F20429F.6030003@maindata.sk>
References: <18710154015.20120125181510@bitklub.hu> <4F20429F.6030003@maindata.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yes,  i  thought about that, but i need the Hardware CAM + CI, because
it's chip paired encryption. It means in my situation that the EMM and
ECM is also encrypted so it's hard to use in a SoftCam configuration.

I hope there's a solution in the DVB driver space.

I receive the signal via RF or IP. If via RF i think it can be decoded
via  the  HW,  and  the  record  it  to  disk,  but i need the full TS
decrypted, and i think it's not possible (to decrypt all the encrypted
ES  which  can be 20-30-40 in real time when i receive the signal). In
IP  configuration  it's also not possible. So i have the recorded full
TS  pieces  and somehow i have to decrypt with a CAM+Card paired to each
other.  Of  course  i know that the decryption is only possible if the
Smartcard  has  the  authorization in those date ranges when the files
was recorded. I have seen this kind of solution in Windows, but i need
it on Linux now.

Thank you,

Balazs Kovacs


> I think more feasible way (than using linux kernel DVB layer) is using
> SoftwareCAM with SmartCard reader. Some solution should be also implemented
> in STB, which save records in encrypted state.

> --
> Marek Ochaba

