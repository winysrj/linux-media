Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6AHuquO018001
	for <video4linux-list@redhat.com>; Fri, 10 Jul 2009 13:56:52 -0400
Received: from mail-yx0-f202.google.com (mail-yx0-f202.google.com
	[209.85.210.202])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n6AHuYgL007971
	for <video4linux-list@redhat.com>; Fri, 10 Jul 2009 13:56:35 -0400
Received: by yxe40 with SMTP id 40so512151yxe.23
	for <video4linux-list@redhat.com>; Fri, 10 Jul 2009 10:56:34 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: video4linux-list@redhat.com
Date: Fri, 10 Jul 2009 14:56:26 -0300
References: <20090708160016.0386E61A25D@hormel.redhat.com>
	<27409228.37591247101179127.JavaMail.coremail@bj163app93.163.com>
In-Reply-To: <27409228.37591247101179127.JavaMail.coremail@bj163app93.163.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gbk"
Content-Disposition: inline
Message-Id: <200907101456.26876.lamarque@gmail.com>
Content-Transfer-Encoding: 8bit
Cc: =?gbk?q?=C0=EE=CE=B0?= <54216deren@163.com>
Subject: Re: Re_ how to make qbuf.eml
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

	Hi, I am not a v4l2 expert. I think you better ask about this problem to the 
driver's maintainer. Which driver this board uses? The kernel module 
maintainers are listed in <kernel source>/MAINTAINERS file, you need to know 
which driver your board uses and look inside this file for the maintainer e-
mail address. Another option is send e-mail to the video4linux official 
mailing list: linux-media@vger.kernel.org.

Em Wednesday 08 July 2009, ÀîÎ° escreveu:
> Hello Lamarque Vieira Souza:
> I have read your answer about how to make qbuf .
> I am doing a VPU ( video process unit )test on imx27(Freescale company).
> The test include v4l2 part which will communicate with tv out  board and tv
> in board. But there will be some information printed like below:
>
> VIDIOC_QBUF - overflow
>
> VIDIOC_QBUF - overflow
>
> VIDIOC_QBUF - overflow
>
> mxc_v4l_dqueue - overflow
>
> mxc_v4l_dqueue ¨C overflow
>
> mxc_v4l_dqueue - overflow
>
> Would you please give me some advices about how to deal with the problems .
> Best regards .
> liwee
>
>
>
>
> ÔÚ2009-07-09£¬video4linux-list-request@redhat.com Ð´µÀ£º
>
> >Send video4linux-list mailing list submissions to
> >	video4linux-list@redhat.com
> >
> >To subscribe or unsubscribe via the World Wide Web, visit
> >	https://www.redhat.com/mailman/listinfo/video4linux-list
> >or, via email, send a message with subject or body 'help' to
> >	video4linux-list-request@redhat.com
> >
> >You can reach the person managing the list at
> >	video4linux-list-owner@redhat.com
> >
> >When replying, please edit your Subject line so it is more specific
> >than "Re: Contents of video4linux-list digest..."
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
