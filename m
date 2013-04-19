Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:47290 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab3DSJmQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 05:42:16 -0400
Received: by mail-ea0-f175.google.com with SMTP id f15so672632eak.34
        for <linux-media@vger.kernel.org>; Fri, 19 Apr 2013 02:42:14 -0700 (PDT)
Message-ID: <51711173.2020909@gmail.com>
Date: Fri, 19 Apr 2013 11:42:11 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: ERRORS
References: <20130418174018.16E0111E014C@alastor.dyndns.org> <201304191036.29749.hverkuil@xs4all.nl>
In-Reply-To: <201304191036.29749.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 19/04/2013 10:36, Hans Verkuil ha scritto:
> Sorry for the ongoing breakage. I expect to have time this weekend to fix it.
> 
> Regards,
> 
> 	Hans
> --


Hi Hans,
this should fix the current media_build breakage.
Tested on Ubuntu 10.04 with kernel 2.6.32.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 backports/v3.1_no_pm_qos.patch | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/backports/v3.1_no_pm_qos.patch b/backports/v3.1_no_pm_qos.patch
index 8dbbd41..63f3ec6 100644
--- a/backports/v3.1_no_pm_qos.patch
+++ b/backports/v3.1_no_pm_qos.patch
@@ -42,9 +42,9 @@ index 0a3feaa..c24b651 100644
  #include <asm/io.h>

 @@ -470,7 +469,6 @@ struct saa7134_fh {
- 	enum v4l2_buf_type         type;
- 	unsigned int               resources;
- 	enum v4l2_priority	   prio;
+	unsigned int               radio;
+	enum v4l2_buf_type         type;
+	unsigned int               resources;
 -	struct pm_qos_request	   qos_request;

  	/* video overlay */
-- 
1.8.2.1

