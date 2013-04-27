Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55706 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab3D0MOZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Apr 2013 08:14:25 -0400
Received: from mailout-de.gmx.net ([10.1.76.34]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0LpAT4-1V1qXU00Em-00ewsR for
 <linux-media@vger.kernel.org>; Sat, 27 Apr 2013 14:14:24 +0200
Message-ID: <517BC11E.50105@gmx.de>
Date: Sat, 27 Apr 2013 14:14:22 +0200
From: Reinhard Nissl <rnissl@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: stb0899: no lock on dvb-s2 transponders in SCR environment
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

my stb0899 card works properly on dvb-s and dvb-s2 transponders 
when using a direct port on my sat multiswitch.

When using a SCR port on that multiswitch and changing VDR's 
config files accordingly, it only locks on dvb-s transponders.

A SCR converts the selected transponder's frequency after the LNB 
(IF1) to a fixed frequency (for example 1076 MHz) by mixing the 
signal with a local oscialator frequency above IF1 so that the 
lower sideband of the mixing product appears at 1076 MHz.

The lower sideband's spectrum is mirrored compared to the upper 
sideband, which is identical to the original spectrum on the 
original IF1.

Could that be the reason why the stb0899 cannot lock on dvb-s2 
transponders in an SCR environment?

Any ideas on how to get a lock on dvb-s2 transponders?

Bye.
-- 
Dipl.-Inform. (FH) Reinhard Nissl
mailto:rnissl@gmx.de
