Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:60994 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748Ab1JJUwv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Oct 2011 16:52:51 -0400
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 2BE752050D
	for <linux-media@vger.kernel.org>; Mon, 10 Oct 2011 16:52:51 -0400 (EDT)
Received: from bowman.localnet (unknown [50.72.131.188])
	by mail.messagingengine.com (Postfix) with ESMTPSA id EE65B4028CA
	for <linux-media@vger.kernel.org>; Mon, 10 Oct 2011 16:52:50 -0400 (EDT)
From: Lyle Sigurdson <lyle@sent.com>
To: linux-media@vger.kernel.org
Subject: saa7164[0]: can't get MMIO memory @ 0x0 or 0x0
Date: Mon, 10 Oct 2011 15:52:35 -0500
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110101552.35977.lyle@sent.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all, and thanks for all your work.  But, I'm having a problem.

Tuner card: Hauppauge! HVR-2250
Mainboard: MSNV-939
Distro: Slackware64 13.1 (kernel 2.6.33.4)

When I modprobe saa7164:
bowman kernel: saa7164[0]: can't get MMIO memory @ 0x0 or 0x0
bowman kernel: CORE saa7164[0] No more PCIe resources for subsystem: 0070:8851
bowman kernel: saa7164: probe of 0000:04:00.0 failed with	error -22

It turns out that pci_resource_start and pci_resource_len are both returning 
null.

What could be the cause of this?  Is there a solution? 

   Lyle.	
