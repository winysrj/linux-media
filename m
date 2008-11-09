Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp132.rog.mail.re2.yahoo.com ([206.190.53.37])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <cityk@rogers.com>) id 1Kz1mP-0008PS-3J
	for linux-dvb@linuxtv.org; Sun, 09 Nov 2008 05:20:06 +0100
Message-ID: <491664D2.90203@rogers.com>
Date: Sat, 08 Nov 2008 23:19:30 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: larrykathy3@verizon.net
References: <759163.14018.qm@web84101.mail.mud.yahoo.com>
In-Reply-To: <759163.14018.qm@web84101.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Geniatech x8000 thriller
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

Ruth Fernandez wrote:
> I have a Geniatech x8000 thriller ATSC card. The only way Ubuntu will
> see it is with the ismod option in the etc/modprobe.d/option file. The
> ATSC part is not recognized. Plus there is no sound. Can you help.
> Larry -dmesg below
>
>  44.901324] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
> [   44.901560] cx88[0]: subsystem: 14f1:1419, board: Geniatech
> X8000-MT DVBT [card=63,insmod option], frontend(s): 1
>

Wrong card option; card 63 is for the DVB-T version of the card and,
consequently, explains why the wrong components are being loaded.  Use
card=67 instead.  There may be further info for you in: 
http://www.linuxtv.org/wiki/index.php/KWorld_ATSC_120

Can you report your success on the matter and also supply the output of
"lspci -vn" (to see what the PCI subsystem ID for the card is, and as to
whether it differs from the KWorld card).  Thanks.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
