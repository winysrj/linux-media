Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46083 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3IQQlz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Sep 2013 12:41:55 -0400
Received: by mail-wi0-f175.google.com with SMTP id ez12so5232862wid.8
        for <linux-media@vger.kernel.org>; Tue, 17 Sep 2013 09:41:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1373709848.211147.1379435118175.open-xchange@email.1and1.fr>
References: <1152216514.26450.1378910904534.open-xchange@email.1and1.fr>
	<CALzAhNVvz4zoBDAPw609_c+NuPc8JXFj+HqgKWzonEO9oAOMig@mail.gmail.com>
	<1373709848.211147.1379435118175.open-xchange@email.1and1.fr>
Date: Tue, 17 Sep 2013 12:41:53 -0400
Message-ID: <CALzAhNW_NTXhX_+8A+3OhhueUUB7PbXyqDhwR=U0F6M+zX=Akw@mail.gmail.com>
Subject: Re: avermedia A306 / PCIe-minicard (laptop) / CX23885
From: Steven Toth <stoth@kernellabs.com>
To: remi <remi@remis.cc>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hello :)
>
> Thnx for the reply !

You are welcome.

> Well, I do not have the cables ... it's a laptop card, orginally for a Dell,
>
> I am doing my tests on an Acer,

So you don't have a valid signal to test your changes with?

> The Video0 dev , composite/s-video is showing an analog signal, i guess a
> "noise" picture because not hooked-up,

Hmm. Possibly, or possible the video decoder and video patch is not configured.

>
> but bottom half is sometimes green .

So you haven't seen ANY stable video from any analog input?

> Analog scanning/reception = NULL , I might have to check again the antenna
> connexion,

OK.

> For the Mpeg, negative, it's a 9013 chip, I still have to discecte the 9015
> driver and pull-out
>
> the 9013 spcific data , iguess .

OK. No mpeg either.

So you don't have anything working so far, that's my reading of your
current state.

> What I need the most, Is a big picture of the V4L API , like an organigram of
> what is where ( initialising this or that,

linuxtv.org

>
> handeling setups - and controls)

V4L2 Specification at linuxtv.org

> I there a dummy /test driver for PCIe cards I can study ?

CX23885 is a good place to start. It's fully functional and matches
the hardware you have to experiment with.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
