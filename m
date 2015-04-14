Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbbDNOsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2015 10:48:03 -0400
From: David Howells <dhowells@redhat.com>
To: mchehab@osg.samsung.com
cc: dhowells@redhat.com, linux-media@vger.kernel.org
Subject: [PATCH] libdvbv5: Retry FE_GET_PROPERTY ioctl if it returns EAGAIN
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10102.1429022877.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Apr 2015 15:47:57 +0100
Message-ID: <10103.1429022877@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Retry the FE_GET_PROPERTY ioctl used to determine if we have a DVBv5 device
if it returns EAGAIN indicating the driver is currently locked by the kernel.

Also skip over subsequent information gathering calls to FE_GET_PROPERTY
that return EAGAIN.

Original-author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 dvb-fe.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 04ad907..3657334 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -171,9 +171,12 @@ struct dvb_v5_fe_parms *dvb_fe_open_flags(int adapter, int frontend,
 	dtv_prop.props = parms->dvb_prop;
 
 	/* Detect a DVBv3 device */
-	if (ioctl(fd, FE_GET_PROPERTY, &dtv_prop) == -1) {
+	while (ioctl(fd, FE_GET_PROPERTY, &dtv_prop) == -1) {
+		if (errno == EAGAIN)
+			continue;
 		parms->dvb_prop[0].u.data = 0x300;
 		parms->dvb_prop[1].u.data = SYS_UNDEFINED;
+		break;
 	}
 	parms->p.version = parms->dvb_prop[0].u.data;
 	parms->p.current_sys = parms->dvb_prop[1].u.data;
@@ -1336,8 +1339,11 @@ int dvb_fe_get_stats(struct dvb_v5_fe_parms *p)
 		props.props = parms->stats.prop;
 
 		/* Do a DVBv5.10 stats call */
-		if (ioctl(parms->fd, FE_GET_PROPERTY, &props) == -1)
+		if (ioctl(parms->fd, FE_GET_PROPERTY, &props) == -1) {
+			if (errno == EAGAIN)
+				return 0;
 			goto dvbv3_fallback;
+		}
 
 		/*
 		 * All props with len=0 mean that this device doesn't have any
