Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44425 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbaI1K2U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 06:28:20 -0400
Received: by mail-pd0-f174.google.com with SMTP id g10so14787532pdj.5
        for <linux-media@vger.kernel.org>; Sun, 28 Sep 2014 03:28:19 -0700 (PDT)
Message-ID: <5427E2BF.3040808@gmail.com>
Date: Sun, 28 Sep 2014 19:28:15 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] pt3: fix DTV FE I2C driver load error paths
References: <1411782336-28235-1-git-send-email-crope@iki.fi>
In-Reply-To: <1411782336-28235-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Maybe that is proper fix. I didn't test it.

I had some tests with/without inserting a deliberate error return
from dvb_register_frontend() and with/without CONFIG_MODULES option,
and the all combinations seem to have worked fine.

kiitos, Antti and Randy.
--
akihiro
