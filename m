Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1JXrMA-0003nY-Fz
	for linux-dvb@linuxtv.org; Sat, 08 Mar 2008 06:12:27 +0100
Message-ID: <47D22035.90700@linuxtv.org>
Date: Sat, 08 Mar 2008 00:12:21 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: "Timothy D. Lenz" <tlenz@vorgon.com>
References: <001501c880b3$5a749430$0a00a8c0@vorg>
In-Reply-To: <001501c880b3$5a749430$0a00a8c0@vorg>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Supported ATSC cards with HW mpeg encoders
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

Timothy D. Lenz wrote:
> I plan to get a dual ATSC tunner at some point, but as the 2250 does not
> seem to even be out yet and the HDHomeRun does not support NTSC, I am
> looking at getting a cheaper card that does suport NTSC for now. I am runing
> VDR and using the Nexus RGB out to a 23 year old Sony. So any HD must be
> down scaled anyway. AS a couple of our Digital locals are HD, this is what I
> want a card with NTSC for, to get the SDTV format of those channels. Cards
> like the pcHDTV HD-5500 while claiming to suport NTSC, do not have a HW mpeg
> encoder to convert the video to a format that can be sent out the Nexus
> video out. You would still need to set up software encoder/decoders. Problem
> is, the specs for ATSC tuner cards fall far short of providing this info. So
> what I want to know is, do any of the following cards have HW mpeg2 encoders
> that is suported by linux/vdr:
> 
> DVICO FusionHDTV 5 RT Lite
> http://store.snapstream.com/fusionhdtv-lite.html?gclid=CJODl6T0-ZECFQovgwod0Vg_xA
> 
> KWorld ATSC 115
> http://www.newegg.com/Product/Product.aspx?Item=N82E16815260005 (they also
> have a 120, but I'm not finding much about linix suport for it ether)
> 
> Pinnacle PCTV HD
> http://www.newegg.com/Product/Product.aspx?Item=N82E16815144018

None of the above have hardware mpeg encoders.  A good card that I'd recommend for your needs right now is the Hauppauge HVR-1800.

This is a dual tuner combo atsc/qam / hardware mpeg encoder card.  Already the ATSC/QAM support is in the 2.6.24 kernel.  Stoth has the hardware mpeg encoder working in his cx23885-video tree.  After some more testing and cleanups, it will eventually be merged into the master repository, hopefully in time for the 2.6.26 kernel release.

HTH,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
