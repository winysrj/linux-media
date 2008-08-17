Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KUqSP-0005dV-WC
	for linux-dvb@linuxtv.org; Mon, 18 Aug 2008 00:10:44 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Mon, 18 Aug 2008 00:07:29 +0200
References: <57030da00808171108x41547032i20f59bd88ee5bc44@mail.gmail.com>
In-Reply-To: <57030da00808171108x41547032i20f59bd88ee5bc44@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808180007.30390@orion.escape-edv.de>
Subject: Re: [linux-dvb] dvb-ttpci errors only on certain satellite channels
Reply-To: linux-dvb@linuxtv.org
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

Johan van der Kolk wrote:
> Hi
> 
> I am getting this error, only when watching or recording certain
> (unfortunately most of the dutch) satellite channels.
> 
> The receiver card is a FF 2.1 Hauppauge (Nexus-s)
> 
>  dmesg |tail
> [ 8683.364276] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08cf b96a
> ret 0  handle ffff
> [ 8684.401584] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08d4 b96a
> ret 0  handle ffff
> [ 8685.436105] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08d5 b96a
> ret 0  handle ffff
> [ 8686.470599] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08d6 b96a
> ret 0  handle ffff
> [ 8687.506259] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08de b96a
> ret 0  handle ffff
> [ 8688.547456] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08df b96a
> ret 0  handle ffff
> [ 8689.581923] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08e0 b96a
> ret 0  handle ffff
> [ 8690.621384] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08e8 b96a
> ret 0  handle ffff
> [ 8691.662852] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08ed b96a
> ret 0  handle ffff
> [ 8692.697318] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08f7 b96a
> ret 0  handle ffff
> 
> 
> I tried to eliminate common factors between working and erroneous
> channels.
> So far I think I ruled out....Symbol rate, FEC, frequency, transponder,
> provider.
> 
> In most cases the sequence repeats itself, sometimes after 2 errors,
> sometimes
> after more errors. Judging from the display quality, also the
> signalstrength is good. (except from a thin horizontal line where the screen
> seems to split)
> I tried firmware versions d and f and use the latest v4l-dvb drivers
> 
> dvb_core               81404  2 stv0299,dvb_ttpci
> saa7146_vv             50304  1 dvb_ttpci
> saa7146                20360  2 dvb_ttpci,saa7146_vv
> 
> Since this happens every second, its filling up my logs quite well...I
> cant even troubleshoot something else..
> 
> Any help is greatly appreciated, even a suggestion for a good replacement
> receiver card, if this is a problem with my card. It has to support 2 CI
> interfaces though.

First of all you should try a recent firmware.
Please update the firmware to 2622 or to the lastest one
http://www.suse.de/~werner/test_av-f12623.tar.bz2

With current drivers the card should recover from an ARM crash.

Most ARM crashes are caused by bad signal quality.
Garbage data seems to crash the mpeg decoder of the card.
Sorry, there is no fix for this problem. 

CU
Oliver

----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
