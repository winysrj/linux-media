Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:12630 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155AbZGQUvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 16:51:46 -0400
Received: by rv-out-0506.google.com with SMTP id f6so271778rvb.1
        for <linux-media@vger.kernel.org>; Fri, 17 Jul 2009 13:51:46 -0700 (PDT)
From: Brian Johnson <brijohn@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 0/2] gspca sn9c20x subdriver rev2
Date: Fri, 17 Jul 2009 16:51:41 -0400
Message-Id: <1247863903-22125-1-git-send-email-brijohn@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
Here is the updated version of the gspca sn9c20x subdriver.

I've removed the custom debugging support and replaced it with support
for the v4l2 debugging ioctls. The first patch in this set adds support
to the gspca core for those ioctls. Also included are the fixes Hans
sent in his last email.

Regards,
Brian Johnson

