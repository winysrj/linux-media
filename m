Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MLcGrI026800
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 17:38:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3MLc0QN011952
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 17:38:00 -0400
Date: Tue, 22 Apr 2008 18:37:40 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Edward J. Sheldrake" <ejs1920@yahoo.co.uk>
Message-ID: <20080422183740.5aac8772@gaivota>
In-Reply-To: <542613.5449.qm@web27912.mail.ukl.yahoo.com>
References: <20080422132139.1e8e5f4a@gaivota>
	<542613.5449.qm@web27912.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/==AAp+=n.soE5vSnXoKYrYj"
Cc: video4linux-list@redhat.com
Subject: Re: em28xx/xc3028: changeset 7651 breaks analog audio?
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

--MP_/==AAp+=n.soE5vSnXoKYrYj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Edward,

> I updated to changeset 7673 and reversed 7651, and got a fully working
> driver. These are the firmware loading messages from the working
> driver:
> 
> (insert stick)
> xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type:
> xc2028 firmware, ver 2.7
> xc2028 1-0061: Loading firmware for type=BASE MTS (5), id
> 0000000000000000.
> xc2028 1-0061: Loading firmware for type=MTS (4), id 000000000000b700.
> 
> (start mplayer - missing from first pastebin)
> xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id
> 0000000000000000.
> xc2028 1-0061: Loading firmware for type=MTS (4), id 0000000000000010.


I'm enclosing two hacks. please, re-apply 7651, and try first hack1.patch.
Then, revert it and apply hack2.patch.

Please tell me if both hacks work or not, and send me the dmesgs for each case
(after loading mplayer).


Cheers,
Mauro

--MP_/==AAp+=n.soE5vSnXoKYrYj
Content-Type: text/x-patch; name=hack1.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=hack1.patch

diff -r dd15a1f1040e linux/drivers/media/video/tuner-xc2028.c
--- a/linux/drivers/media/video/tuner-xc2028.c	Tue Apr 22 12:38:26 2008 -0300
+++ b/linux/drivers/media/video/tuner-xc2028.c	Tue Apr 22 18:34:04 2008 -0300
@@ -616,6 +616,8 @@
 	unsigned char	   *p;
 
 	tuner_dbg("%s called\n", __func__);
+
+	int_freq = 6000;
 
 	if (!int_freq) {
 		pos = seek_firmware(fe, type, id);

--MP_/==AAp+=n.soE5vSnXoKYrYj
Content-Type: text/x-patch; name=hack2.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=hack2.patch

diff -r dd15a1f1040e linux/drivers/media/video/tuner-xc2028-types.h
--- a/linux/drivers/media/video/tuner-xc2028-types.h	Tue Apr 22 12:38:26 2008 -0300
+++ b/linux/drivers/media/video/tuner-xc2028-types.h	Tue Apr 22 18:34:55 2008 -0300
@@ -99,7 +99,7 @@
 			 LG60|ATI638|OREN538|OREN36|TOYOTA388|TOYOTA794|     \
 			 DIBCOM52|ZARLINK456|CHINA|F6MHZ|SCODE)
 #else
-#define SCODE_TYPES SCODE
+#define SCODE_TYPES (SCODE | MTS)
 #endif
 
 

--MP_/==AAp+=n.soE5vSnXoKYrYj
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/==AAp+=n.soE5vSnXoKYrYj--
