Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBBKDxbh028612
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 15:13:59 -0500
Received: from mail.ki.iif.hu (mail.ki.iif.hu [193.6.222.241])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mBBKDRVO021339
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 15:13:27 -0500
Date: Thu, 11 Dec 2008 21:11:22 +0100 (CET)
From: "Kiss Gabor (Bitman)" <kissg@ssg.ki.iif.hu>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0812111159t79fd8647w6f883496350b8585@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812112100190.26420@bakacsin.ki.iif.hu>
References: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
	<alpine.DEB.1.10.0811192133380.32523@bakacsin.ki.iif.hu>
	<412bdbff0811191305y320d6620vfe28c0577709ea66@mail.gmail.com>
	<alpine.DEB.1.10.0811262054050.10867@bakacsin.ki.iif.hu>
	<412bdbff0811261226l478e3d4eg2f0551239e56540a@mail.gmail.com>
	<alpine.DEB.1.10.0811262158020.10867@bakacsin.ki.iif.hu>
	<412bdbff0811261343m32021a70ia5a1e3541233c2bd@mail.gmail.com>
	<alpine.DEB.1.10.0811271936080.6927@bakacsin.ki.iif.hu>
	<412bdbff0812110832h1ab889b7jc30f6e84993456c4@mail.gmail.com>
	<alpine.DEB.1.10.0812112053560.26420@bakacsin.ki.iif.hu>
	<412bdbff0812111159t79fd8647w6f883496350b8585@mail.gmail.com>
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

> Please, do not make any channel switches.  Just start the USB capture,
> plug in the device, tune to a single channel, wait two seconds, and
> stop USB capture.

Eeeerrrr... it's too late.
I cannot go back to my brother till next week to make further measurements.
However captures made so far are almost like you need.
Except that there was no antenna cable attached.

> The problem I'm having right now is that is appears you kept switching
> channels and putting multiple connects/disconnects in the same
> capture.

I can't understand. This was the first occasion the tuner was tuned
and I could see any picture. No channel switchings can be recorded.

Meanwhile ... today logs are here:
http://bakacsin.ki.iif.hu/~kissg/tmp/UsbSnoop-1.log.gz
http://bakacsin.ki.iif.hu/~kissg/tmp/UsbSnoop-2.log.gz
http://bakacsin.ki.iif.hu/~kissg/tmp/UsbSnoop-3.log.gz
http://bakacsin.ki.iif.hu/~kissg/tmp/UsbSnoop-4.log.gz

Gabor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
