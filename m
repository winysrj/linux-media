Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f198.google.com ([209.85.221.198]:61727 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZGSEKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 00:10:55 -0400
Received: by qyk36 with SMTP id 36so296400qyk.33
        for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 21:10:54 -0700 (PDT)
From: Brian Johnson <brijohn@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/2] gspca sn9c20x subdriver rev3
Date: Sun, 19 Jul 2009 00:10:50 -0400
Message-Id: <1247976652-17031-1-git-send-email-brijohn@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok this one just has the following minor changes:

* operations set/get_register in the sd descriptor only exist if CONFIG_VIDEO_ADV_DEBUG is defined
* use lowercase letters in hexidecimal notation
* add new supported webcams to linux/Documentation/video4linux/gspca.txt
* check for NULL after kmalloc when creating jpg_hdr

Brian Johnson

