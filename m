Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:34737 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab3HVVTJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 17:19:09 -0400
Received: by mail-la0-f47.google.com with SMTP id eo20so1874431lab.6
        for <linux-media@vger.kernel.org>; Thu, 22 Aug 2013 14:19:07 -0700 (PDT)
To: horms@verge.net.au, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	m.chehab@samsung.com
Subject: [PATCH v5 0/3] R8A7779/Marzen R-Car VIN driver support
Cc: magnus.damm@gmail.com, linux@arm.linux.org.uk,
	vladimir.barinov@cogentembedded.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Fri, 23 Aug 2013 01:19:13 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308230119.13783.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

   [Resending with a real version #.]

   Here's the set of 3 patches against the Mauro's 'media_tree.git' repo's
'master' branch. Here we add the VIN driver platform code for the R8A7779/Marzen
with ADV7180 I2C video decoder.

[1/3] ARM: shmobile: r8a7779: add VIN support
[2/3] ARM: shmobile: Marzen: add VIN and ADV7180 support
[3/3] ARM: shmobile: Marzen: enable VIN and ADV7180 in defconfig

    Mauro has kindly agreed to merge this patchset thru his tree to resolve the
dependency on the driver's platform data header, provided that the maintainer
ACKs this. Simon, could you ACK the patchset ASAP -- Mauro expects to close his
tree for 3.12 this weekend or next Monday?

WBR, Sergei
