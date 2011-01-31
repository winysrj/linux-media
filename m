Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:52697 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1AaWkH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 17:40:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Pk2Pm-0006K8-3e
	for linux-media@vger.kernel.org; Mon, 31 Jan 2011 23:40:06 +0100
Received: from vodsl-9417.vo.lu ([85.93.203.201])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 31 Jan 2011 23:40:06 +0100
Received: from steltek by vodsl-9417.vo.lu with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 31 Jan 2011 23:40:06 +0100
To: linux-media@vger.kernel.org
From: Michel Meyers <steltek@tcnnet.com>
Subject: ds3000 broken in s2-liplianin?
Date: Mon, 31 Jan 2011 18:40:38 +0000 (UTC)
Message-ID: <loom.20110131T193732-431@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

Just wondering if anybody else has had issues with dw2102/ds3000 recently? 
I just had two systems completely hang when I plugged in either my TeVii S660 or 
my Terratec Cinergy S2 USB HD. (No error messages, complete system freeze.) The 
fix seems to be to revert to Mercurial changeset 15364 / 414e0bbd99bf.

- Michel

