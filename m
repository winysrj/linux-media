Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:48916 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab0CXN1F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 09:27:05 -0400
Received: by fxm23 with SMTP id 23so23434fxm.1
        for <linux-media@vger.kernel.org>; Wed, 24 Mar 2010 06:27:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <499b283a1003231547k1e7f8060x53a4ea5ec43236d4@mail.gmail.com>
References: <499b283a1003231342h6fcbe74di2aa67eb91b18cf0c@mail.gmail.com>
	 <4BA91A44.4090709@oracle.com>
	 <499b283a1003231547k1e7f8060x53a4ea5ec43236d4@mail.gmail.com>
Date: Wed, 24 Mar 2010 10:27:03 -0300
Message-ID: <499b283a1003240627p4e97bd73v594f031e3f7b5726@mail.gmail.com>
Subject: Re: [PATCH] Fix Warning ISO C90 forbids mixed declarations and code -
	cx88-dvb
From: Ricardo Maraschini <xrmarsx@gmail.com>
To: linux-media@vger.kernel.org
Cc: doug <dougsland@gmail.com>, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ricardo Maraschini <ricardo.maraschini@gmail.com>

--- a/linux/drivers/media/video/cx88/cx88-dvb.c Tue Mar 23 17:52:23 2010 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c Wed Mar 24 09:57:06 2010 -0300
@@ -1401,8 +1401,6 @@
        case CX88_BOARD_SAMSUNG_SMT_7020:
                dev->ts_gen_cntrl = 0x08;

-               struct cx88_core *core = dev->core;
-
                cx_set(MO_GP0_IO, 0x0101);

                cx_clear(MO_GP0_IO, 0x01);
