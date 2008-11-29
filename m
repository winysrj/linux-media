Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATE6QSt021251
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 09:06:26 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mATE6DGS008205
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 09:06:14 -0500
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: "Trilok Soni" <soni.trilok@gmail.com>
Date: Sat, 29 Nov 2008 15:06:11 +0100
References: <5d5443650811282312w508c0804qf962f6cf5e859e2@mail.gmail.com>
In-Reply-To: <5d5443650811282312w508c0804qf962f6cf5e859e2@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200811291506.11758.tobias.lorenz@gmx.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: FM transmitter support under v4l2?
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

Hi Trilok,

> Anybody working on FM transmitter related drivers support under v4l2?
> If no, what parts of v4l2 which could be tweaked in right order to
> support such devices? I see that SI471x series seem to have FM
> transmitters too.

right, there are several Si47xx series:
Si470x: receivers only
Si471x: transmitter only
Si472x: transceivers
Si473x: fm+am receivers

All are somehow related down to the register set.

I see there two starting points:
1. Get the data sheets of the Si471x devices and compare what options they have more compared to an Si470x receiver.
2. Have a look at what you can configure on your amateur ham radio.

I'm almost sure, that you can use the alsa driver to transport audio to the silabs transmitters too.
But there are obvisuouly some V4L2 interface additions necessary, e.g. ptt, transmit power, modulation, ...

And it would be really helpful to have a working reference device there too. As far as I know, silabs doesn't have one.

Bye,
Toby
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
