Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:43654 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3EPVWc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 17:22:32 -0400
Received: by mail-lb0-f177.google.com with SMTP id 13so3579294lba.8
        for <linux-media@vger.kernel.org>; Thu, 16 May 2013 14:22:31 -0700 (PDT)
To: horms@verge.net.au, linux-sh@vger.kernel.org, mchehab@redhat.com,
	linux-media@vger.kernel.org, linus.walleij@linaro.org
Subject: [PATCH v4 0/3] R8A7778/BOCK-W R-Car VIN driver support
Cc: magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-arm-kernel@lists.infradead.org, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Fri, 17 May 2013 01:22:33 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305170122.33996.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

   Here's the set of 3 patches against the Simon Horman's 'renesas.git' repo,
'renesas-next-20130515v2' tag and my recent yet unapplied patches. Here we
add the VIN platform code working on
the R8A7778/BOCK-W with ML86V7667. The driver patch also applies (with offsets)
to Mauro's 'media_tree.git'...

[1/3] ARM: shmobile: r8a7778: add VIN support
[2/3] ARM: shmobile: BOCK-W: add VIN and ML86V7667 support
[3/3] ARM: shmobile: BOCK-W: enable VIN and ML86V7667 in defconfig

   The patch containing OKI ML86V7667 video decoder driver has been removed
from the series as it should be applied to the 'media_tree.git' repo. The patch
containing the VIN PFC support has been also removed from the series and has
now been merged.

WBR, Sergei
