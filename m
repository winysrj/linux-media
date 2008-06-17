Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5H9XcQM024914
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 05:33:38 -0400
Received: from smtp2.pixelworks.com (smtp2.pixelworks.com [207.179.28.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5H9XQiw013014
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 05:33:27 -0400
From: Xuesong Yang <xsyang@pixelworks.com>
To: Veda N <veda74@gmail.com>
In-Reply-To: <a5eaedfa0806170205r12eed4edl30e2653a918e4cad@mail.gmail.com>
References: <a5eaedfa0806170205r12eed4edl30e2653a918e4cad@mail.gmail.com>
Date: Tue, 17 Jun 2008 17:33:19 +0800
Message-Id: <1213695199.6020.3.camel@star-sea>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: video4linux-list@redhat.com
Subject: Re: v4l2_pix_format doubts
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

=E5=9C=A8 2008-06-17=E4=BA=8C=E7=9A=84 14:35 +0530=EF=BC=8CVeda N=E5=86=99=
=E9=81=93=EF=BC=9A

> The v4l2_pix_format has the following variables to fill
>   a) bytesperline
>   b) width
>   c) height
>   4) pixelformat

Just a guess
a  640x12x3/8
b 640
c 480
4 this should be one of the enum type

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
