Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17785 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbcAGO5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jan 2016 09:57:14 -0500
Date: Thu, 7 Jan 2016 17:56:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-media@vger.kernel.org
Cc: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
Subject: [bug report] bt8xx/bttv-cards: module_param issue
Message-ID: <20160107145655.GA15551@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was looking at typos in MODULE_PARM_DESC() and I noticed a problem in
drivers/media/pci/bt8xx/bttv-cards.c

MODULE_PARM_DESC(saa6588, "if 1, then load the saa6588 RDS module, default (0) is to use the card definition.");

The saa6588[] array is not set up as a module parameter so you can't
actually use this setting.  I don't know if it's better to delete it or
enable it.

regards,
dan carpenter
