Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GCoiFC016397
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 08:50:44 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2GCo9Uw026494
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 08:50:10 -0400
Received: by fk-out-0910.google.com with SMTP id b27so5665770fka.3
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 05:50:09 -0700 (PDT)
From: "Frej Drejhammar" <frej.drejhammar@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <patchbomb.1205671781@liva.fdsoft.se>
Date: Sun, 16 Mar 2008 13:49:41 +0100
To: video4linux-list@redhat.com
Cc: Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH 0 of 2] cx88: Enable additional cx2388x features. Version 2
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

The cx2388x family of broadcast decoders all have features not enabled
by the standard cx88 driver. This revised patch series adds controls
allowing the chroma AGC and the color killer to be enabled (Version 1
of the series used module parameters). By default both features are
disabled as in previous versions of the driver.

The Chroma AGC and the color killer is sometimes needed when using
signal sources of less than optimal quality.

The patches applies cleanly to 7370:11fdae6654e8 of
http://linuxtv.org/hg/v4l-dvb/ and have been tested an a HVR-1300. The
patches should be applied in order.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
