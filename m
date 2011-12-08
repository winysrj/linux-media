Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40019 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab1LHM5A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2011 07:57:00 -0500
Received: by eekd41 with SMTP id d41so1145836eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Dec 2011 04:56:59 -0800 (PST)
Message-ID: <4EE0B419.3070604@gmail.com>
Date: Thu, 08 Dec 2011 13:56:57 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 0/1] xc3028: fix center frequency calculation for DTV78 firmware
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,
this patch replaces the previous one proposed in the thread "xc3028:
force reload of DTV7 firmware in VHF band with Zarlink demodulator".
The problem is that the firmware DTV78 works fine in UHF band (8 MHz
bandwidth) but is not working at all in VHF band (7 MHz bandwidth).
Reading the comments inside the code, I figured out that the real
problem could be connected to the formula used to calculate the center
frequency offset in VHF band.

In fact, removing this adjustment fixed the problem:

		if ((priv->cur_fw.type & DTV78) && freq < 470000000)
			offset -= 500000;

This is coherent to what was implemented for the DTV7 firmware by an
Australian user:

		if (priv->cur_fw.type & DTV7)
			offset += 500000;

In the end, the center frequency is the same for all firmwares (DTV7,
DTV8, DTV78) and for both 7 and 8 MHz bandwidth.
Probably, a further offset is hardcoded directly into the firmwares, to
compensate the difference between 7 and 8 MHz bandwidth.

The final code looks clean and simple, and there is no need for any
"magic" adjustment:

		if (priv->cur_fw.type & DTV6)
			offset = 1750000;
		else	/* DTV7 or DTV8 or DTV78 */
			offset = 2750000;

Best regards,
Gianluca Gennari
