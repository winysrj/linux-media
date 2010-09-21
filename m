Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60065 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab0IUTFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 15:05:54 -0400
Received: by fxm3 with SMTP id 3so1684086fxm.19
        for <linux-media@vger.kernel.org>; Tue, 21 Sep 2010 12:05:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikWL10Tjb1BnmESGKvq1edZJXoe60pEdJUzMsLx@mail.gmail.com>
References: <AANLkTi=TjOKMRQk1spGFVnt1ycu48eZudiWh-hc0a8vp@mail.gmail.com> <AANLkTikWL10Tjb1BnmESGKvq1edZJXoe60pEdJUzMsLx@mail.gmail.com>
From: Daniel Moraes <daniel.b.moraes@gmail.com>
Date: Tue, 21 Sep 2010 16:05:33 -0300
Message-ID: <AANLkTimRw9=K5D51iejuVv2Duphu0tqCt8_nH2X2eOyL@mail.gmail.com>
Subject: Webcam Driver Bug while using two Multilaser Cameras simultaneously
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I'm using Ubuntu 10.04 and I need to get images from two Multilaser
Cameras simultaneously. First I tried to do that using OpenCV, but I
got an error. So, I entered the OpenCV Mailing List to report that and
I discovered that's a driver problem. To ensure that, I used mplayer
to get imagens from the both cameras and I got the following error
(again):

> v4l2: ioctl streamon failed: No space left on device

The cameras model is Multilaser WC0440.

This problem only happens when I try to capture images from two
IDENTICAL cameras simultaneously. I have three cameras here, two
Multilaser Cameras and one HP Camera, from my laptop. I have no
problem to capture images from my HP Camera and one of the Multilaser
Cameras simultaneously, but when I try to capture from the both
Multilaser Cameras simultaneously, i got that error.

I think that the problem may be something related to the generic
driver. When I use the Multilaser Cameras, they use the same driver.
That's not happen with the HP Camera, which uses another driver.
Someone knows a solution for that?

Att,
 Daniel Bastos Moraes
 Graduando em Ciência da Computação - Universidade Tiradentes
 +55 79 88455531
