Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1PCTwNZ005973
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 07:29:58 -0500
Received: from smtp-vbr8.xs4all.nl (smtp-vbr8.xs4all.nl [194.109.24.28])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1PCTgm5006209
	for <video4linux-list@redhat.com>; Wed, 25 Feb 2009 07:29:43 -0500
Message-ID: <44559.62.70.2.252.1235564981.squirrel@webmail.xs4all.nl>
Date: Wed, 25 Feb 2009 13:29:41 +0100 (CET)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Jorge Abrines" <curruscataphractus@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: cx25850
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


> Hi all,
>
> I have a board with a conexant chip model cx25850 and I want to know if
> anyone knows if it's supported by v4l. Googling I've seen there's some
> code (cx25850.c) but want to confirm it!. If so, where can I find which
> kernel
> module supports this chip. I do have worked with Bt878 ones.

Hi Jorge,

No, it is not supported. Although I think that it might not be difficult
provided the datasheets can be obtained since I suspect that it is just a
cx2584x chip multiplied by however many channels are implemented. And a
driver for the cx2584x does exist.

Regards,

        Hans

>
>
> Thanks in advance.
>
> Best regards,
>
> Jorge
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
