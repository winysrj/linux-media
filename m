Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48F5F57C.1090403@linuxtv.org>
Date: Wed, 15 Oct 2008 09:51:56 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: korey_avail@yahoo.com
References: <687344.54367.qm@web57506.mail.re1.yahoo.com>
In-Reply-To: <687344.54367.qm@web57506.mail.re1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dvico HDTV7 Dual Express signal strength
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

Korey ODell wrote:
> --- On *Tue, 10/14/08, Michael Krufky /<mkrufky@linuxtv.org>/* wrote:
>
>     From: Michael Krufky <mkrufky@linuxtv.org>
>     Subject: Re: [linux-dvb] Dvico HDTV7 Dual Express signal strength
>     To: korey_avail@yahoo.com
>     Cc: linux-dvb@linuxtv.org
>     Date: Tuesday, October 14, 2008, 6:33 PM
>
>     Korey ODell wrote:
>     > Does reading this card's signal strength work for anyone? I've
>     tried femon, azap with the latest v4l drivers and a 2.6.26 kernel. Card reports
>     a lock and otherwise works fine but basically reports 0 for a strength reading.
>
>
>     There are two versions of this card -- one that uses a s5h1409, and the other
>     uses a s5h1411.  Which version do you have?
>
>     (dmesg output will indicate which
>      board you have)
>
>     -Mike
>               
>
>
>
> --- On *Tue, 10/14/08, Michael Krufky /<mkrufky@linuxtv.org>/* wrote:
>
>     From: Michael Krufky <mkrufky@linuxtv.org>
>     Subject: Re: [linux-dvb] Dvico HDTV7 Dual Express signal strength
>     To: korey_avail@yahoo.com
>     Cc: linux-dvb@linuxtv.org
>     Date: Tuesday, October 14, 2008, 6:33 PM
>
>     Korey ODell wrote:
>     > Does reading this card's signal strength work for anyone? I've
>     tried femon, azap with the latest v4l drivers and a 2.6.26 kernel. Card reports
>     a lock and otherwise works fine but basically reports 0 for a strength reading.
>
>
>     There are two versions of this card -- one that uses a s5h1409, and the other
>     uses a s5h1411.  Which version do you have?
>
>     (dmesg output will indicate which board you
>      have)
>
>     -Mike
>               
>
> I actually have both.
> The DViCO FusionHDTV 7 Gold [card=65] has the 1411 and the
> DViCO FusionHDTV7 Dual Express [card=10,autodetected] has the 1409.
>
> I can not read the signal strength on either of them.
> Here is what femon yields on the Gold card (1411)
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 | 
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 | 
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 | 
> FE_HAS_LOCK
>
> recabling this same RF to a HDTV5 Gold card reports ~90-95% signal 
> strength.
>
> Thanks for any help.
Korey,

Policy on this mailing list is to post your reply below the quoted text 
-- please stick to this quoting style.

You say that you are not able to read signal strength -- but your femon 
output above indicates a very nice SNR of 30.0  ( 0x012c == 300 decimal 
/ 10 = 30.0 dB )


The FusionHDTV 5 Gold uses an LG DT3303 demodulator, which reports its 
signal status a bit differently.

Unfortunately, we dont have good open specs that we can use to improve 
the readouts from the lgdt330x driver any better than it is currently.

Everything is fine with both of your cards, its just that the snr 
readings are not comparable between different frontends.

HTH,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
