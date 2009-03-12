Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110815.mail.gq1.yahoo.com ([67.195.13.238]:46329 "HELO
	web110815.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752952AbZCLJAh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 05:00:37 -0400
Message-ID: <84881.14337.qm@web110815.mail.gq1.yahoo.com>
Date: Thu, 12 Mar 2009 02:00:34 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: SDIO stack patch
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

I have a question regarding patching kernel files which reside outside the 'drivers/media' scope.

The SMS device can use SPI and SDIO host interfaces (among others).

Both those drivers' sources require some patching.

The SDIO stack has been patched by Pierre Ossman himself (maintainer of MMC/SD/SDIO stack) back in summer 2008. 
Pierre asked that those patches will be committed via the LinuxTV's path.

The SPP patches had been written in Siano (very small patch).


My questions:

1) When re-creating the patches (both are quite old, and probably outdated regarding the kernel version which has been used back then), which kernel version should I use for the diff?

2) Since the V4L hg does not contain those files, should I supply -
	A) The entire updated sources files (only)
	B) Only the patches (like it done with v4l's files)
	C) Both


Best regard,

Uri


      
