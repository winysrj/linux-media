Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:61456 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab3DTUOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Apr 2013 16:14:44 -0400
Received: by mail-lb0-f172.google.com with SMTP id u10so4640415lbi.3
        for <linux-media@vger.kernel.org>; Sat, 20 Apr 2013 13:14:42 -0700 (PDT)
To: horms@verge.net.au, magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	mchehab@redhat.com, linux-media@vger.kernel.org
Subject: [PATCH 0/5] OKI ML86V7667 driver and R8A7778/BOCK-W VIN support
Cc: matsu@igel.co.jp, vladimir.barinov@cogentembedded.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Sun, 21 Apr 2013 00:13:45 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304210013.46110.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

   Here's the set of 4 patches against the Simon Horman's 'renesas.git' repo,
'renesas-next-20130419' tag and my recent yet unapplied patches. Here we
add the OKI ML86V7667 video decoder driver and the VIN platform code working on
the R8A7778/BOCK-W with ML86V7667. The driver patch also applies (with offsets)
to Mauro's 'media_tree.git'...

[1/5] V4L2: I2C: ML86V7667 video decoder driver
[2/5] sh-pfc: r8a7778: add VIN pin groups
[3/5] ARM: shmobile: r8a7778: add VIN support
[4/5] ARM: shmobile: BOCK-W: add VIN and ADV7180 support
[5/5] ARM: shmobile: BOCK-W: enable VIN and ADV7180 in defconfig

WBR, Sergei
