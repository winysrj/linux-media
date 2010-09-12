Return-path: <mchehab@localhost.localdomain>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:8898 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab0ILTz4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 15:55:56 -0400
Subject: Need info to understand TeVii S470 cx23885 MSI  problem
From: Andy Walls <awalls@md.metrocast.net>
To: "Igor M.Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Sep 2010 15:56:57 -0400
Message-ID: <1284321417.2394.10.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Igor,

To help understand the problem with the TeVii S470 CX23885 MSI not
working after module unload and reload, could you provide the output of

	# lspci -d 14f1: -xxxx -vvvv

as root before the cx23885 module loads, after the module loads, and
after the module is removed and reloaded?

please also provide the MSI IRQ number listed in dmesg
(or /var/log/messages) assigned to the card.  Also the IRQ number of the
unhandled IRQ when the module is reloaded.

The linux kernel should be writing the MSI IRQ vector into the PCI
configuration space of the CX23885.  It looks like when you unload and
reload the cx23885 module, it is not changing the vector.

Regards,
Andy



