Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n692rmtD011971
	for <video4linux-list@redhat.com>; Wed, 8 Jul 2009 22:53:48 -0400
Received: from mail-pz0-f172.google.com (mail-pz0-f172.google.com
	[209.85.222.172])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n692rWCr010622
	for <video4linux-list@redhat.com>; Wed, 8 Jul 2009 22:53:32 -0400
Received: by pzk2 with SMTP id 2so316116pzk.23
	for <video4linux-list@redhat.com>; Wed, 08 Jul 2009 19:53:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3a9b62b20907062344p56d1ecafsbbb936c74eadfd43@mail.gmail.com>
References: <3a9b62b20907062344p56d1ecafsbbb936c74eadfd43@mail.gmail.com>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Thu, 9 Jul 2009 11:53:12 +0900
Message-ID: <5e9665e10907081953ya02df86mc0a47b72feb3898f@mail.gmail.com>
To: =?UTF-8?B?7ISc7KCV66+8?= <sirseo@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: how to make qbuf
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

Hello,

I suppose you can have more comments if you post on the current v4l2 list.
I mean, linux-media@vger.kernel.org
And also you can find latest v4l2 works at linuxtv.org the leading
community of v4l2.
I think I can help you if you give me more specific question about
what makes you confused.
Cheers,

On Tue, Jul 7, 2009 at 3:44 PM, 서정민<sirseo@gmail.com> wrote:
> Hi.
>
> I'm making V4l2 device driver for mplayer.
> But
> It's too difficult to understand V4l2 driver internal structure.
>
> I can't understand how to use VIDIOC_QBUF, VIDIOC_DQBUF ioctl and 'struct
> videobuf_queue'
>
> Why does v4l2 driver need to use 'videobuf_queue'?
>
> Please. tell me v4l2 driver internal operation.
>
> Thanks.
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
