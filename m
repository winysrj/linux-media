Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6AJxN2I031893
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 15:59:23 -0400
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6AJwq5J008299
	for <video4linux-list@redhat.com>; Thu, 10 Jul 2008 15:58:58 -0400
Message-ID: <48766A75.7060903@free.fr>
Date: Thu, 10 Jul 2008 22:00:53 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Rainer Koenig <Rainer.Koenig@gmx.de>
References: <200807101924.58802.Rainer.Koenig@gmx.de>
In-Reply-To: <200807101924.58802.Rainer.Koenig@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Flipping the video from webcams
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

Hello Rainer,
Rainer Koenig a écrit :
> Hello,
>
> I've got a notebook with an integrated webcam and I got a driver (r5u870) that 
> works fine with it, except that the camera images I get are all upside down. 
> It seems that due to a desgin flaw the camera was assembled upside down and 
> there is no easy way to turn it. So I need to rotate the picture with 
> software, which practically means "flip X" and "flip Y". I even found some 
> bits in the driver that look like they address this issue, but turning them 
> to "1" (instead of 0) doesn't help at all. 
>
> So I wonder: Is there a way to flip the picture that is coming from the camera 
> by setting some options somewhere so that my IM client gets the picture in 
> the right orientation?
>
> TIA
> Rainer
>   
You may put the laptop upside down :)
Seriously, Andreas Demmer reported success on image flipping using
vloopback+camsource.
I think on his blog you will find the information:
http://www.andreas-demmer.de/weblog/beitrag229/
but I don't understand German sadly...

Cheers,
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
