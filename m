Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd16922.kasserver.com ([85.13.137.202]:50337 "EHLO
	dd16922.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0B1XHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 18:07:00 -0500
Received: from [127.0.0.1] (p50815EF5.dip.t-dialin.net [80.129.94.245])
	by dd16922.kasserver.com (Postfix) with ESMTPA id A51B610FC0FB
	for <linux-media@vger.kernel.org>; Mon,  1 Mar 2010 00:06:58 +0100 (CET)
Message-ID: <4B8AF722.8000105@helmutauer.de>
Date: Mon, 01 Mar 2010 00:07:14 +0100
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Mantis not in modules.pcimap
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The mantis module is build and working fine with the Skystar2 HD, but it I cannot autodetect it,
because modules.pcimap is not filled with the vendor id of the card using this module.
What's to do  to get these ID's ?
In my case its a:

01:08.0 0480: 1822:4e35 (rev 01)
	Subsystem: 1ae4:0003
	Flags: bus master, medium devsel, latency 32, IRQ 16
	Memory at fddff000 (32-bit, prefetchable) [size=4K]

-- 
Helmut Auer, helmut@helmutauer.de
