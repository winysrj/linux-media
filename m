Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:37200 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2FII6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 04:58:35 -0400
Date: Sat, 9 Jun 2012 11:58:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: bcollins@bluecherry.net
Cc: linux-media@vger.kernel.org
Subject: re: Staging: solo6x10: New driver (staging) for Softlogic 6x10
Message-ID: <20120609085822.GA31637@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Ben Collins,

The patch faa4fd2a0951: "Staging: solo6x10: New driver (staging) for 
Softlogic 6x10" from Jun 17, 2010, leads to the following warning:
drivers/staging/media/solo6x10/tw28.c:352 tw2815_setup()
	 warn: x |= 0

	tbl_ntsc_tw2815_common[0x06] |= 0x03 & (DEFAULT_HDELAY_NTSC >> 8);

DEFAULT_HDELAY_NTSC is less than 256 so after the shift we get:

	tbl_ntsc_tw2815_common[0x06] |= 0x03 & 0;

Which is a noop.  There are several of these complicated noops.

drivers/staging/media/solo6x10/tw28.c:352 tw2815_setup() warn: x |= 0
drivers/staging/media/solo6x10/tw28.c:362 tw2815_setup() warn: x |= 0
drivers/staging/media/solo6x10/tw28.c:367 tw2815_setup() warn: x |= 0
drivers/staging/media/solo6x10/tw28.c:373 tw2815_setup() warn: x |= 0
drivers/staging/media/solo6x10/tw28.c:383 tw2815_setup() warn: x |= 0

regards,
dan carpenter

