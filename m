Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3573 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1HYN30 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 09:29:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: dvb_frontend.c warning: can 'timeout' be removed?
Date: Thu, 25 Aug 2011 15:29:18 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108251529.18402.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the warning the daily build gives:

v4l-dvb-git/drivers/media/dvb/dvb-core/dvb_frontend.c: In function 'dvb_frontend_thread':
v4l-dvb-git/drivers/media/dvb/dvb-core/dvb_frontend.c:540:16: warning: variable 'timeout' set but not used [-Wunused-but-set-variable]

The 'timeout' variable is indeed not used, but should it? I'm not familiar enough
with this code to decide.

Regards,

	Hans
