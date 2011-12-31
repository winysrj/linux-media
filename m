Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1LaTKo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 14:10:44 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBVJAitC022940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 14:10:44 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] fs/compat_ioctl: it needs to see the DVBv3 compat stuff
Date: Sat, 31 Dec 2011 17:09:05 -0200
Message-Id: <1325358545-15039-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only the ioctl core should see the DVBv3 compat stuff, as its
contents are not available anymore to the drivers.

As fs/compat_ioctl also handles DVBv3 ioctl's, it needs those
definitions:

    fs/compat_ioctl.c:1345: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1345: error: array type has incomplete element type
    fs/compat_ioctl.c:1345: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1345: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1345: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1345: error: array type has incomplete element type
    fs/compat_ioctl.c:1345: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1345: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1345: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1345: error: array type has incomplete element type
    fs/compat_ioctl.c:1345: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1345: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1345: error: initializer element is not constant
    fs/compat_ioctl.c:1345: error: (near initialization for ‘ioctl_pointer[462]’)
    fs/compat_ioctl.c:1346: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1346: error: array type has incomplete element type
    fs/compat_ioctl.c:1346: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1346: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1346: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1346: error: array type has incomplete element type
    fs/compat_ioctl.c:1346: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1346: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1346: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1346: error: array type has incomplete element type
    fs/compat_ioctl.c:1346: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1346: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
    fs/compat_ioctl.c:1346: error: initializer element is not constant
    fs/compat_ioctl.c:1346: error: (near initialization for ‘ioctl_pointer[463]’)
    fs/compat_ioctl.c:1347: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
    fs/compat_ioctl.c:1347: error: array type has incomplete element type
    fs/compat_ioctl.c:1347: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
    fs/compat_ioctl.c:1347: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
    fs/compat_ioctl.c:1347: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
    fs/compat_ioctl.c:1347: error: array type has incomplete element type
    fs/compat_ioctl.c:1347: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
    fs/compat_ioctl.c:1347: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
    fs/compat_ioctl.c:1347: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
    fs/compat_ioctl.c:1347: error: array type has incomplete element type
    fs/compat_ioctl.c:1347: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
    fs/compat_ioctl.c:1347: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
    fs/compat_ioctl.c:1347: error: initializer element is not constant
    fs/compat_ioctl.c:1347: error: (near initialization for ‘ioctl_pointer[464]’)

Reported-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 fs/compat_ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 51352de..32200c2 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -105,6 +105,7 @@
 
 #include <linux/hiddev.h>
 
+#define __DVB_CORE__
 #include <linux/dvb/audio.h>
 #include <linux/dvb/dmx.h>
 #include <linux/dvb/frontend.h>
-- 
1.7.8.352.g876a6

