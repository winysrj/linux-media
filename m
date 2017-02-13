Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63762 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751786AbdBMPKt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 10:10:49 -0500
Date: Mon, 13 Feb 2017 16:10:43 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: patch superseded? (was: [linux-media] Patch notification: 1 patch
 updated)
Message-ID: <Pine.LNX.4.64.1702131608170.11034@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

According to the explanations below, "superseded" means, that either a 
newer version of the patch is available, or it's been included in a pull 
request. Since I don't see a newer version, I should assume, that it's 
been included in a pull request. However, I don't see one on linux-media 
either. How am I supposed to track such patch status changes?

Thanks
Guennadi

---------- Forwarded message ----------
Date: Mon, 13 Feb 2017 14:56:01 -0000
From: Patchwork <patchwork@linuxtv.org>
To: g.liakhovetski@gmx.de
Subject: [linux-media] Patch notification: 1 patch updated

Hello,

The following patch (submitted by you) has been updated in patchwork:

 * linux-media: V4L: add Y12I, Y8I and Z16 pixel format documentation
     - http://patchwork.linuxtv.org/patch/32257/
     - for: Linux Media kernel patches
    was: New
    now: Superseded

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
