Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m65DO3tW018528
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 09:24:03 -0400
Received: from mrqout2.tiscali.it (mrqout2a.tiscali.it [195.130.225.14])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m65DNmPX012159
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 09:23:48 -0400
Received: from ps10 (10.39.75.80) by mail-10.mail.tiscali.sys (8.0.016)
	id 481EDCCE0013CF55 for video4linux-list@redhat.com;
	Sat, 5 Jul 2008 15:23:42 +0200
Message-ID: <25500277.1215264222465.JavaMail.root@ps10>
Date: Sat, 5 Jul 2008 15:23:42 +0200 (CEST)
From: "audetto@tiscali.it" <audetto@tiscali.it>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_77767_1972019.1215264222464"
Subject: [PATCH] pwc: do not block in VIDIOC_DQBUF
Reply-To: "audetto@tiscali.it" <audetto@tiscali.it>
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

------=_Part_77767_1972019.1215264222464
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I think the ioctl VIDIOC_DQBUF in pwc does not follow the API spec.
It should not block if there are no buffers and the device has been=20
opened with O_NONBLOCK.

I am not sure the patch is 100% correct, since I do not understand it=20
completely.

Andrea



_________________________________________________________________
Tiscali Family: Adsl e Telefono senza limiti e senza scatto alla risposta. =
PER TE CON LO SCONTO DEL 25% FINO AL 2010. In pi=C3=B9 il software parental=
 control Magic Desktop Basic =C3=A8 GRATIS! Attiva entro il 03/07/08. http:=
//abbonati.tiscali.it/promo/tuttoincluso/=20

------=_Part_77767_1972019.1215264222464
Content-Type: application/octet-stream; name=pwc.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=pwc.diff; size=622

diff -r 87aa6048e718 linux/drivers/media/video/pwc/pwc-v4l.c
--- a/linux/drivers/media/video/pwc/pwc-v4l.c	Wed Jul 02 08:59:38 2008 -0300
+++ b/linux/drivers/media/video/pwc/pwc-v4l.c	Sat Jul 05 14:14:03 2008 +0100
@@ -1134,6 +1134,13 @@
 				     frameq is safe now.
 			 */
 			add_wait_queue(&pdev->frameq, &wait);
+
+			if ((pdev->full_frames == NULL) && (file->f_flags & O_NONBLOCK)) {
+				remove_wait_queue(&pdev->frameq, &wait);
+				set_current_state(TASK_RUNNING);
+				return -EAGAIN;
+			}
+
 			while (pdev->full_frames == NULL) {
 				if (pdev->error_status) {
 					remove_wait_queue(&pdev->frameq, &wait);

------=_Part_77767_1972019.1215264222464
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_77767_1972019.1215264222464--
