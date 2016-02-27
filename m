Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35201 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbcB0MOZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 07:14:25 -0500
Received: by mail-wm0-f41.google.com with SMTP id l68so5012774wml.0
        for <linux-media@vger.kernel.org>; Sat, 27 Feb 2016 04:14:25 -0800 (PST)
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: Problem since commit c73bbaa4ec3e [rc-core: don't lock device at
 rc_register_device()]
Cc: linux-media@vger.kernel.org
Message-ID: <56D19314.3050409@gmail.com>
Date: Sat, 27 Feb 2016 13:14:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since this commit I see the following error when the Nuvoton RC driver is loaded:

input: failed to attach handler kbd to device input3, error: -22

Error 22 (EINVAL) comes from the new check in rc_open().
