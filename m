Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound003.roc2.bluetie.com ([208.89.132.143]:45135 "EHLO
	outbound003.roc2.bluetie.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab1LUSXE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 13:23:04 -0500
Received: from web002.roc2.bluetie.com (localhost.localdomain [127.0.0.1])
	by web002.roc2.bluetie.com (Postfix) with ESMTP id CC8433F0160
	for <linux-media@vger.kernel.org>; Wed, 21 Dec 2011 13:14:55 -0500 (EST)
Message-ID: <20111221131455.14056@web002.roc2.bluetie.com>
Date: Wed, 21 Dec 2011 13:14:55 -0500
To: linux-media@vger.kernel.org
From: "Full Name" <danewson@excite.com>
Subject: EasyCAP with identifiers 
Content-transfer-encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just got an EasyCAP usb device with component and S-video inputs, and it d=
oesn't match what I was expecting from reading lists about drivers.

It identifies as 1f71:3306 and is not recognized by my Ubuntu system running=
 3.0.0.

3.0.0-14-generic #23-Ubuntu SMP Mon Nov 21 20:34:47 UTC 2011 i686 i686 i386 =
GNU/Linux

Searching for that usb identifier turned up threads about another device cal=
led Gadmei USB TVBox.  I also found references to the em28xx driver, so I bu=
ilt and installed git://linuxtv.org/media_build.git, but this did not help. =
 The id is not on the list here: http://linuxtv.org/wiki/index.php/Em28xx_de=
vices

Anyone have a good suggestion what to do next?  I think I covered the basics=
, but I'm definitely no expert, so apologies if I overlooked something simpl=
e.
