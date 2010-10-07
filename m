Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:52240 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753695Ab0JGJZQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 05:25:16 -0400
Content-Type: text/plain; charset="utf-8"
Date: Thu, 07 Oct 2010 11:25:12 +0200
From: "Matthias Weber" <matthiaz.weber@gmx.de>
Message-ID: <20101007092512.196710@gmx.net>
MIME-Version: 1.0
Subject: Re: [v4l/dvb] identification/ fixed registration order of DVB cards
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Ok, this was a typo.

# Create a symlink /dev/dvb/adapter100 pointing to dvb card with PCI bus id 04:00.0
SUBSYSTEM=="dvb", KERNEL=="0000:04:00.0", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter100/%%s $${K#*.}'", SYMLINK+="%c"

It works for creating a SYMLINK, so adapter0 and adapter1 still exist. Is there a way for "replacing"? Sorry, I am not very familiar with linux yet.

Cheers
-- 
GMX DSL Doppel-Flat ab 19,99 &euro;/mtl.! Jetzt auch mit 
gratis Notebook-Flat! http://portal.gmx.net/de/go/dsl
