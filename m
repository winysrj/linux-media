Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0CIp4XL032199
	for <video4linux-list@redhat.com>; Mon, 12 Jan 2009 13:51:04 -0500
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0CIoiFZ015270
	for <video4linux-list@redhat.com>; Mon, 12 Jan 2009 13:50:45 -0500
Message-ID: <496B90FD.7000005@free.fr>
Date: Mon, 12 Jan 2009 19:50:37 +0100
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcsOhcyBMxZFyaW5jeg==?= <andras.lorincz@gmail.com>
References: <a21d779b0901120550j35dfbdc2l402be4664d89e4da@mail.gmail.com>
In-Reply-To: <a21d779b0901120550j35dfbdc2l402be4664d89e4da@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, DVB list <linux-dvb@linuxtv.org>
Subject: Re: Hauppauge HVR 900H with ID 2040:6600
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

András Lőrincz wrote:
> Hello,
> 
> I've just bought the device mentioned in the title with the hope that
> it will work under linux but just found out that actually there are
> different variations of it :(. As I saw it on linuxtv.org it is not
> supported. Is there any hope that this device will ever work under
> linux? Thanks.
There was some work done on http://linuxtv.org/hg/~mchehab/tm6010/ , but 
the code is far from being complete.

I also tried to trace what the windows driver is doing (the zl10353 fe 
attach fails for me), but I didn't manage to make work usbsnoop [1]...


Matthieu


[1] it works fine with mass storage, but not with the HVR...

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
