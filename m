Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:45682
	"EHLO QMTA10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635AbZF3VtE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 17:49:04 -0400
From: George Czerw <gczerw@comcast.net>
Reply-To: gczerw@comcast.net
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [linux-dvb] Hauppauge HVR-1800 not working at all
Date: Tue, 30 Jun 2009 17:49:05 -0400
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <200906301301.04604.gczerw@comcast.net> <200906301548.02518.gczerw@comcast.net> <829197380906301256w2f0a701ak2332d9ec2cfae35e@mail.gmail.com>
In-Reply-To: <829197380906301256w2f0a701ak2332d9ec2cfae35e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906301749.05168.gczerw@comcast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 30 June 2009 15:56:08 Devin Heitmueller wrote:
> On Tue, Jun 30, 2009 at 3:48 PM, George Czerw<gczerw@comcast.net> wrote:
> > Devin, thanks for the reply.
> >
> > Lsmod showed that "tuner" was NOT loaded (wonder why?), a "modprobe
> > tuner" took care of that and now the HVR-1800 is displaying video
> > perfectly and the tuning function works.  I guess that I'll have to add
> > "tuner" into modprobe.preload.d????  Now if only I can get the sound
> > functioning along with the video!
> >
> > George
>
> Admittedly, I don't know why you would have to load the tuner module
> manually on the HVR-1800.  I haven't had to do this on other products?
>
> If you are doing raw video capture, then you need to manually tell
> applications where to find the ALSA device that provides the audio.
> If you're capturing via the MPEG encoder, then the audio will be
> embedded in the stream.
>
> Devin

I don't understand why the audio/mpeg ports of the HVR-1800 don't show up in 
output of lspci:

03:00.0 Multimedia video controller: Conexant Systems, Inc. Device 8880 (rev 
0f)
        Subsystem: Hauppauge computer works Inc. Device 7801                    
        Flags: bus master, fast devsel, latency 0, IRQ 17                       
        Memory at f9c00000 (64-bit, non-prefetchable) [size=2M]                 
        Capabilities: [40] Express Endpoint, MSI 00                             
        Capabilities: [80] Power Management version 2                           
        Capabilities: [90] Vital Product Data                                   
        Capabilities: [a0] MSI: Mask- 64bit+ Count=1/1 Enable-                  
        Capabilities: [100] Advanced Error Reporting                            
        Capabilities: [200] Virtual Channel <?>                                 
        Kernel driver in use: cx23885                                           
        Kernel modules: cx23885


even though the dmesg output clearly shows this:

tveeprom 0-0050: decoder processor is CX23887 (idx 37) 
tveeprom 0-0050: audio processor is CX23887 (idx 42)


