Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n690xw6A025410
	for <video4linux-list@redhat.com>; Wed, 8 Jul 2009 20:59:58 -0400
Received: from m13-93.163.com (m13-93.163.com [220.181.13.93])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n690xeak020629
	for <video4linux-list@redhat.com>; Wed, 8 Jul 2009 20:59:41 -0400
Date: Thu, 9 Jul 2009 08:59:39 +0800 (CST)
From: =?gbk?B?wO7OsA==?= <54216deren@163.com>
To: video4linux-list <video4linux-list@redhat.com>
Message-ID: <27409228.37591247101179127.JavaMail.coremail@bj163app93.163.com>
In-Reply-To: <20090708160016.0386E61A25D@hormel.redhat.com>
References: <20090708160016.0386E61A25D@hormel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: quoted-printable
Subject: Re_ how to make qbuf.eml
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

Hello Lamarque Vieira Souza:
I have read your answer about how to make qbuf .
I am doing a VPU ( video process unit )test on imx27(Freescale company).=20
The test include v4l2 part which will communicate with tv out  board and tv=
 in board.=20
But there will be some information printed like below:

VIDIOC_QBUF - overflow

VIDIOC_QBUF - overflow

VIDIOC_QBUF - overflow

mxc_v4l_dqueue - overflow

mxc_v4l_dqueue =A8C overflow                   =20

mxc_v4l_dqueue - overflow

Would you please give me some advices about how to deal with the problems .
Best regards .
liwee=20




=D4=DA2009-07-09=A3=ACvideo4linux-list-request@redhat.com =D0=B4=B5=C0=A3=
=BA
>Send video4linux-list mailing list submissions to
>=09video4linux-list@redhat.com
>
>To subscribe or unsubscribe via the World Wide Web, visit
>=09https://www.redhat.com/mailman/listinfo/video4linux-list
>or, via email, send a message with subject or body 'help' to
>=09video4linux-list-request@redhat.com
>
>You can reach the person managing the list at
>=09video4linux-list-owner@redhat.com
>
>When replying, please edit your Subject line so it is more specific
>than "Re: Contents of video4linux-list digest..."
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
