Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <49143F68.2060902@osp.fi>
Date: Fri, 07 Nov 2008 15:15:20 +0200
From: Markus Ingalsuo <markus.ingalsuo@osp.fi>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <48E4E175.90403@julianfamily.org> <48E510BC.7040902@linuxtv.org>
In-Reply-To: <48E510BC.7040902@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR2250 / HVR2200 / SAA7164 status
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

Steven Toth wrote:
> Joe Julian wrote:
>   
>> Steven Toth wrote:
>>
>>     As you know, I'm writing a driver for the SAA7164 chipset, for the
>>     HVR2200 DVB-T and HVR2250 ATSC/QAM products.
>>
>>     People have been asking for status, here's where I am.
>>
>>     Do I have anything to share with people yet? Not yet.
>>
>>       
>>
>>     The basic driver framework is done. Firmware is loading, I can
>>     talking to the silicon through the proprietary PCIe ring buffer
>>     interface. I2C is working, eeprom and tuner/demod access is done.
>>     The HVR2250 is responding to azap commands, the tuners and demods
>>     are locking, snr looks pretty good... it's going to be a popular
>>     board for people. The HVR2200 (DVB-T Version) should also worked
>>     with tzap, it's untested and I can't comment on SNR at this stage. I
>>     need to add the DMA/buffering code, this is the missing pieces
>>     before a first public release. When I have anything to share I'll
>>     put up a tree and post a 'testers required' message here. 
>>
>>
>> We're a couple episodes into this fall television season and I'm missing 
>> my shows. ;)
>>
>> Having another month down, I wanted to send a friendly nudge your 
>> direction, Steve, to see how this is progressing.
>>     
>
> :)
>
> I hear you!
>
> Nothing to report lately. The S2API and the Plumbers conf took a lot of 
> my time, I'm only now getting back into a regular linux schedule.
>
> Feel free to ping me through this mailing list every few weeks.
>
> - Steve
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   

Hi!

I'm going to go ahead and feel free to ask if you have made any progress 
with the HVR2200? :)


//Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
