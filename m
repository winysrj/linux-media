Return-path: <linux-media-owner@vger.kernel.org>
Received: from abby.lhr1.as41113.net ([91.208.177.20]:17800 "EHLO
	abby.lhr1.as41113.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab2DLEmR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Apr 2012 00:42:17 -0400
Received: from [172.16.11.44] (unknown [91.208.177.193])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lists@rewt.org.uk)
	by abby.lhr1.as41113.net (Postfix) with ESMTPSA id AF91022814
	for <linux-media@vger.kernel.org>; Thu, 12 Apr 2012 05:36:47 +0100 (BST)
Message-ID: <4F865BD6.3010402@rewt.org.uk>
Date: Thu, 12 Apr 2012 05:36:38 +0100
From: Joe Holden <lists@rewt.org.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: pctv452e usb (Technotrend TT Connect S2-3600) & DM1105N
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

Since updating to 3.3.1 from 3.2.x my DVB-S2 tuner has stopped working 
and seems to block when accessed:

[ 6182.111792] pctv452e: I2C error -110; AA 0F  D0 03 00 -> AA 0F  D0 03 00.
[ 6182.419919] dvb-usb: error -110 while querying for an remote control 
event.
[ 6182.989972] dvb-usb: error -110 while querying for an remote control 
event.
[ 6184.170082] dvb-usb: bulk message failed: -110 (4/0)
[ 6184.185065] dvb-usb: error -110 while querying for an remote control 
event.
[ 6184.356753] dvb-usb: error -110 while querying for an remote control 
event.

The I2C errors were logged under 3.2 also but the card still worked.
Has anything substantanial changed? Can enable debug and/or ssh access 
if it would help diagnose the problem...

I also have a DM1105 based card that doesn't attach:

[ 1623.471563] DVB: registering new adapter (dm1105)
[ 1623.721678] dm1105 0000:00:0b.0: MAC 00:00:00:00:00:00
[ 1645.919891] si21xx: si21xx_attach
[ 1651.283255] si21xx: si21_readreg: readreg error (reg == 0x01, ret == -6)
[ 1656.653869] si21xx: si21_writereg: writereg error (reg == 0x01, data 
== 0x40, ret == -6)
[ 1662.223209] si21xx: si21_readreg: readreg error (reg == 0x00, ret == -6)
[ 1662.223235] dm1105 0000:00:0b.0: could not attach frontend

Any idea what I could do to find out whats wrong?

Thanks,
J
