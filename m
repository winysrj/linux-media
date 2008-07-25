Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6PHldQA018639
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 13:47:39 -0400
Received: from n25.bullet.mail.ukl.yahoo.com (n25.bullet.mail.ukl.yahoo.com
	[87.248.110.142])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6PHlIQv006529
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 13:47:18 -0400
Date: Fri, 25 Jul 2008 17:47:12 +0000 (GMT)
From: Malsoaz James <jmalsoaz@yahoo.fr>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <464567.3890.qm@web28409.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Change the frameperiod
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

Hello,=0A=0AI have some problems to change the framerate of my device. Mayb=
e I don't use the right function. Can someone have a look ?=0A=0Astruct v4l=
2_standard st;=0Astruct v4l2_fract fram;=0Astruct v4l2_captureparm ca;=0A=
=0Afram.numerator=3D1000;=0Afram.denominator=3D30000;=0Aca.timeperframe=3Df=
ram;=0Aif (-1 =3D=3D xioctl (fd, VIDIOC_S_PARM, &ca))=0A        errno_exit =
("VIDIOC_S_PARM");=0A=0A//-------------------   =0A//Here I got this error =
: "VIDIOC_S_PARM error 22, Invalid argument", but I don't know why=0A//----=
---------=0A=0A=0A//This is to have the current frameperiod, and that works=
, I got 60 fps.=0A//----------=0Aif (-1 =3D=3D xioctl (fd, VIDIOC_ENUMSTD, =
&st))=0A         errno_exit ("VIDIOC_ENUM_FMT");=0Afram=3Dst.frameperiod;=
=0Aframerate=3Dfram.denominator/fram.numerator;=0Aprintf("framerate =3D %d =
fps\n",framerate);=0A=0A=0AThanks a lot for your help.=0AJames=0A=0A=0A=0A =
     ______________________________________________________________________=
_______ =0AEnvoyez avec Yahoo! Mail. Une boite mail plus intelligente http:=
//mail.yahoo.fr
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
