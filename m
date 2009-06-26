Return-path: <linux-media-owner@vger.kernel.org>
Received: from col0-omc3-s15.col0.hotmail.com ([65.55.34.153]:7510 "EHLO
	col0-omc3-s15.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304AbZFZDEP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 23:04:15 -0400
Message-ID: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
From: George Adams <g_adams27@hotmail.com>
To: <video4linux-list@redhat.com>, <linux-media@vger.kernel.org>
Subject: Bah!  How do I change channels?
Date: Thu, 25 Jun 2009 23:04:18 -0400
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Having gotten my Pinnacle HDTV Pro Stick working again under some old v4l drivers, I'm now facing a much more mundane problem - I can't figure out how to use the command line to change the channel.

The video feed (a closed-circuit feed) that's coming to the card is over a coax cable, and is on (analog) channel 3.  My goal is to take the input and use Helix Encoder to produce RealVideo output that can be played using Real Player (yeah, not the ideal situation, but it's what we're using for now)

Helix Producer (unlike "mencoder/mplayer") doesn't have the ability to change the channel - it can only take whatever is coming over the channel that the Pinnacle device is currently tuned to.  Devin pointed me to the "v4lctl" command, but I'm not having any luck with it yet.  

The following does NOT work (i.e. Helix Producer produces a feed of just static)

> v4lctl setchannel 3
> v4lctl setfreqtab us-bcast; v4lctl setnorm NTSC; v4lctl setchannel 3
(I tried all combinations with "us-cable" and "us-cable-hrc" for the frequency tables, and "NTSC-M" for the norm), but nothing worked.

But scantv seems to indicate that the channel is there:

> scantv -n NTSC -f us-bcast -a -c /dev/video0 -C /dev/null
scanning freqencies...
??  44.00 MHz (-   ): |   no
??  44.25 MHz (-   ): |   no
??  44.50 MHz (-   ): |   no
...
??  59.00 MHz (-   ): |   no
??  59.25 MHz (-   ): |   no
??  59.50 MHz (-   ): |   no
??  59.75 MHz (-   ):  \  raise
??  60.00 MHz (-   ):   | yes
??  60.25 MHz (-   ):   | yes
??  60.50 MHz (-   ):   | yes
??  60.75 MHz (-   ):   | yes
??  61.00 MHz (-   ):   | yes
??  61.25 MHz (3   ):   | yes
??  61.50 MHz (-   ):   | yes
??  61.75 MHz (-   ):   | yes
??  62.00 MHz (-   ):   | yes
??  62.25 MHz (-   ):  /  fall
=>  61.25 MHz (3   ): ???
[unknown (61.25)]
channel = 3

??  62.50 MHz (-   ): |   no
??  62.75 MHz (-   ): |   no
??  63.00 MHz (-   ): |   no
??  63.25 MHz (-   ): |   no

So, there it is.  Is there something wrong with my v4lctl command, then?  

Interestingly, after running tvtime-scanner, I note this in my ~/.tvtime/stationlist.xml file:
  
    
  

It has also spotted channel 3, but this time at 61.50Mhz, rather than 61.25Mhz (which is where I thought it ought to be).

So here is what WORKS:
- run tvtime, tune to channel 3, quit the program and start Helix Producer.  It will "see" the correct channel and show a nice clear picture.
- or, run an mplayer command like the following.  When it quits 5 seconds later, start Helix Producer.  Again, Helix will show the picture from channel 3:

>  mplayer -vo xv tv:// -tv driver=v4l2:alsa:immediatemode=0:adevice=hw.1,0:norm=ntsc:chanlist=us-cable:channel=3 -endpos 5


So, my horrible hack to get this working is to run the "mplayer" command before I start Helix Producer.  But surely there must be a better way!  Can I make v4lctl do the right thing?  Or is there another command-line tool that I can use?

Thanks again.



_________________________________________________________________
Windows Live™ SkyDrive™: Get 25 GB of free online storage.
http://windowslive.com/online/skydrive?ocid=TXT_TAGLM_WL_SD_25GB_062009