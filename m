Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ihaywood@iinet.net.au>) id 1JcI52-0007oy-Vj
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 11:33:06 +0100
From: Ian Haywood <ihaywood@iinet.net.au>
To: linux-dvb@linuxtv.org
Date: Thu, 20 Mar 2008 21:34:40 +1100
References: <47E060EB.5040207@t-online.de>
	<200803192050.40863.ihaywood@iinet.net.au>
	<1205962465.5992.59.camel@pc08.localdom.local>
In-Reply-To: <1205962465.5992.59.camel@pc08.localdom.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803202134.40674.ihaywood@iinet.net.au>
Subject: [linux-dvb] Kworld 220RF not tuning
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

On Thursday 20 March 2008 08:34:25 hermann pitton wrote:
> Hi Ian,

> the i2c goes mad currently on your card and that results in a total mess
> for the eeprom readout, that goes also for the subsystem there, which is
> corrupted and hence you get card=0 without tuner and DVB loaded.
reboot fixes this problem.

> Use recent scan files from linuxtv.org mercurial dvb-apps, for example
> "Seven" recently changed, maybe we can discover something then, for sure
> other people have the card working, not long back we fixed some analog
> inputs and the radio and DVB-T was still OK.
Ok, got these, and compiled the "scan" tool from them. 
No change: all channels fail with ">>> tuning status == 0x00" 
At the risk of asking the obvious, what does this error actually
mean? I've assumed it means problem with the driver, could
it be a hardware or aerial problem?
> Also your previous experimentation with the tuner address was pointless
> that way. The analog tuner is correctly detected at 0x61, the second
> tuner used for DVB-T is at 0x60 and also did not throw an error?
Maybe stupid question: is the second tuner for DVB detected? 
There's no mention of it in my dmesg, and that would explain the 
problem (analog fine, DVB doesn't tune)

Thanks for your help.

Ian




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
