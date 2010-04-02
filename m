Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:49045 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab0DBTC7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 15:02:59 -0400
Message-Id: <20100402185827.425741206@hardeman.nu>
Date: Fri, 02 Apr 2010 20:58:27 +0200
From: david@hardeman.nu
To: mchehab@infradead.org
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: [patch 0/3] ir-core keytable patches
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patchset provides a number of bug fixes and additional
features to ir-core in drivers/media/IR.

The first two patches are mostly cleanups to drivers/media/IR/ir-keytable.c
while the third patch is an example of a conversion of
drivers/media/dvb/ttpci/budget-ci.c to use the new functionality (rather
than the drivers/media/IR/ir-functions.c functionality).

-- 
David Härdeman
