Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41687 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751298AbeA2NwR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 08:52:17 -0500
Date: Mon, 29 Jan 2018 11:51:56 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josef Griebichler <griebichler.josef@gmx.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        John Youn <johnyoun@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Grigor Tovmasyan <Grigor.Tovmasyan@synopsys.com>
Subject: Re: dvb usb issues since kernel 4.9
Message-ID: <20180129115139.793774bd@vela.lan>
In-Reply-To: <20180126173739.5f581a21@vela.lan>
References: <CA+55aFx90oOU-3R8pCeM0ESTDYhmugD5znA9LrGj1zhazWBtcg@mail.gmail.com>
        <Pine.LNX.4.44L0.1801081354450.1908-100000@iolanthe.rowland.org>
        <20180126121737.70710f02@vela.lan>
        <20180126173739.5f581a21@vela.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Jan 2018 17:37:39 -0200
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Fri, 26 Jan 2018 12:17:37 -0200
> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> 
> > Hi Alan,
> > 
> > Em Mon, 8 Jan 2018 14:15:35 -0500 (EST)
> > Alan Stern <stern@rowland.harvard.edu> escreveu:
> >   
> > > On Mon, 8 Jan 2018, Linus Torvalds wrote:
> > >     
> > > > Can somebody tell which softirq it is that dvb/usb cares about?      
> > > 
> > > I don't know about the DVB part.  The USB part is a little difficult to
> > > analyze, mostly because the bug reports I've seen are mostly from
> > > people running non-vanilla kernels.     
> > 
> > I suspect that the main reason for people not using non-vanilla Kernels
> > is that, among other bugs, the dwc2 upstream driver has serious troubles
> > handling ISOCH traffic.
> > 
> > Using Kernel 4.15-rc7 from this git tree:
> > 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=softirq_fixup
> > 
> > (e. g. with the softirq bug partially reverted with Linux patch, and
> >  the DWC2 deferred probe fixed)
> > 
> > With a PCTV 461e device, with uses em28xx driver + Montage frontend
> > (with is the same used on dvbsky hardware - except for em28xx).
> > 
> > This device doesn't support bulk for DVB, just ISOCH. The drivers work 
> > fine on x86.
> > 
> > Using a test signal at the bit rate of 56698,4 Kbits/s, that's what
> > happens, when capturing less than one second of data:
> > 
> > $ dvbv5-zap -c ~/dvb_channel.conf "tv brasil" -l universal -X 100 -m -t2dvbv5-zap -c ~/dvb_channel.conf "tv brasil" -l universal -X 100 -m -t2
> > Using LNBf UNIVERSAL
> > 	Universal, Europe
> > 	Freqs     : 10800 to 11800 MHz, LO: 9750 MHz
> > 	Freqs     : 11600 to 12700 MHz, LO: 10600 MHz
> > using demux 'dvb0.demux0'
> > reading channels from file '/home/mchehab/dvb_channel.conf'
> > tuning to 11468000 Hz
> >        (0x00) Signal= -33.90dBm
> > Lock   (0x1f) Signal= -33.90dBm C/N= 30.28dB postBER= 2.33x10^-6
> > dvb_dev_set_bufsize: buffer set to 6160384
> >   dvb_set_pesfilter to 0x2000
> > 354.08s: Starting capture
> > 354.73s: only read 59220 bytes
> > 354.73s: Stopping capture
> > 
> > [  354.000827] dwc2 3f980000.usb: DWC OTG HCD EP DISABLE: bEndpointAddress=0x84, ep->hcpriv=116f41b2
> > [  354.000859] dwc2 3f980000.usb: DWC OTG HCD EP RESET: bEndpointAddress=0x84
> > [  354.010744] dwc2 3f980000.usb: --Host Channel 5 Interrupt: Frame Overrun--
> > ... (hundreds of thousands of Frame Overrun messages)
> > [  354.660857] dwc2 3f980000.usb: --Host Channel 5 Interrupt: Frame Overrun--
> > [  354.660935] dwc2 3f980000.usb: DWC OTG HCD URB Dequeue
> > [  354.660959] dwc2 3f980000.usb: Called usb_hcd_giveback_urb()
> > [  354.660966] dwc2 3f980000.usb:   urb->status = 0
> > [  354.660992] dwc2 3f980000.usb: DWC OTG HCD URB Dequeue
> > [  354.661001] dwc2 3f980000.usb: Called usb_hcd_giveback_urb()
> > [  354.661008] dwc2 3f980000.usb:   urb->status = 0
> > [  354.661054] dwc2 3f980000.usb: DWC OTG HCD URB Dequeue
> > [  354.661065] dwc2 3f980000.usb: Called usb_hcd_giveback_urb()
> > [  354.661072] dwc2 3f980000.usb:   urb->status = 0
> > [  354.661107] dwc2 3f980000.usb: DWC OTG HCD URB Dequeue
> > [  354.661120] dwc2 3f980000.usb: Called usb_hcd_giveback_urb()
> > [  354.661127] dwc2 3f980000.usb:   urb->status = 0
> > [  354.661146] dwc2 3f980000.usb: DWC OTG HCD URB Dequeue
> > [  354.661158] dwc2 3f980000.usb: Called usb_hcd_giveback_urb()
> > [  354.661165] dwc2 3f980000.usb:   urb->status = 0  
> 
> Btw, 
> 
> Just in case, I also applied all recent pending dwc2 patches I found at
> linux-usb (even trivial unrelated ones) at:
> 
> 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=dwc2_patches
> 
> No differences. ISOCH is still broken.
> 
> If anyone wants to see the full logs, it is there:
> 	https://pastebin.com/XJYyTwPv

Someone pointed me in priv that applying a change at DWC2 BRCM profile to
enable uframe_sched might help.

So, I wrote this patch:
	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=v4.15%2bmedia%2bdwc2&id=19abf0026b7bf1bd44aa9d2add9f958935760ded

And applied on the top of this branch:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=v4.15%2bmedia%2bdwc2

It is based on Kernel 4.15 vanilla. I applied:
	- all media -next patches that will be sent to Kernel 4.16-rc1;
	- DWC2 patches submitted by Gregor at linux-usb ML;
	- Linus softirq test patch:
		https://git.linuxtv.org/mchehab/experimental.git/commit/?h=v4.15%2bmedia%2bdwc2&id=ccf833fd4a5b99c3d3cf2c09c065670f74a230a7
	- A DT patch that enables VCIQ (needed by some GPU drivers):
		https://git.linuxtv.org/mchehab/experimental.git/commit/?h=v4.15%2bmedia%2bdwc2&id=fd4e9ca6f41d35b6234c30fa29937141e0c09570
	- a few debug patches like this one:
		https://git.linuxtv.org/mchehab/experimental.git/commit/?h=v4.15%2bmedia%2bdwc2&id=f50669c18394f5b5674630e2ebf78a06b023626f
 
I didn't notice any difference. The dwc2 driver is still broken for 
ISOCH transfers:
	https://pastebin.com/nL1Fe9X5

Cheers,
Mauro
