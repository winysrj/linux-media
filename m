Return-path: <mchehab@pedra>
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:43251 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0JPRb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 13:31:57 -0400
Received: from relay2-v.mail.gandi.net (relay2-v.mail.gandi.net [217.70.178.76])
	by slow3-v.mail.gandi.net (Postfix) with ESMTP id A6A893840E
	for <linux-media@vger.kernel.org>; Sat, 16 Oct 2010 19:31:56 +0200 (CEST)
Received: from mfilter2-d.gandi.net (mfilter2-d.gandi.net [217.70.178.42])
	by relay2-v.mail.gandi.net (Postfix) with ESMTP id 60D07135E5
	for <linux-media@vger.kernel.org>; Sat, 16 Oct 2010 19:31:32 +0200 (CEST)
Received: from relay2-v.mail.gandi.net ([217.70.178.76])
	by mfilter2-d.gandi.net (mfilter2-d.gandi.net [217.70.178.42]) (amavisd-new, port 10024)
	with ESMTP id KGY2RRIdtEPD for <linux-media@vger.kernel.org>;
	Sat, 16 Oct 2010 19:31:29 +0200 (CEST)
Received: from [192.168.1.112] (cpc6-glfd5-2-0-cust126.6-2.cable.virginmedia.com [80.4.117.127])
	(Authenticated sender: hadess@hadess.net)
	by relay2-v.mail.gandi.net (Postfix) with ESMTPSA id B8088135DA
	for <linux-media@vger.kernel.org>; Sat, 16 Oct 2010 19:31:29 +0200 (CEST)
Subject: Support for ATI DVB TV Tuner?
From: Bastien Nocera <hadess@hadess.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 16 Oct 2010 18:31:28 +0100
Message-ID: <1287250288.3678.3.camel@novo.hadess.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Heya,

My new desktop, a Lenovo Ideacentre A700, has one of those TV tuners. Is
there any driver available for it, or a driver that would just be
missing some PCI IDs?

Here's the lspci output:
03:00.0 Multimedia controller [0480]: ATI Technologies Inc Device [1002:ac12]
	Subsystem: Yuan Yuan Enterprise Co., Ltd. Device [12ab:0003]
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at fe400000 (64-bit, non-prefetchable) [size=1M]
	Memory at d0100000 (64-bit, prefetchable) [size=128K]
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Endpoint, MSI 00
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>

Ideas?

Cheers

PS: Please CC: me on replies as I'm not subscribed to the list

