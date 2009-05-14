Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4EAmn3a000950
	for <video4linux-list@redhat.com>; Thu, 14 May 2009 06:48:49 -0400
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n4EAmVTj026901
	for <video4linux-list@redhat.com>; Thu, 14 May 2009 06:48:31 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: danflu@uninet.com.br
In-Reply-To: <4a0b743f.16f.ba2.815129916@uninet.com.br>
References: <4a0b743f.16f.ba2.815129916@uninet.com.br>
Content-Type: text/plain
Date: Thu, 14 May 2009 12:42:54 +0200
Message-Id: <1242297774.3829.3.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: saa7134
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

Hi,

Am Mittwoch, den 13.05.2009, 22:30 -0300 schrieb danflu@uninet.com.br:
> Hi,
> 
> I'm Trying to capture from a capture TV card (Zogis Real
> Angel 220 with FM) that has a saa7134 controller but I'm not
> succeding in make it work.
> 
> When I type dmesg the operating system (linux Ubuntu
> 8.04)says that it cannot automatically detect the device,
> and V4L2 lists it as UNKNOWN. The driver listed by
> video4linux is saa7134. The device is identified at
> /dev/video0.
> 
> Please, could you clarify step by step how can I setup linux
> to make this device work ? 
> 

it has support since 2.6.28.

There is no eeprom on it for auto detection and you need to force
card=150.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
