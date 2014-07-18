Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq2.tb.mail.iss.as9143.net ([212.54.42.165]:36924 "EHLO
	smtpq2.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755033AbaGRN4I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 09:56:08 -0400
Received: from [212.54.42.136] (helo=smtp5.tb.mail.iss.as9143.net)
	by smtpq2.tb.mail.iss.as9143.net with esmtp (Exim 4.76)
	(envelope-from <rudy@grumpydevil.homelinux.org>)
	id 1X88DB-0001SM-3I
	for linux-media@vger.kernel.org; Fri, 18 Jul 2014 15:28:33 +0200
Received: from 5ed67808.cm-7-7b.dynamic.ziggo.nl ([94.214.120.8] helo=imail.office.romunt.nl)
	by smtp5.tb.mail.iss.as9143.net with esmtp (Exim 4.76)
	(envelope-from <rudy@grumpydevil.homelinux.org>)
	id 1X88DA-0007Lt-Ni
	for linux-media@vger.kernel.org; Fri, 18 Jul 2014 15:28:33 +0200
Received: from [192.168.1.15] (cenedra.office.romunt.nl [192.168.1.15])
	by imail.office.romunt.nl (8.14.4/8.14.4/Debian-4) with ESMTP id s6IDSWFd022721
	for <linux-media@vger.kernel.org>; Fri, 18 Jul 2014 15:28:32 +0200
Message-ID: <53C920FB.1040501@grumpydevil.homelinux.org>
Date: Fri, 18 Jul 2014 15:28:27 +0200
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: ddbridge -- kernel 3.15.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dears,

I have a ddbridge device:

03:00.0 Multimedia controller: Device dd01:0003
         Subsystem: Device dd01:0021
         Flags: fast devsel, IRQ 17
         Memory at f0900000 (64-bit, non-prefetchable) [size=64K]
         Capabilities: [50] Power Management version 3
         Capabilities: [90] Express Endpoint, MSI 00
         Capabilities: [100] Vendor Specific Information: ID=0000 Rev=0 
Len=00c <?>
         Kernel driver in use: DDBridge

The kernel recognises as seen in dmesg:

[    1.811626] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 
Digital Devices GmbH
[    1.813996] pci 0000:01:19.0: enabling device (0000 -> 0002)
[    1.816033] DDBridge driver detected: Digital Devices PCIe bridge
[    1.816273] HW 0001000d FW 00010004

But /dev/dvb remains empty, only /dev/ddbridge exists.

Any pointers are much appreciated

Cheers


Rudy
