Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:4788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195Ab0IUTsa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 15:48:30 -0400
Message-ID: <4C990C08.9050504@redhat.com>
Date: Tue, 21 Sep 2010 16:48:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Daniel Moraes <daniel.b.moraes@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Webcam Driver Bug while using two Multilaser Cameras simultaneously
References: <AANLkTi=TjOKMRQk1spGFVnt1ycu48eZudiWh-hc0a8vp@mail.gmail.com> <AANLkTikWL10Tjb1BnmESGKvq1edZJXoe60pEdJUzMsLx@mail.gmail.com> <AANLkTimRw9=K5D51iejuVv2Duphu0tqCt8_nH2X2eOyL@mail.gmail.com>
In-Reply-To: <AANLkTimRw9=K5D51iejuVv2Duphu0tqCt8_nH2X2eOyL@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Daniel,

Em 21-09-2010 16:05, Daniel Moraes escreveu:
> I'm using Ubuntu 10.04 and I need to get images from two Multilaser
> Cameras simultaneously. First I tried to do that using OpenCV, but I
> got an error. So, I entered the OpenCV Mailing List to report that and
> I discovered that's a driver problem. To ensure that, I used mplayer
> to get imagens from the both cameras and I got the following error
> (again):
> 
>> v4l2: ioctl streamon failed: No space left on device

This is not a driver issue, but a limit imposed by USB specs. This
error code is returned by USB core when you try to use more than 100% of
the available bandwidth for an USB isoc stream.

The amount of bandwidth basically depends on what type of compression
is provided by your webcams.

You'll need to plug the other webcam on a separate USB bus.
> 
> The cameras model is Multilaser WC0440.
> 
> This problem only happens when I try to capture images from two
> IDENTICAL cameras simultaneously. I have three cameras here, two
> Multilaser Cameras and one HP Camera, from my laptop. I have no
> problem to capture images from my HP Camera and one of the Multilaser
> Cameras simultaneously, but when I try to capture from the both
> Multilaser Cameras simultaneously, i got that error.
> 
> I think that the problem may be something related to the generic
> driver. When I use the Multilaser Cameras, they use the same driver.
> That's not happen with the HP Camera, which uses another driver.

Probably, the HP Camera is connected internally into a different USB bus,
or provide a more compressed stream.

> Someone knows a solution for that?
> 
> Att,
>  Daniel Bastos Moraes
>  Graduando em Ciência da Computação - Universidade Tiradentes
>  +55 79 88455531
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

