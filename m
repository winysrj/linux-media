Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:61991 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934479Ab3DSWbA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 18:31:00 -0400
Received: by mail-la0-f44.google.com with SMTP id ed20so996852lab.3
        for <linux-media@vger.kernel.org>; Fri, 19 Apr 2013 15:30:58 -0700 (PDT)
To: horms@verge.net.au, magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	g.liakhovetski@gmx.de, mchehab@redhat.com,
	linux-media@vger.kernel.org
Subject: [PATCH v2 0/4] R-Car VIN driver with R8A7779/Marzen support
Cc: phil.edworthy@renesas.com, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Sat, 20 Apr 2013 02:30:07 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304200230.08819.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

   Here's the set of 4 patches against the Simon Horman's 'renesas.git' repo,
'renesas-next-20130419' tag and my recent yet unapplied USB patches. Here we
add the VIN (Video In) driver and its platform code working on the R8A7779/
Marzen with ADV7180 I2C camera sensor. The driver patch also applies without
issues to Mauro's 'media_tree.git'...

[1/4] V4L2: soc_camera: Renesas R-Car VIN driver
[2/4] ARM: shmobile: r8a7779: add VIN support
[3/4] ARM: shmobile: Marzen: add VIN and ADV7180 support
[4/4] ARM: shmobile: Marzen: enable VIN and ADV7180 in defconfig

WBR, Sergei
