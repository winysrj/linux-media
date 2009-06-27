Return-path: <linux-media-owner@vger.kernel.org>
Received: from col0-omc4-s6.col0.hotmail.com ([65.55.34.208]:42656 "EHLO
	col0-omc4-s6.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbZF0EZ2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jun 2009 00:25:28 -0400
Message-ID: <COL103-W513258452EA45C7700193888320@phx.gbl>
From: George Adams <g_adams27@hotmail.com>
To: <dheitmueller@kernellabs.com>, <awalls@radix.net>
CC: <video4linux-list@redhat.com>, <linux-media@vger.kernel.org>
Subject: RE: Bah! How do I change channels?
Date: Sat, 27 Jun 2009 00:25:31 -0400
In-Reply-To: <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Thanks again to both of you for your help.  I gave the no_poweroff flag a try, but didn't see any difference.  I also tried a "setchannel 3" during the middle of the encoding session, and also saw no change.
 
But I think I've found the problem:
 
> v4lctl setnorm NTSC; v4lctl setfreqtab us-bcast; v4lctl -v 1 setchannel 3
vid-open: trying: v4l2-old... 
vid-open: failed: v4l2-old
vid-open: trying: v4l2... 
v4l2: open
v4l2: device info:
  em28xx 0.1.1 / Pinnacle PCTV HD Pro Stick @ usb-0000:00:1a.7-1
vid-open: ok: v4l2
freq: reading /usr/share/xawtv/Index.map
v4l2:   tuner cap:
v4l2:   tuner rxs:
v4l2:   tuner cur: MONO
cmd: "setchannel" "3"
v4l2: freq: 0.000
v4l2: close
 
 
What?  freq: 0.000 ?  After finding the ivtv package and compiling its utils, I confirm it with this:
 
> v4l2-ctl -F
Frequency: 0 (0.000000 MHz)
 
> ivtv-tune -c 3
/dev/video0: 61.250 MHz
 
> v4l2-ctl -F              
Frequency: 980 (61.250000 MHz)
 
> v4lctl setchannel 3

> v4l2-ctl -F      
Frequency: 0 (0.000000 MHz)
 
 
So mysteriously, it seems like v4lctl is just plain not working.  And ivtv-tune, on the other hand, is working just fine.  After I do that and start Helix Producer, I see channel 3 just like I had hoped.
 
(strangely, v4lctl can do other things fine, like change the norm from NTSC to PAL.  It just can't change the channel.)
 
So, sorry that it went off in rabbit trails of the device powering down and so forth.  I wonder what happened to my v4lctl program, though?  xawtv itself (running in X) seems to work fine when I tell it to change the channel...
 

 
 
 

> Date: Fri, 26 Jun 2009 09:42:06 -0400
> Subject: Re: Bah! How do I change channels?
> From: dheitmueller@kernellabs.com
> To: awalls@radix.net
> CC: g_adams27@hotmail.com; video4linux-list@redhat.com; linux-media@vger.kernel.org
> 
> On Fri, Jun 26, 2009 at 7:50 AM, Andy Walls wrote:
>> I use either v4l2-ctl or ivtv-tune
>>
>> $ ivtv-tune -d /dev/video0 -t us-bcast -c 3
>> /dev/video0: 61.250 MHz
>>
>> $ v4l2-ctl -d /dev/video0 -f 61.250
>> Frequency set to 980 (61.250000 MHz)
>>
>>
>> Regards,
>> Andy
> 
> Hello Andy,
> 
> I had sent George some email off-list with basically the same
> commands. I think what might be happening here is the tuner gets
> powered down when not in use, so I think it might be powered down
> between the v4l-ctl command and the running of the other application.
> 
> I have sent him a series of commands to try where he modprobes the
> xc3028 driver with "no_poweroff=1", and we will see if that starts
> working.
> 
> Devin
> 
> -- 
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
_________________________________________________________________
Lauren found her dream laptop. Find the PC that’s right for you.
http://www.microsoft.com/windows/choosepc/?ocid=ftp_val_wl_290