Return-path: <linux-media-owner@vger.kernel.org>
Received: from fw.sj.tdf-pmm.net ([91.197.165.186]:45597 "EHLO
	mx.fr.smartjog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbZDQK3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 06:29:52 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx.fr.smartjog.net (Postfix) with ESMTP id D559D7EE8
	for <linux-media@vger.kernel.org>; Fri, 17 Apr 2009 12:02:06 +0200 (CEST)
From: Nicolas Noirbent <nicolas.noirbent@smartjog.com>
To: linux-media@vger.kernel.org
Subject: DVB-S / S2 reception issues when upgrading to 2.6.28-6
Date: Fri, 17 Apr 2009 12:02:22 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904171202.23300.nicolas.noirbent@smartjog.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Not sure if this is a bug or intended behaviour, but we're having some
reception issues on some recent DVB-S/S2 cards (Hauppauge Nova S-Plus
and HVR-4000 Lite) after upgrading from 2.6.19-7 to 2.6.28-6 (Vanilla
kernel.org versions)

Steps to reproduce:

szap -c /etc/dvb/transponders <sat> -x
dvbsnoop -adapter 0 -b <PID> | pv > /dev/null

=> nothing

python -c "import time; f = file('/dev/dvb/adapter0/frontend0'); 
time.sleep(1)"

=> Transfer running again

With Debian packages:
dvb-apps 1.1.1+rev1207-4
dvbsnoop 1.4.50-2

Since we basically want constant reception on the DVB network
interface, we deactivated the power-saving features of the DVB cards:

# cat /etc/modprobe.d/dvb-driver
options dvb_core dvb_shutdown_timeout=0 dvb_powerdown_on_sleep=0

>From what I can gather, only the most recent cards (the HVR4000 and
the Nova S-Plus) display this kind of behaviour. It would seem the
power-saving features available on these newer types of card with more
recent drivers could be the cause of the problem: despite the module
options, they'd still power off when the frontend is released (once
again, this is pure speculation on my part).

>From time to time, we also lose satellite reception, and the following
error appears in kern.log:
cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)

Running szap continuously solves the problem, but it seems like an
ugly hack to get this working, especially knowing it worked correctly
in 2.6.19-7.

Cheers,

-- 
Nicolas Noirbent - Core Software Developer
SmartJog SAS - www.smartjog.com - A TDF Group Company
Office: 27, blvd Hippolyte Marques 94200 Ivry-sur-Seine - France EU
Phone: +33 (0)1 5868 6234
