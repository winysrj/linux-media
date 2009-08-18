Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7I4kcAf009856
	for <video4linux-list@redhat.com>; Tue, 18 Aug 2009 00:46:38 -0400
Received: from n7-vm0.bullet.mail.in.yahoo.com
	(n7-vm0.bullet.mail.in.yahoo.com [202.86.4.134])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n7I4kHut004959
	for <video4linux-list@redhat.com>; Tue, 18 Aug 2009 00:46:18 -0400
Message-ID: <590901.79740.qm@web94909.mail.in2.yahoo.com>
Date: Mon, 17 Aug 2009 21:46:16 -0700 (PDT)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: fake radio device
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

Hi,=0AI searched through the lists for some examples of fm radio tuners whi=
ch are v4l complaint and found that most had i2c sort of interface.=0A=0Aho=
wever what if the fm tuner i have is based on uart ? and the uart is also u=
sed by some other "radio/wireless connectivity" core on the chip ?=0A=0Amea=
ning - somehow on user-space I happen to have concurrent access to uart [th=
rough bsd like sockets, for example] however, i don't have the same via ker=
nel space.=0A=0Aso how's valid is the idea to create a fake radio device /d=
ev/radio and pass all ioctl's from kernel space to user-space to convert to=
 valid command over my bsd sockets ?=0AAny suggestions ? or road-blocks i w=
ould run into.=0A=0Aregards,=0APavan=0A=0A=0A=0A      Looking for local inf=
ormation? Find it on Yahoo! Local http://in.local.yahoo.com/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
