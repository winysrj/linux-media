Return-path: <linux-media-owner@vger.kernel.org>
Received: from [195.7.61.12] ([195.7.61.12]:35283 "EHLO killala.koala.ie"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757175AbZFNKsd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 06:48:33 -0400
Received: from [195.7.61.8] (killarney.koala.ie [195.7.61.8])
	(authenticated bits=0)
	by killala.koala.ie (8.14.0/8.13.7) with ESMTP id n5EAmXN8007812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 14 Jun 2009 11:48:35 +0100
Message-ID: <4A34D581.7080306@koala.ie>
Date: Sun, 14 Jun 2009 11:48:33 +0100
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: {wanted] support for PDTV001 dual tuner PCI DVB-T card [EC188/EC100
 and 2x MxL5003S]
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

just bought one of these on the off-chance that it might work
i did not know what chips were on the car when i bought it
but at €17 for a dual tuner dvb-t pci card i reckoned it was worth a try
i have looked at the card and it has:

the e3c EC188/EC100 pair of pci chips
a pair of MaxLinear MxL5003S silicon tuners

it seems that there is support for the tuners but i only found support 
for the EC168 USB chip set.

is there any prospect of support for this card? i don't think i could 
write it myself but i certainly could test it.

regards
--
simon
