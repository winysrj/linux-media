Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n51K306c025223
	for <video4linux-list@redhat.com>; Mon, 1 Jun 2009 16:03:00 -0400
Received: from swip.net (mailfe15.tele2.se [212.247.155.193])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n51K2gCi014965
	for <video4linux-list@redhat.com>; Mon, 1 Jun 2009 16:02:43 -0400
Received: from smtp.alstadheim.priv.no (account mc432237@c2i.net
	[193.216.78.228] verified)
	by mailfe15.swip.net (CommuniGate Pro SMTP 5.2.13)
	with ESMTPA id 504773985 for video4linux-list@redhat.com;
	Mon, 01 Jun 2009 22:02:42 +0200
Received: from [192.168.2.22] (unknown [192.168.2.22])
	(Authenticated sender: hakon)
	by smtp.alstadheim.priv.no (Postfix) with ESMTPSA id 96A3051BB
	for <video4linux-list@redhat.com>;
	Mon,  1 Jun 2009 22:02:41 +0200 (CEST)
Message-ID: <4A2433E2.4050807@alstadheim.priv.no>
Date: Mon, 01 Jun 2009 22:02:42 +0200
From: =?ISO-8859-1?Q?H=E5kon_Alstadheim?= <hakon@alstadheim.priv.no>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <745af8a00906011105x7a69b478obbab7c738aaa9e06@mail.gmail.com>
In-Reply-To: <745af8a00906011105x7a69b478obbab7c738aaa9e06@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: saa7134 surveillance
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

S P wrote:
> Hi!
> I have a surveillance card with saa7134 chips. It should be able to
> see 8 cameras at a time, but there is only 4 video devices in /dev of
> this card.
> These devices are working fine, each device's channel 0(there isn't
> any other channel of these devices) is an input for a camera.
> So, how could I manage it to be 8 devices?
>
>   
Kernel-version ? Newer kernels allow you to set v4l subsystem to 
"allocate minor device numbers dynamically". This is supposed to allow 
more than 4 devices on a single card, according to the help-text of the 
2.6.29 kernel I just compiled.

Caveat: All this is from memory, ~24hours old.

-- 
Håkon Alstadheim
47 35 39 38



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
