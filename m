Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1K4gzQ-0000Sa-58
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 20:48:43 +0200
Message-ID: <48498674.50503@iinet.net.au>
Date: Sat, 07 Jun 2008 02:48:20 +0800
From: timf <timf@iinet.net.au>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <200806061630.35379.Nicola.Sabbi@poste.it>
	<1212772929.15600.41.camel@pc10.localdom.local>
In-Reply-To: <1212772929.15600.41.camel@pc10.localdom.local>
Cc: linux-dvb@linuxtv.org, Nico Sabbi <Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] Remote on Lifeview Trio: anyone got it working?
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

hermann pitton wrote:
> Hi,
>
> Am Freitag, den 06.06.2008, 16:30 +0200 schrieb Nico Sabbi:
>   
>> Hi,
>> did anyone get the remote controller on the Trio working?
>> I found a patch from which it seems that it talks via i2c either
>> at 0x0b or at 0x0e address and someone reported success,
>> but it seems that no patch was applied to linuxtv's HG repository.
>>
>> Can anyone who has it working post the correct patch(-es), please?
>>
>> Thanks,
>> 	Nico
>>
>>     
>
> you find the patch from Eddi based on the Henry Wong MSI TV@nywhere
> patch here.
>
> http://tux.dpeddi.com/lr319sta
>
> You might have to apply it manually, since quite old.
> If so, please post an updated patch after that for others.
> It is known to work.
>
> Doing the probing of the IR chip in ir-kbd-i2c to make it responsive is
> the main reason for not have been included, since it is expected not to
> be accepted at mainline. 
>
> According to Eddi and Peter on the video4linux-list on May 28 2007, the
> driver has a flaw in implementing i2c remotes card specific.
> Dwaine Garden with the same problem on the Kworld ATSC110 also confirmed
> that it is not possible to initialize the similar behaving KS chips from
> saa7134-cards.c currently. His patch version is also only off tree
> available.
>
> Sampling from gpio IRQ, what we do on recent Asus PC39 remotes, is also
> not implemented yet for i2c remotes and the lack is visible in
> saa7134-core.c.
>
> Cheers,
> Hermann
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   

Hi Hermann,

With regards this patch, the i2c stuff has changed in ir-kbd-i2c.c.
I have previously successfully modified Henry's patch for various i2c 
remotes.

However it no longer works, because of this change where the probing was 
done:

Part of Henry's patch:
<snip>
c.adapter = adap;
for (i = 0; -1 != probe[i]; i++) {
c.addr = probe[i];
+
+ if (c.adapter->id == I2C_HW_SAA7134 && probe[i] == 0x0b) {
+ /* enable ir receiver */
+ buf = 0;
+ if (1 != i2c_master_send(&c,&buf,1))
+ dprintk(1,"Unable to enable ir receiver.\n");
+ }
rc = i2c_master_recv(&c,&buf,0);
dprintk(1,"probe 0x%02x @ %s: %s\n",
probe[i], adap->name,
<snip>

The new i2c setup:
<snip>
for (i = 0; -1 != probe[i]; i++) {
msg.addr = probe[i];
rc = i2c_transfer(adap, &msg, 1);
dprintk(1,"probe 0x%02x @ %s: %s\n",
probe[i], adap->name,
(1 == rc) ? "yes" : "no");
if (1 == rc) {
ir_attach(adap, probe[i], 0, 0);
break;
}
}
<snip>
I have a few saa7134 cards with i2c remotes - all of these remotes are 
completely dead.

Does anybody have a suggestion how to make this work, now?

Regards,
Timf

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
