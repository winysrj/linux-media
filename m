Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:44411 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab3DWRT1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 13:19:27 -0400
Received: by mail-la0-f43.google.com with SMTP id ea20so782499lab.30
        for <linux-media@vger.kernel.org>; Tue, 23 Apr 2013 10:19:26 -0700 (PDT)
To: horms@verge.net.au, linux-sh@vger.kernel.org, mchehab@redhat.com,
	linux-media@vger.kernel.org, linus.walleij@linaro.org
Subject: [PATCH v3 0/5] OKI ML86V7667 driver and R8A7778/BOCK-W VIN support
Cc: magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-arm-kernel@lists.infradead.org, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Tue, 23 Apr 2013 21:18:42 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304232118.43686.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

   Here's the set of 5 patches against the Simon Horman's 'renesas.git' repo,
'renesas-next-20130422' tag and my recent yet unapplied patches. Here we
add the OKI ML86V7667 video decoder driver and the VIN platform code working on
the R8A7778/BOCK-W with ML86V7667. The driver patch also applies (with offsets)
to Mauro's 'media_tree.git'...

[1/5] V4L2: I2C: ML86V7667 video decoder driver
[2/5] sh-pfc: r8a7778: add VIN pin groups
[3/5] ARM: shmobile: r8a7778: add VIN support
[4/5] ARM: shmobile: BOCK-W: add VIN and ML86V7667 support
[5/5] ARM: shmobile: BOCK-W: enable VIN and ML86V7667 in defconfig

WBR, Sergei
