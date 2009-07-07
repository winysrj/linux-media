Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n67DHHx8025515
	for <video4linux-list@redhat.com>; Tue, 7 Jul 2009 09:17:17 -0400
Received: from insvr08.insite.com.br (insvr08.insite.com.br [66.135.42.188])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n67DH16n013929
	for <video4linux-list@redhat.com>; Tue, 7 Jul 2009 09:17:01 -0400
From: Rafael Diniz <diniz@wimobilis.com.br>
To: video4linux-list@redhat.com
Date: Tue, 7 Jul 2009 10:23:13 -0300
References: <3a9b62b20907062344p56d1ecafsbbb936c74eadfd43@mail.gmail.com>
In-Reply-To: <3a9b62b20907062344p56d1ecafsbbb936c74eadfd43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200907071023.13820.diniz@wimobilis.com.br>
Content-Transfer-Encoding: 8bit
Cc: 
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

Hi 서정민,
mplayer already have a v4l2 driver, right?

bye,
rafael diniz

Em Terça-feira 07 Julho 2009, às 03:44:41, 서정민 escreveu:
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


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
