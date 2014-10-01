Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34742 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaJAFUc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 01:20:32 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com, crope@iki.fi
Subject: [PATCH V2 00/13] cx231xx: Use muxed i2c adapters instead of custom switching
Date: Wed,  1 Oct 2014 07:20:08 +0200
Message-Id: <1412140821-16285-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series changes cx231xx driver to use standard muxed i2c busses.
Everything works as before (tested with Hauppauge WinTV-930C-HD).
Also the scanning is changed to these new busses, but still does not work (as before).

Change scanning to read 1 byte instead of 0 only works for one bus.


V2: The constants are changed so muxed adapters are named I2C_1_MUX_1 and I2C_1_MUX_3.
With I2C_1 the underlying adapter could be reached (not recommended).

Regards
Matthias

