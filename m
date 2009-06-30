Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta11.westchester.pa.mail.comcast.net ([76.96.59.211]:60018
	"EHLO QMTA11.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670AbZF3XId (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 19:08:33 -0400
From: George Czerw <gczerw@comcast.net>
Reply-To: gczerw@comcast.net
To: Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] Hauppauge HVR-1800 not working at all
Date: Tue, 30 Jun 2009 19:02:34 -0400
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <200906301301.04604.gczerw@comcast.net> <200906301749.05168.gczerw@comcast.net> <4A4A88C3.9020608@linuxtv.org>
In-Reply-To: <4A4A88C3.9020608@linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906301902.35171.gczerw@comcast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 30 June 2009 17:50:59 Michael Krufky wrote:
> George Czerw wrote:
> > On Tuesday 30 June 2009 15:56:08 Devin Heitmueller wrote:
> >> On Tue, Jun 30, 2009 at 3:48 PM, George Czerw<gczerw@comcast.net> wrote:
> >>> Devin, thanks for the reply.
> >>>
> >>> Lsmod showed that "tuner" was NOT loaded (wonder why?), a "modprobe
> >>> tuner" took care of that and now the HVR-1800 is displaying video
> >>> perfectly and the tuning function works.  I guess that I'll have to add
> >>> "tuner" into modprobe.preload.d????  Now if only I can get the sound
> >>> functioning along with the video!
> >>>
> >>> George
> >>
> >> Admittedly, I don't know why you would have to load the tuner module
> >> manually on the HVR-1800.  I haven't had to do this on other products?
> >>
> >> If you are doing raw video capture, then you need to manually tell
> >> applications where to find the ALSA device that provides the audio.
> >> If you're capturing via the MPEG encoder, then the audio will be
> >> embedded in the stream.
> >>
> >> Devin
> >
> > I don't understand why the audio/mpeg ports of the HVR-1800 don't show up
> > in output of lspci:
> >
> > 03:00.0 Multimedia video controller: Conexant Systems, Inc. Device 8880
> > (rev 0f)
> >         Subsystem: Hauppauge computer works Inc. Device 7801
> >         Flags: bus master, fast devsel, latency 0, IRQ 17
> >         Memory at f9c00000 (64-bit, non-prefetchable) [size=2M]
> >         Capabilities: [40] Express Endpoint, MSI 00
> >         Capabilities: [80] Power Management version 2
> >         Capabilities: [90] Vital Product Data
> >         Capabilities: [a0] MSI: Mask- 64bit+ Count=1/1 Enable-
> >         Capabilities: [100] Advanced Error Reporting
> >         Capabilities: [200] Virtual Channel <?>
> >         Kernel driver in use: cx23885
> >         Kernel modules: cx23885
> >
> >
> > even though the dmesg output clearly shows this:
> >
> > tveeprom 0-0050: decoder processor is CX23887 (idx 37)
> > tveeprom 0-0050: audio processor is CX23887 (idx 42)
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Please try this:
>
> When you have tvtime open and running with video working already, do:
>
> mplayer /dev/video1
>
> (assuming that tvtime is open on video0)
>
> Then, you'll get mplayer complete with both audio and video.
>
> -Mike

See below:

mplayer /dev/video1
MPlayer SVN-1.rc2.23.r28791.2mdv2009.1-4.3.2 (C) 2000-2009 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.


That totally destroyed my signal on tvtime.  Had to reboot to recover.

