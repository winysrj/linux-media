Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8J4mVAf004324
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 00:48:31 -0400
Received: from www.curtronics.com
	(h69-129-7-18.nwblwi.dedicated.static.tds.net [69.129.7.18])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8J4mIP3001137
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 00:48:18 -0400
Received: from [192.168.10.120] (winprtsrv.curtronics.com [192.168.10.120])
	by www.curtronics.com (8.14.1/8.14.1/SuSE Linux 0.8) with ESMTP id
	m8J4mFiQ023068
	for <video4linux-list@redhat.com>; Thu, 18 Sep 2008 23:48:17 -0500
Message-ID: <48D32F0E.1000903@curtronics.com>
Date: Thu, 18 Sep 2008 23:48:14 -0500
From: Curt Blank <Curt.Blank@curtronics.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Kworld PlusTV HD PCI 120 (ATSC 120)
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

I'm trying to get this  card working  and I'm having some trouble and 
I'm not sure exactly where. I'm using the 2.6.26.5 kernel gen'd to 
include all the v4l support.

Using Kradio I can manually tune in a station  but the audio only comes 
out the Line Out jack on the card. Alsa is installed and working, I can 
play CD's, listen to streaming music, KDE sound effects work, so it 
appears my sound subsystem is working. The alsa config in Kradio is set 
to what it determined and it appears to match the device as far as 
things go. When I try to scan for stations it doesn't find any but I can 
tune to any local station and get it.

I also can't get the video (HDTV) to work either. When it starts up I get a:

Unable to grab video

Video display is not possible with the current plugin
configuration. Try playing with the configuration options of the
V4L2 plugin.

And the VBI decoder is running is red, along with the Video plugin 
supports signal strength readbacks and Ok to Scan.

When I run kdetv in a terminal window I see this:

Requesting 16 streaming i/o buffers
Mapping 16 streaming i/o buffers
Successful opened /dev/vbi (Kworld PlusTV HD PCI 120 (ATSC )
stream-read: ERROR: failed to enable streaming
ASSERT: "_init" in /usr/src/packages/BUILD/kdetv-0.8.9/kdetv/kvideoio/qvideostream.cpp (477)
(repeated many times)
Too many errors. Ending V4L2 grabbing.

The MB is a MSI K9N4 SLI with an AMD 64 X2 3800+ cpu and the video card is an ATI x1300 and I've tried it with the fglrx driver and with the vesa driver, it makes no difference.

I've read the Wiki at http://www.linuxtv.org including the http://www.linuxtv.org/wiki/index.php/KWorld_ATSC_120 info. I also downloaded the archived list messages back to January 2007 and looked through them for help.

I'm not sure where to go from here or where to look what to try or even what info to provide that might be of help. So if anyone has any ideas please let me know, I sure could use some ideas.

Thanks.



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
