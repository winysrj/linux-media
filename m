Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60590 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbaFYWo5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 18:44:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Reverted patch in v4l-utils
Date: Thu, 26 Jun 2014 00:45:47 +0200
Message-ID: <9493283.4VN14WAqps@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

I've realized today that I had pushed a commit named "wip" by mistake to the 
v4l-utils master branch. As other commits have been pushed on top of that I 
have decided to revert the offending commit instead of rebasing the tree. 
Please feel free to rebase and remove both the original commit and the revert 
if preferred.

Sorry for the inconvenience this have caused.

-- 
Regards,

Laurent Pinchart

