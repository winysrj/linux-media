Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ianwroberts@internode.on.net>) id 1KCuuG-0000VM-B8
	for linux-dvb@linuxtv.org; Sun, 29 Jun 2008 13:17:23 +0200
Message-ID: <48676F36.8080401@internode.on.net>
Date: Sun, 29 Jun 2008 20:47:10 +0930
From: Ian W Roberts <ianwroberts@internode.on.net>
MIME-Version: 1.0
To: stev391@email.com
References: <20080629102814.9177D11581F@ws1-7.us4.outblaze.com>
In-Reply-To: <20080629102814.9177D11581F@ws1-7.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Tuning problems
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

stev391@email.com wrote:
> Ian,
>
> Try updating to the latest scan file from the dvb-apps mercurial.  
>
> Channel 7 have changed their parameters in the last year and some tuners automatically try other combinations then instructed, that is why it is working with one and not the other.
>
> The new Channel 7 parameters are:
> # Seven
> T 177500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>   
Brilliant, that worked! :-)

I had tried changing the guard interval to 1/16 which seemed to change 
the behaviour subtly but didn't achieve successful tuning. Changing that 
4 parameter (FEC High?) to 3/4 as well means my device works fine now. 

Thanks

ian
> As for the SBS problem it might be just poor reception or the tuner wasn't designed for the Australian frequencies correctly.
>
> Regards,
> Stephen.
>
>
>
> <Original  Message>
> Dear Linux-DVBers,
>
> I now own two USB DVB-T receivers (dongles): a Gigabyte U7000-RH and a
> digitalNow tinyUSB2.
>
> I use them on my Kubuntu 7.10 workstation.
>
> I've had the digitalNow for a year or so and it has been working fine
> (and easy to get going) with kaffeine except that I couldn't receive SBS
> reliably (in Adelaide, Australia) although I was able to tune to it from
> time to time. With the Tour de France starting next week (coverage
> broadcast by SBS), I took a punt yesterday and bought a Gigabyte
> U7000-RH and, yes, it too was easy to get going, and, luckily, receives
> SBS nicely -but it can't tune to Channel 7 at all!
>
> My kaffeine installation now has a channel list that covers all the
> local terrestrial TV stations. If I connect the digitalNow device, I can
> watch 2, 9, 7 & 10 and if I connect the Gigabyte device I can watch SBS,
> 2, 9 and 10.
>
> I'm presuming that means that by channel tuning data is OK. I don't know
> whether it's relevant, but I notice that SBS seems to be the highest
> frequency local station and Channel Seven seems to be the lowest. There
> seems to be a problem with both devices at the opposite ends of the
> frequency range.
>
> Any suggestions? (other the juggling the two devices!)
>
> bye
>
> ian
>
>      # Australia / Adelaide / Mt Lofty
>      # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
>      # ABC
>      T 226500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>      # Seven
>      T 177500000 7MHz 2/3 NONE QAM64 8k 1/16 NONE
>      # Nine
>      T 191625000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>      # Ten
>      T 219500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>      # SBS
>      T 564500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
>
>
>   
>
> -- 
> Be Yourself @ mail.com!
> Choose From 200+ Email Addresses
> Get a *Free* Account at www.mail.com <http://www.mail.com/Product.aspx>!


-- 
Ian W Roberts
157 Sixth Avenue
Royston Park 5070
SOUTH AUSTRALIA

w:	+61 8 8303 6261
h:	+61 8 8362 1318
m:	0423 147 044
e:	ianwroberts@internode.on.net

This email message is intended only for the addressee(s) and contains information that may be confidential and/or copyright. If you are not the intended recipient please notify the sender by reply email and immediately delete this email. Use, disclosure or reproduction of this email by anyone other than the intended recipient(s) is strictly prohibited. No representation is made that this email or any attachments are free of viruses. Virus scanning is recommended and is the responsibility of the recipient.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
