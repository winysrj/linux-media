Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m283iORd003509
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 22:44:24 -0500
Received: from web56413.mail.re3.yahoo.com (web56413.mail.re3.yahoo.com
	[216.252.111.92])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m283hpYj028362
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 22:43:51 -0500
Date: Fri, 7 Mar 2008 19:43:45 -0800 (PST)
From: r bartlett <techwritebos@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <865752.65449.qm@web56413.mail.re3.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: WinTV-HVR-1800 help...
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

Silly as it sounds, I'm a television noobie here and have been wading around for months trying to get my WinTV-HVR-1800 card to just play television.  I don't need any of the PVR stuff or recording, and I only have Basic (analog) cable...I'm hoping to match the functionality I have in Windo$e so that I don't have to reboot every time I want to see a show.

Any and all help would be greatly appreciated.  Part of the trouble has been I'm unfamiliar with the various television terms (ATSC, for example, until recently) so I kind of need a walk through of what steps I need to take to get my system working.

I'm running 2.6.24.3 kernel, Fedora Core 8 distro, in a KDE environment.  I have a /dev/dvb/adapter0/* device but no /dev/video0.  I have gotten the updated firmware from http://steventoth.net/linux/hvr1800/ and put it into /lib/firmware...

And still no dice.  Xawtv chokes, giving me this message:

This is xawtv-3.95, running on Linux/i686 (2.6.24.3-12.fc8)
X Error of failed request:  XF86DGANoDirectVideoMode
  Major opcode of failed request:  136 (XFree86-DGA)
  Minor opcode of failed request:  1 (XF86DGAGetVideoLL)
  Serial number of failed request:  68
  Current serial number in output stream:  68

If I try scantv, in hopes of getting a channel file, I get:
scantv
ioctl: VIDIOC_G_STD(std=0x8058688bf91f308 [PAL_H,PAL_M,PAL_N,NTSC_M,NTSC_M_JP,?,?,SECAM_B,SECAM_K,?ATSC_8_VSB,ATSC_16_VSB,(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)]): Invalid argument

please select your TV norm
nr ?   

And no matter what I write in the "nr?" section (0, 1, PAL_M, NTSC_M...) it just keeps giving me that error.

So I'm kind of stumped.  Am I still having a firmware problem?  Am I missing a step necessary before running "scantv"?

I'm terribly sorry for the noobie aspects of all this, but any clear, precise help would be greatly appreciated, particularly from someone who has gotten the analog part working.  I'm pretty sure the digital side is not going to happen without subscribing to digital channels.  I'd just like to open a window every so often and watch plain old analog tv.

:-)

Many thanks....                     

       
---------------------------------
Never miss a thing.   Make Yahoo your homepage.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
