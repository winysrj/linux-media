Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:51098 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab0KLPpc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 10:45:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/10] MCDE: Add pixel processing registers
Date: Fri, 12 Nov 2010 16:46:12 +0100
Cc: Jimmy Rubin <jimmy.rubin@stericsson.com>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	Dan Johansson <dan.johansson@stericsson.com>,
	Linus Walleij <linus.walleij@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com> <1289390653-6111-3-git-send-email-jimmy.rubin@stericsson.com> <1289390653-6111-4-git-send-email-jimmy.rubin@stericsson.com>
In-Reply-To: <1289390653-6111-4-git-send-email-jimmy.rubin@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011121646.12927.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday 10 November 2010, Jimmy Rubin wrote:
> This patch adds support for MCDE, Memory-to-display controller
> found in the ST-Ericsson ux500 products.
> 
> This patch adds pixel processing registers found in MCDE.
> 
> Signed-off-by: Jimmy Rubin <jimmy.rubin@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij.stericsson.com>

The same comments I gave for the configuration registers
apply to this one and the other headers as well.

	Arnd
