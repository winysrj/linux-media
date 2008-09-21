Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vanessaezekowitz@gmail.com>) id 1KhHwj-0000Tz-2Q
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 07:57:27 +0200
Received: by yw-out-2324.google.com with SMTP id 3so156692ywj.41
	for <linux-dvb@linuxtv.org>; Sat, 20 Sep 2008 22:57:20 -0700 (PDT)
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: "linux-dvb" <linux-dvb@linuxtv.org>
Date: Sun, 21 Sep 2008 00:57:31 -0500
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809210057.31591.vanessaezekowitz@gmail.com>
Cc: Curt Blank <Curt.Blank@curtronics.com>
Subject: [linux-dvb] Kworld PlusTV HD PCI 120 (ATSC 120)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi all.  I've been trying to help someone solve a problem with getting their 
ATSC 120 working, and realized their message went to the wrong list, so I'm 
forwarding that thread here to try to get more eyes on the problem.

Here's his initial message:

----- Text Import Begin -----
Kworld PlusTV HD PCI 120 (ATSC 120)
From: Curt Blank <Curt.Blank@curtronics.com>
To: video4linux-list@redhat.com
Date: Thu Sep 18 23:48:14 2008

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
ASSERT: "_init" 
in /usr/src/packages/BUILD/kdetv-0.8.9/kdetv/kvideoio/qvideostream.cpp (477)
(repeated many times)
Too many errors. Ending V4L2 grabbing.

The MB is a MSI K9N4 SLI with an AMD 64 X2 3800+ cpu and the video card is an 
ATI x1300 and I've tried it with the fglrx driver and with the vesa driver, it 
makes no difference.

I've read the Wiki at http://www.linuxtv.org including the 
http://www.linuxtv.org/wiki/index.php/KWorld_ATSC_120 info. I also downloaded 
the archived list messages back to January 2007 and looked through them for 
help.

I'm not sure where to go from here or where to look what to try or even what 
info to provide that might be of help. So if anyone has any ideas please let 
me know, I sure could use some ideas.

Thanks.
----- Text Import End -----

-- 
"Life is full of positive and negative events.  Spend
your time considering the former, not the latter."
Vanessa Ezekowitz <vanessaezekowitz@gmail.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
