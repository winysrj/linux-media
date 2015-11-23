Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48912 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbbKWTV2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 14:21:28 -0500
Received: from [IPv6:2001:a62:10f2:b201:314a:d4d8:6ffc:6a45] (unknown [IPv6:2001:a62:10f2:b201:314a:d4d8:6ffc:6a45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: zzam)
	by smtp.gentoo.org (Postfix) with ESMTPSA id 3D5A933FE13
	for <linux-media@vger.kernel.org>; Mon, 23 Nov 2015 19:21:27 +0000 (UTC)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Matthias Schwarzott <zzam@gentoo.org>
Subject: media_build using regmap-i2c
Message-ID: <56536722.10303@gentoo.org>
Date: Mon, 23 Nov 2015 20:21:06 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I noticed for a media_build installation, that tda10071 was not loadable
because regmap-i2c did not exist.

The only way I saw to get regmap-i2c compiled, is to enable any other
kernel module that has a "select REGMAP_I2C" in Kconfig.
I choose "CONFIG_SENSORS_ADS7828=m".

Maybe the kernel needs a way to enable this module "for external
drivers" as the "Library routines" folders.

Regards
Matthias
