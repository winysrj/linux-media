Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m28I9cCA015726
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 13:09:38 -0500
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m28I91Kh032578
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 13:09:01 -0500
Received: by fk-out-0910.google.com with SMTP id b27so1059119fka.3
	for <video4linux-list@redhat.com>; Sat, 08 Mar 2008 10:09:00 -0800 (PST)
From: "Frej Drejhammar" <frej.drejhammar@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <patchbomb.1204999521@liva.fdsoft.se>
Date: Sat, 08 Mar 2008 19:05:21 +0100
To: video4linux-list@redhat.com
Subject: [PATCH 0 of 2] cx88: Enable additional cx2388x features
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
by the standard cx88 driver. This patch series adds module parameters
allowing the chroma AGC and the color killer to be enabled. By default
both features are disabled as in previous versions of the driver.

The Chroma AGC and the color killer is sometimes needed when using
signal sources of less than optimal quality.

The patches applies cleanly to 7330:ad0b1f882ad9 of
http://linuxtv.org/hg/v4l-dvb/. The patches should be applied in
order.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
