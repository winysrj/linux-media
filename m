Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALJKrmI010407
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 14:20:53 -0500
Received: from mail.ki.iif.hu (mail.ki.iif.hu [193.6.222.241])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALJKb3L020443
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 14:20:38 -0500
Date: Fri, 21 Nov 2008 20:20:31 +0100 (CET)
From: "Kiss Gabor (Bitman)" <kissg@ssg.ki.iif.hu>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0811171254s5e732ce4p839168f22d3a387@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811212015070.29615@bakacsin.ki.iif.hu>
References: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
	<alpine.DEB.1.10.0811172119370.855@bakacsin.ki.iif.hu>
	<412bdbff0811171254s5e732ce4p839168f22d3a387@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: [video4linux] Attention em28xx users
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

Dear Devin,

> The action item for the thread you referenced was for the user to
> capture a USB trace on a Windows system so we can compare the register
> operations.  If you want to pick up where the original user left off,
> please use SniffUSB to get a capture after plugging in the device and
> starting a capture session.
> 
> http://www.pcausa.com/Utilities/UsbSnoop/default.htm
> 
> If you can provide a USB capture, I can fix the code so this device
> starts working.

Uhm.... every time I tried to snoop USB traffic windows machine
got frozen or slowed veeeeeeeeeeery down.
So I could not run TV software bundled with device.
A very short (182 kB) capture about device connection is here:

http://bakacsin.ki.iif.hu/~kissg/tmp/connect-UsbSnoop.log.txt

A question:
Where should I download latest em28xx driver from?
http://linuxtv.org/hg/ or http://mcentral.de/hg/ ?

Regards

Gabor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
