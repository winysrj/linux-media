Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72BwaS6016936
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 07:58:36 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m72BwNRh018127
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 07:58:24 -0400
Received: by nf-out-0910.google.com with SMTP id d3so543014nfc.21
	for <video4linux-list@redhat.com>; Sat, 02 Aug 2008 04:58:23 -0700 (PDT)
To: video4linux-list@redhat.com
Date: Sat, 2 Aug 2008 14:57:42 +0300
References: <200709302032.22508.linux@janfrey.de>
	<Pine.LNX.4.58.0710291147230.16052@shell4.speakeasy.net>
	<472B5A16.2080707@foks.8m.com>
In-Reply-To: <472B5A16.2080707@foks.8m.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808021457.42478.igor@liplianin.net>
From: "Igor M. Liplianin" <liplianin@me.by>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org
Subject: [PATCH] Add to .hgignore v4l/oss and v4l/modules.order
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

It really annoys me always delete v4l/oss and
v4l/modules.order before 'hg addremove'. So I propose
patch to avoid that.
May be it will be useful.
-----------------------------------------
Add to .hgignore v4l/oss and v4l/modules.order

From: Igor M. Liplianin <liplianin@me.by>

Add to .hgignore v4l/oss and v4l/modules.order

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

--- a/.hgignore	Sat Aug 02 13:49:06 2008 +0300
+++ b/.hgignore	Sat Aug 02 14:04:44 2008 +0300
@@ -20,8 +20,10 @@
 v4l/.kconfig.dep$
 v4l/Makefile.media$
 v4l/ivtv
+v4l/oss
 v4l/Modules.symvers$
 v4l/Module.symvers$
+v4l/modules.order$
 v4l/config-compat.h$
 v4l/.myconfig$
 v4l/.snapshot$

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
