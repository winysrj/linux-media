Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailguard-send.adelaide.edu.au ([192.43.227.21])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ianwroberts@internode.on.net>) id 1KDqRE-000335-3z
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 02:43:14 +0200
Message-ID: <486ACEF1.1060200@internode.on.net>
Date: Wed, 02 Jul 2008 10:12:25 +0930
From: Ian W Roberts <ianwroberts@internode.on.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20080629102814.9177D11581F@ws1-7.us4.outblaze.com>
	<48676F36.8080401@internode.on.net>
In-Reply-To: <48676F36.8080401@internode.on.net>
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

My Gigabyte U7000-RH was working until last night when I upgraded to a
new kernel build -I'm running Ubuntu 8.04 and (now) 2.6.22-15-generic. :-(

Since then the device can't tune and I don't know how to troubleshoot
the problem. :-(

I've tried re-making and and re-installing the the v4l-dvb. I've tried
hg-ing a new clone from http://linuxtv.org/hg/v4l-dvb (and remaking &
re-installing). I've tried 'make rminstall' and 'make distclean'
followed by 'make; sudo make install'. I've placed a copy of the
firmware in /lib/firmware/2.6.22-15-generic/

When I connect my dvb-t dongle /var/log/messages look fine:

------------------------------------------------------------------------
Jul 2 08:55:12 squash kernel: [ 491.125748] dvb-usb: found a 'Gigabyte
U7000' in cold state, will try to load a firmware
Jul 2 08:55:12 squash kernel: [ 491.143173] dvb-usb: downloading
firmware from file 'dvb-usb-dib0700-1.10.fw'
Jul 2 08:55:12 squash kernel: [ 491.225304] dib0700: firmware started
successfully.
Jul 2 08:55:13 squash kernel: [ 491.434683] dvb-usb: found a 'Gigabyte
U7000' in warm state.
Jul 2 08:55:13 squash kernel: [ 491.434729] dvb-usb: will pass the
complete MPEG2 transport stream to the software demuxer.
Jul 2 08:55:13 squash kernel: [ 491.434822] DVB: registering new adapter
(Gigabyte U7000)
Jul 2 08:55:13 squash kernel: [ 491.578413] DVB: registering frontend 0
(DiBcom 7000PC)...
Jul 2 08:55:13 squash kernel: [ 491.601338] input: IR-receiver inside an
USB DVB receiver as /class/input/input7
Jul 2 08:55:13 squash kernel: [ 491.601358] dvb-usb: schedule remote
query interval to 150 msecs.
Jul 2 08:55:13 squash kernel: [ 491.601362] dvb-usb: Gigabyte U7000
successfully initialized and connected.
------------------------------------------------------------------------

When I try scanning for stations:
------------------------------------------------------------------------
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Adelaide
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 226500000 1 3 9 3 1 1 0
initial transponder 177500000 1 3 9 3 1 1 0
initial transponder 191625000 1 3 9 3 1 1 0
initial transponder 219500000 1 3 9 3 1 1 0
initial transponder 564500000 1 2 9 3 1 2 0
>>> tune to: 
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE 

(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 
177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE 

(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 
191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE 

(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 
219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE 

(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 
564500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 
564500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE 

(tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.
------------------------------------------------------------------------

My initial tuning data is:
------------------------------------------------------------------------
more /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Adelaide
# Australia / Adelaide / Mt Lofty
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
# ABC
T 226500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Seven
T 177500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Nine
T 191625000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Ten
T 219500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# SBS
T 564500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
------------------------------------------------------------------------

Any suggestions?

bye

ian


Ian W Roberts wrote:
> stev391@email.com wrote:
>   
>> Ian,
>>
>> Try updating to the latest scan file from the dvb-apps mercurial.  
>>
>> Channel 7 have changed their parameters in the last year and some tuners automatically try other combinations then instructed, that is why it is working with one and not the other.
>>
>> The new Channel 7 parameters are:
>> # Seven
>> T 177500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>   
>>     
> Brilliant, that worked! :-)
>
> I had tried changing the guard interval to 1/16 which seemed to change 
> the behaviour subtly but didn't achieve successful tuning. Changing that 
> 4 parameter (FEC High?) to 3/4 as well means my device works fine now. 
>
> Thanks
>
> ian
>   
>> As for the SBS problem it might be just poor reception or the tuner wasn't designed for the Australian frequencies correctly.
>>
>> Regards,
>> Stephen.
>>
>>
>>
>> <Original  Message>
>> Dear Linux-DVBers,
>>
>> I now own two USB DVB-T receivers (dongles): a Gigabyte U7000-RH and a
>> digitalNow tinyUSB2.
>>
>> I use them on my Kubuntu 7.10 workstation.
>>
>> I've had the digitalNow for a year or so and it has been working fine
>> (and easy to get going) with kaffeine except that I couldn't receive SBS
>> reliably (in Adelaide, Australia) although I was able to tune to it from
>> time to time. With the Tour de France starting next week (coverage
>> broadcast by SBS), I took a punt yesterday and bought a Gigabyte
>> U7000-RH and, yes, it too was easy to get going, and, luckily, receives
>> SBS nicely -but it can't tune to Channel 7 at all!
>>
>> My kaffeine installation now has a channel list that covers all the
>> local terrestrial TV stations. If I connect the digitalNow device, I can
>> watch 2, 9, 7 & 10 and if I connect the Gigabyte device I can watch SBS,
>> 2, 9 and 10.
>>
>> I'm presuming that means that by channel tuning data is OK. I don't know
>> whether it's relevant, but I notice that SBS seems to be the highest
>> frequency local station and Channel Seven seems to be the lowest. There
>> seems to be a problem with both devices at the opposite ends of the
>> frequency range.
>>
>> Any suggestions? (other the juggling the two devices!)
>>
>> bye
>>
>> ian
>>
>>      # Australia / Adelaide / Mt Lofty
>>      # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
>>      # ABC
>>      T 226500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>      # Seven
>>      T 177500000 7MHz 2/3 NONE QAM64 8k 1/16 NONE
>>      # Nine
>>      T 191625000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>      # Ten
>>      T 219500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>      # SBS
>>      T 564500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
>>
>>
>>   
>>
>> -- 
>> Be Yourself @ mail.com!
>> Choose From 200+ Email Addresses
>> Get a *Free* Account at www.mail.com <http://www.mail.com/Product.aspx>!
>>     
>
>
>   


-- 
Ian W Roberts
SOUTH AUSTRALIA



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
