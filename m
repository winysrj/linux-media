Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54663 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753474Ab0FZMJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jun 2010 08:09:32 -0400
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] TT CT-3650 IR and CI support
From: Martin Dauskardt <martin.dauskardt@gmx.de>
Date: Sat, 26 Jun 2010 14:09:24 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006261409.24973.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I can confirm that the patch from Waling works. IR works, and vdr detects the 
Alphacrypt inside the CAM. So I think descrambling would also work, but I have 
no Pay-TV card to test it.
The patch should be merged!
