Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2746 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaGQNsr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 09:48:47 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6HDmiRZ046329
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 15:48:46 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4CC942A1FD1
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 15:48:43 +0200 (CEST)
Message-ID: <53C7D43B.20905@xs4all.nl>
Date: Thu, 17 Jul 2014 15:48:43 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] v4l2-ctrls: fix compiler warning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed a compiler warning in v4l_print_query_ext_ctrl() due to the change from
dims[8] to dims[4].

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index c38a620..96bc117 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -531,13 +531,12 @@ static void v4l_print_query_ext_ctrl(const void *arg, bool write_only)
 
 	pr_cont("id=0x%x, type=%d, name=%.*s, min/max=%lld/%lld, "
 		"step=%lld, default=%lld, flags=0x%08x, elem_size=%u, elems=%u, "
-		"nr_of_dims=%u, dims=%u,%u,%u,%u,%u,%u,%u,%u\n",
+		"nr_of_dims=%u, dims=%u,%u,%u,%u\n",
 			p->id, p->type, (int)sizeof(p->name), p->name,
 			p->minimum, p->maximum,
 			p->step, p->default_value, p->flags,
 			p->elem_size, p->elems, p->nr_of_dims,
-			p->dims[0], p->dims[1], p->dims[2], p->dims[3],
-			p->dims[4], p->dims[5], p->dims[6], p->dims[7]);
+			p->dims[0], p->dims[1], p->dims[2], p->dims[3]);
 }
 
 static void v4l_print_querymenu(const void *arg, bool write_only)
