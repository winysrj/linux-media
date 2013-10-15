Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41225 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533Ab3JOQHG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 12:07:06 -0400
Received: from n2100.arm.linux.org.uk ([2002:4e20:1eda:1:214:fdff:fe10:4f86]:37420)
	by caramon.arm.linux.org.uk with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <linux@arm.linux.org.uk>)
	id 1VW79A-00085l-76
	for linux-media@vger.kernel.org; Tue, 15 Oct 2013 17:07:00 +0100
Received: from linux by n2100.arm.linux.org.uk with local (Exim 4.76)
	(envelope-from <linux@n2100.arm.linux.org.uk>)
	id 1VW798-0005OW-7t
	for linux-media@vger.kernel.org; Tue, 15 Oct 2013 17:06:58 +0100
Date: Tue, 15 Oct 2013 17:06:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-media@vger.kernel.org
Subject: Fwd: [linux-media] Patch notification: 1 patch updated
Message-ID: <20131015160657.GE25034@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bad move.

----- Forwarded message from Patchwork <patchwork@linuxtv.org> -----

Date: Tue, 15 Oct 2013 15:58:03 -0000
From: Patchwork <patchwork@linuxtv.org>
To: rmk+kernel@arm.linux.org.uk
Subject: [linux-media] Patch notification: 1 patch updated
Delivery-date: Tue, 15 Oct 2013 16:58:09 +0100

Hello,

The following patch (submitted by you) has been updated in patchwork:

 * linux-media: [31/51] DMA-API: media: omap3isp: use dma_coerce_mask_and_coherent()
     - http://patchwork.linuxtv.org/patch/20178/
     - for: Linux Media kernel patches
    was: New
    now: Accepted

This email is a notification only - you do not need to respond.

-

Patches submitted to linux-media@vger.kernel.org have the following
possible states:

New: Patches not yet reviewed (typically new patches);

Under review: When it is expected that someone is reviewing it (typically,
	      the driver's author or maintainer). Unfortunately, patchwork
	      doesn't have a field to indicate who is the driver maintainer.
	      If in doubt about who is the driver maintainer please check the
	      MAINTAINERS file or ask at the ML;

Superseded: when the same patch is sent twice, or a new version of the
	    same patch is sent, and the maintainer identified it, the first
	    version is marked as such. It is also used when a patch was
	    superseeded by a git pull request.

Obsoleted: patch doesn't apply anymore, because the modified code doesn't
	   exist anymore.

Changes requested: when someone requests changes at the patch;

Rejected: When the patch is wrong or doesn't apply. Most of the
	  time, 'rejected' and 'changes requested' means the same thing
	  for the developer: he'll need to re-work on the patch.

RFC: patches marked as such and other patches that are also RFC, but the
     patch author was not nice enough to mark them as such. That includes:
	- patches sent by a driver's maintainer who send patches
	  via git pull requests;
	- patches with a very active community (typically from developers
	  working with embedded devices), where lots of versions are
	  needed for the driver maintainer and/or the community to be
	  happy with.

Not Applicable: for patches that aren't meant to be applicable via 
	        the media-tree.git.

Accepted: when some driver maintainer says that the patch will be applied
	  via his tree, or when everything is ok and it got applied
	  either at the main tree or via some other tree (fixes tree;
	  some other maintainer's tree - when it belongs to other subsystems,
	  etc);

If you think any status change is a mistake, please send an email to the ML.

-

This is an automated mail sent by the patchwork system at
patchwork.linuxtv.org. To stop receiving these notifications, edit
your mail settings at:
  http://patchwork.linuxtv.org/mail/

----- End forwarded message -----
