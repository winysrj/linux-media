Return-path: <linux-media-owner@vger.kernel.org>
Received: from cust-smtp-lb.metrocast.net ([65.175.128.166]:40763 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753885AbcBVU2z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 15:28:55 -0500
In-Reply-To: <6a4d1872a94ba8450c9aff6599d1e86b515fd2a9.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com><4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com> <6a4d1872a94ba8450c9aff6599d1e86b515fd2a9.1456167652.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 9/9] ivtv-mailbox: avoid confusing smatch
From: Andy Walls <awalls@md.metrocast.net>
Date: Mon, 22 Feb 2016 15:22:57 -0500
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <79AC97AC-35F8-4EF2-8ABB-FA23FC52F1BC@md.metrocast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On February 22, 2016 2:09:23 PM EST, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
>The current logic causes smatch to be confused:
>	include/linux/jiffies.h:359:41: error: strange non-value function or
>array
>	include/linux/jiffies.h:361:42: error: strange non-value function or
>array
>	include/linux/jiffies.h:359:41: error: strange non-value function or
>array
>	include/linux/jiffies.h:361:42: error: strange non-value function or
>array
>
>Use a different logic.
>
>Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>---
> drivers/media/pci/ivtv/ivtv-mailbox.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/media/pci/ivtv/ivtv-mailbox.c
>b/drivers/media/pci/ivtv/ivtv-mailbox.c
>index e3ce96763785..4d6a3ad265a5 100644
>--- a/drivers/media/pci/ivtv/ivtv-mailbox.c
>+++ b/drivers/media/pci/ivtv/ivtv-mailbox.c
>@@ -177,8 +177,10 @@ static int get_mailbox(struct ivtv *itv, struct
>ivtv_mailbox_data *mbdata, int f
> 
> 		/* Sleep before a retry, if not atomic */
> 		if (!(flags & API_NO_WAIT_MB)) {
>-			if (time_after(jiffies,
>-				       then + msecs_to_jiffies(10*retries)))
>+			unsigned int timeout;
>+
>+			timeout = msecs_to_jiffies(10 * retries);
>+			if (time_after(jiffies, then + timeout))
> 			       break;
> 			ivtv_msleep_timeout(10, 0);
> 		}

Hi:

then is an unsigned long.
msecs_to_jiffies() returns an unsigned long.

timeout should be an unsigned long.

Regards,
Andy
