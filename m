Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MFcsIl017073
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 11:38:54 -0400
Received: from web27904.mail.ukl.yahoo.com (web27904.mail.ukl.yahoo.com
	[217.146.182.54])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3MFcc0g011185
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 11:38:38 -0400
Date: Tue, 22 Apr 2008 16:38:32 +0100 (BST)
From: "Edward J. Sheldrake" <ejs1920@yahoo.co.uk>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <564195.23707.qm@web27904.mail.ukl.yahoo.com>
Subject: em28xx/xc3028: changeset 7651 breaks analog audio?
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

Hello

I have a Hauppauge HVR-900 rev B3C0, and until very recently it was
working fine with the em28xx driver in the main v4l-dvb repository. I
live in England, so have set the option pal=i for the tuner module. It
was working fine with with the repository from 20080420. I'm watching
analog TV.

However, with the repository from 20080422, I just get static from the
audio output. None of the audio_std options for the tuner_xc2028 module
made any difference. The only changeset I could see for the modules I
use is 7651, about the firmware for the xc3028 tuner.

Here's relevant dmesg output for the older working driver:
http://pastebin.com/f399535d5

And here's the same with the non-working driver:
http://pastebin.com/fdd8e82e

I extracted the firmware again with the 20080422 repo, but the new
firmware file worked fine with the older driver.

Let me know how I can help fix this, or is there some module option
that I've missed?

--

Edward Sheldrake


      ___________________________________________________________ 
Yahoo! For Good. Give and get cool things for free, reduce waste and help our planet. Plus find hidden Yahoo! treasure 

http://green.yahoo.com/uk/earth-day/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
