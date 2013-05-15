Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:38798 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3EOVxc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 May 2013 17:53:32 -0400
Received: by mail-lb0-f170.google.com with SMTP id t11so2434310lbd.29
        for <linux-media@vger.kernel.org>; Wed, 15 May 2013 14:53:31 -0700 (PDT)
To: horms@verge.net.au, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 0/3] R8A7779/Marzen R-Car VIN driver support
Cc: magnus.damm@gmail.com, linux@arm.linux.org.uk, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com, linux-media@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Thu, 16 May 2013 01:53:29 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305160153.29827.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

   Here's the set of 3 patches against the Simon Horman's 'renesas.git' repo,
'renesas-next-20130515v2' tag and my recent yet unapplied USB/I2C patches.
Here we add the VIN driver platform code for the R8A7779/Marzen with ADV7180
I2C video decoder.

[1/3] ARM: shmobile: r8a7779: add VIN support
[2/3] ARM: shmobile: Marzen: add VIN and ADV7180 support
[3/3] ARM: shmobile: Marzen: enable VIN and ADV7180 in defconfig

   The VIN driver itself has been excluded from the series as it will be developed
against Mauro's 'media_tree.git' plus some yet unapplied patches in the future...

WBR, Sergei
