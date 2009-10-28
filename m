Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9SAIFcT012801
	for <video4linux-list@redhat.com>; Wed, 28 Oct 2009 06:18:15 -0400
Received: from smtpin2.mailsecure.in (SMTPIN2.mailsecure.in [121.241.224.3])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n9SAI4Ak028724
	for <video4linux-list@redhat.com>; Wed, 28 Oct 2009 06:18:05 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Wed, 28 Oct 2009 15:47:58 +0530
Message-ID: <9D5E1752379A43408015F7FE9846611504EDD06A@CHNEXVS01.VSNLXCHANGE.COM>
From: "Anantha Krishnan H" <ananthakrishnan@tataelxsi.co.in>
To: <video4linux-list@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: what is /dev/video0 entry?
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

Hi all
    When kernel boots up the Video4Linux driver is registered as a characte=
r driver with major number 81.If i plug-in my UVC compliant webcam, the UVC=
 driver creates an entry in /dev/video0.Now i want to write an application =
for testing my webcam.I came to know that for writing an application for co=
mmunicating with the webcam we can use the V4L2 APIs provided by the linux =
kernel.Are these V4L2 APIs from the video4linux driver?Also could anyone ki=
ndly tell me what is the /dev/video0 entry?Is this entry used for communica=
ting with the video device?

Thanks & Regards
Ananth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
