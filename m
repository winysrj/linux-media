Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8I0HlWa002556
	for <video4linux-list@redhat.com>; Wed, 17 Sep 2008 20:17:47 -0400
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8I0HWRO014580
	for <video4linux-list@redhat.com>; Wed, 17 Sep 2008 20:17:33 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: danflu@uninet.com.br
In-Reply-To: <48d00727.2fe.4e96.811320937@uninet.com.br>
References: <48d00727.2fe.4e96.811320937@uninet.com.br>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 02:13:51 +0200
Message-Id: <1221696831.4557.54.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: saa7134 controller
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

Hi Daniel,

Am Dienstag, den 16.09.2008, 16:21 -0300 schrieb danflu@uninet.com.br:
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
> Another thing... what is the best application available
> today to watch tv on linux ???
> 

looks like you can't get old dogs away from the oven with such questions
that soon.

Start as usual, it is exercised close to two hundred times now, with the
hidden cards included.

Reload the drivers with i2c_scan=1 (modinfo saa7134), identify the tuner
and the audio clock and follow the instructions on the v4l wiki at
linuxtv.org about adding a new card, if it even is one.

You can find lots of patterns like a card can be configured here
http://linuxtv.org/hg/v4l-dvb/log/e5ca4534b543/linux/drivers/media/video/saa7134/saa7134.h

and all sort of questions since 2002 on the lists/archives.

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
