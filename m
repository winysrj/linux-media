Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FKxMOE008043
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 15:59:22 -0500
Received: from head.horn.dyndns.biz ([93.81.0.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1FKx0I9017017
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 15:59:00 -0500
From: Eugene <roginovicci@nm.ru>
To: video4linux-list@redhat.com
Date: Fri, 15 Feb 2008 23:21:03 +0300
References: <aedf12640802151146i1c02547ct7cc1671285fb95cf@mail.gmail.com>
In-Reply-To: <aedf12640802151146i1c02547ct7cc1671285fb95cf@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802152321.03196.roginovicci@nm.ru>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: Encore ENLTV-FM (TV tuner Pro)
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

Hola Alexandro!
On Friday 15 February 2008 22:46:49 Alexandro Silva wrote:
>. The only remaining problem is that
> audio out is up even after close de screen, until I shutdown my machine and
> when I start pc the tv sound gets up again during de boot process.
>
> I attached too the dmesg080215-ful.txt file with entire dmesg out and
> dmesg080215.txt file with just saa grep.
As far as I know SAA7130 based cards have no sound through pci functionality. 
Thus I came into conclusion that there is a wipe connecting the tuner and 
audio card. I think you should adjust the sound card through alsamixer and 
alsactl ( with "store" option) to turnoff line input by default.

Cheers.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
