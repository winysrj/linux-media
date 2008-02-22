Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1MJwFqs010406
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 14:58:15 -0500
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1MJvibq012519
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 14:57:44 -0500
From: Peter Missel <peter.missel@onlinehome.de>
To: hermann pitton <hermann-pitton@arcor.de>, video4linux-list@redhat.com
Date: Fri, 22 Feb 2008 20:57:35 +0100
References: <200802202341.32370.werner.braun@gmx.de>
	<1203634149.8866.14.camel@pc08.localdom.local>
In-Reply-To: <1203634149.8866.14.camel@pc08.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802222057.35863.peter.missel@onlinehome.de>
Cc: 
Subject: Re: [linux-dvb] auto detection of Flytv duo/hybrid and pci/cardbus
	confusion
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

Hi guys!

>
> Werner, yes it was your device coming back in mind.
>
> We know now about the new A/D version V1.1, saw only a fuzzy picture so
> far, but looks like a KS003 something for the remote and not that PIC on
> the prior, different addresses, IIRC.
>

If you ask me, that V1.1 card doesn't look anything like any LifeView design 
I've seen so far. It wouldn't be the first time MSI sell a totally different 
card than before under the same product name, as "just a newer revision".

The use of MSI's own PCI vendor ID 1462h in the subsystem ID also hints that 
it isn't a LifeView card as we know them, since they have never ever used an 
OEM's specific ID. It's always been 4E42h ever since the subsystem ID was 
invented.

Just my two cents.

regards,
Peter

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
