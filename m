Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJKdHHj018898
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 15:39:17 -0500
Received: from mail.ki.iif.hu (mail.ki.iif.hu [193.6.222.241])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJKd3rV025006
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 15:39:04 -0500
Date: Wed, 19 Nov 2008 21:38:58 +0100 (CET)
From: "Kiss Gabor (Bitman)" <kissg@ssg.ki.iif.hu>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0811171254s5e732ce4p839168f22d3a387@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811192133380.32523@bakacsin.ki.iif.hu>
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

Unfortunately I cannot do this.
I have no Windows machine.

Some month ago we tried to install Windows drivers on my brother's
XP but we were unsuccesful.


Yesterday I tried to load em28xx module with different card numbers
and two or three times I had nice picture. With card=3 and card=7.
However after a few tests it seems to be crashed and since then it
does not work any more.

Gabor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
