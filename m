Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:60516 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966716Ab3DQWHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 18:07:36 -0400
Received: by mail-lb0-f175.google.com with SMTP id o10so2068999lbi.6
        for <linux-media@vger.kernel.org>; Wed, 17 Apr 2013 15:07:34 -0700 (PDT)
To: horms@verge.net.au, magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	g.liakhovetski@gmx.de, mchehab@redhat.com,
	linux-media@vger.kernel.org
Subject: [PATCH 0/4] R-Car VIN driver with R8A7779/Marzen support
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: phil.edworthy@renesas.com, matsu@igel.co.jp
Date: Thu, 18 Apr 2013 02:06:38 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304180206.39465.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

   Here's the set of 4 patches against the Simon Horman's 'renesas.git' repo,
'renesas-next-20130417' tag and my recent yet unapplied patches. Here we
add the VIN (Video In) driver and its platform code working on the R8A7779/
Marzen with ADV7180 I2C camera sensor. The driver patch also applies without
issues to Mauro's 'media_tree.git'...

[1/4] V4L2: soc_camera: Renesas R-Car VIN driver
[2/4] ARM: shmobile: r8a7779: add VIN support
[3/4] ARM: shmobile: Marzen: add VIN and ADV7180 support
[4/4] ARM: shmobile: Marzen: enable VIN and ADV7180 in defconfig

WBR, Sergei
