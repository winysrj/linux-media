Return-path: <linux-media-owner@vger.kernel.org>
Received: from b4ckbone.de ([87.106.9.235]:59535 "EHLO b4ckbone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757AbcBHXcY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 18:32:24 -0500
Received: from localhost (b4ckbone.de [127.0.0.1])
	by b4ckbone.de (Postfix) with ESMTP id 989C821581265
	for <linux-media@vger.kernel.org>; Tue,  9 Feb 2016 00:23:56 +0100 (CET)
Received: from b4ckbone.de ([127.0.0.1])
	by localhost (alpha.b4ckbone.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ZUEJhu6TgdQy for <linux-media@vger.kernel.org>;
	Tue,  9 Feb 2016 00:23:41 +0100 (CET)
From: Hendrik Grewe <lists@b4ckbone.de>
Subject: Regression DVB driver cx23885/ TeVii S470
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-ID: <56B9237C.2070008@b4ckbone.de>
Date: Tue, 9 Feb 2016 00:23:40 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone!

I recently upgraded from Ubuntu 14.04 LTS with stock 3.13 kernel to
Ubuntu 15.10 with kernel 4.2.0. My DVB card (Tevii S470 [1]) stopped
working and is no longer listed by lspci nor lshw even after installing
firmware.

I also did try the mainline kernels (4.3.0 and 4.4.1) from [2]. I do not
know how to proceed any further (since the card is not detected) nor do
I know if there is a known bug/regression tracked anywhere.

I do have the dmesg and lspci output from working 14.04 (3.13 kernel)
but do not know if they are of any use.

Thanks in advance

Hendrik

[1] https://www.linuxtv.org/wiki/index.php/TeVii_S470
[2] http://kernel.ubuntu.com/~kernel-ppa/mainline/
