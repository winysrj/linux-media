Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from kelvin.aketzu.net ([81.22.244.161] ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <akolehma@aketzu.net>) id 1LLb9x-00057U-MN
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 11:33:43 +0100
Date: Sat, 10 Jan 2009 12:33:37 +0200
From: Anssi Kolehmainen <anssi@aketzu.net>
To: Manu Abraham <abraham.manu@gmail.com>
Message-ID: <20090110103337.GE18986@aketzu.net>
References: <1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis users
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

On Sat, Jan 10, 2009 at 01:00:43AM +0400, Manu Abraham wrote:
> Hi,
> 
> Can you all please provide me the following information for the Mantis / Hopper bridge
> based cards that you have in the following manner ?
> 
> 1) Card Name (As advertised on the cardboard box):

Terratec Cinergy C (VP-2040 clone) [and Terratec Cinergy CI Addon Card]

http://www.verkkokauppa.com/popups/prodinfo.php?id=3109
http://www.verkkokauppa.com/popups/prodinfo.php?id=26551

> 2) lspci -vvn:

02:09.0 0480: 1822:4e35 (rev 01)
        Subsystem: 153b:1178
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort+ <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at df000000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis
        Kernel modules: mantis

> 3) Chips on the card if you know them (only the basic chip description is required,
> not the complete batch no. etc)

Don't know, it's well hidden inside my computer and checking it out
would make me lose my uptime (and probably wouldn't do any good for
harddrives which have been spinning for years without breaks).

http://www.terratec.net/en/products/pictures/img/1565213_ac5fcffc30.png

-- 
Anssi Kolehmainen
anssi.kolehmainen@iki.fi
040-5085390

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
