Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:46743 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753817Ab2BVWVF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 17:21:05 -0500
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] Support for AF9035/AF9033
Date: Wed, 22 Feb 2012 23:20:56 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201202222320.56583.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have written a driver for the AF9035 & AF9033 (called af903x), based on the 
various drivers and information floating around for these chips.
Currently, my driver only supports the devices that I am able to test. These 
are
- Terratec T5 Ver.2 (also known as T6)
- Avermedia Volar HD Nano (A867)

The driver supports:
- diversity and dual tuner (when the first frontend is used, it is in diversity 
mode, when two frontends are used in dual tuner mode)
- multiple devices
- pid filtering
- remote control in NEC and RC-6 mode (currently not switchable, but depending 
on device)
- support for kernel 3.1, 3.2 and 3.3 series

I have not tried to split the driver in a DVB-T receiver (af9035) and a 
frontend (af9033), because I do not see the sense in doing that for a 
demodulator, that seems to be always used in combination with the very same 
receiver.

The patch is split in three parts:
Patch 1: support for tuner fitipower FC0012
Patch 2: basic driver
Patch 3: firmware

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
