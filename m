Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9LLg3S028631
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 16:21:42 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9LLT8n007142
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 16:21:29 -0500
Date: Tue, 9 Dec 2008 16:21:27 -0500
From: Jim Paris <jim@jtan.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Message-ID: <20081209212127.GB21038@psychosis.jim.sh>
References: <patchbomb.1228337219@hypnosis.jim>
	<1228378442.1733.17.camel@localhost>
	<20081204130557.85799da0.ospite@studenti.unina.it>
	<patchbomb.1228337219@hypnosis.jim>
	<1228378442.1733.17.camel@localhost>
	<20081204171546.GA27230@psychosis.jim.sh>
	<20081206184200.703fb8e0.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081206184200.703fb8e0.ospite@studenti.unina.it>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 4] ov534 patches
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Antonio Ospite wrote:
> I need to read something more about UVC.

Me too.  This bridge chip supports it -- maybe we just need to tweak
the USB descriptors so that the existing UVC driver knows what to do?

> Ah, and from a quick test on PS3 it looks like the header is not added
> here, but I haven't had the chance to see what exactly happened.

I'm relying on power on defaults, but we can also enable the header
explicitly if that's more reliable.

-jim

--

ov534: explicitly initialize frame format

Set frame format registers 0x0a and 0x0b to explicit values
rather than relying on reset-time defaults

Signed-off-by: Jim Paris <jim@jtan.com>

diff -r bc3e6d69f66b linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Tue Dec 09 16:06:08 2008 -0500
+++ b/linux/drivers/media/video/gspca/ov534.c	Tue Dec 09 16:20:30 2008 -0500
@@ -199,6 +199,10 @@
 	{ 0x1d, 0x02 }, /* frame size 0x025800 * 4 = 614400 */
 	{ 0x1d, 0x58 }, /* frame size */
 	{ 0x1d, 0x00 }, /* frame size */
+
+	{ 0x1c, 0x0a },
+	{ 0x1d, 0x08 }, /* turn on UVC header */
+	{ 0x1d, 0x0e }, /* .. */
 
 	{ 0x8d, 0x1c },
 	{ 0x8e, 0x80 },

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
