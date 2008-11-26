Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAQM0Fnc030735
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 17:00:15 -0500
Received: from mail.ki.iif.hu (mail.ki.iif.hu [193.6.222.241])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAQM02La016347
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 17:00:02 -0500
Date: Wed, 26 Nov 2008 22:59:57 +0100 (CET)
From: "Kiss Gabor (Bitman)" <kissg@ssg.ki.iif.hu>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0811261343m32021a70ia5a1e3541233c2bd@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811262251210.10867@bakacsin.ki.iif.hu>
References: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
	<alpine.DEB.1.10.0811172119370.855@bakacsin.ki.iif.hu>
	<412bdbff0811171254s5e732ce4p839168f22d3a387@mail.gmail.com>
	<alpine.DEB.1.10.0811192133380.32523@bakacsin.ki.iif.hu>
	<412bdbff0811191305y320d6620vfe28c0577709ea66@mail.gmail.com>
	<alpine.DEB.1.10.0811262054050.10867@bakacsin.ki.iif.hu>
	<412bdbff0811261226l478e3d4eg2f0551239e56540a@mail.gmail.com>
	<alpine.DEB.1.10.0811262158020.10867@bakacsin.ki.iif.hu>
	<412bdbff0811261343m32021a70ia5a1e3541233c2bd@mail.gmail.com>
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

> No need to apologize.  The parser.pl just makes everything *much* easier.

I'm just ashamed because I did not research a bit before
I offer you some 5 GB of garbage. :-)

> Do you know which chips this device contains?  If not, could you

No.

> please open the unit and send me some high-resolution photographs of
> the circuit board?

At this moment I have no idea at all how to open the box without
serious damages.
Is this necessary? Could you check the July thread about the same
device?
https://www.redhat.com/mailman/private/video4linux-list/2008-July/msg00388.html
https://www.redhat.com/mailman/private/video4linux-list/2008-July/msg00399.html

Maybe kernel messages can help something:

Nov 16 11:55:21 pvr kernel: [20768.836569] em28xx #0: found i2c device @ 0x4a [saa7113h]
Nov 16 11:55:21 pvr kernel: [20768.842344] em28xx #0: found i2c device @ 0x60 [remote IR sensor]
Nov 16 11:55:21 pvr kernel: [20768.853068] em28xx #0: found i2c device @ 0x86 [tda9887]
Nov 16 11:55:21 pvr kernel: [20768.870318] em28xx #0: found i2c device @ 0xc6 [tuner (analog)]

Regards

Gabor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
