Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1KEeZv-0006L1-6i
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 08:15:32 +0200
Message-ID: <486DBFFD.5040209@iinet.net.au>
Date: Fri, 04 Jul 2008 14:15:25 +0800
From: timf <timf@iinet.net.au>
MIME-Version: 1.0
To: "George, Tom \(RTIO\)" <Tom.George@riotinto.com>,
 linux-dvb@linuxtv.org
References: <C74607610AB6D64794BA3820A9567DA705A6C81A@sbscpex06.corp.riotinto.org>
	<486DB90D.2030200@iinet.net.au>
	<C74607610AB6D64794BA3820A9567DA705A6C967@sbscpex06.corp.riotinto.org>
In-Reply-To: <C74607610AB6D64794BA3820A9567DA705A6C967@sbscpex06.corp.riotinto.org>
Subject: Re: [linux-dvb] dvb_usb_dib0700 tuning problems?
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

George, Tom (RTIO) wrote:
> Thanks Tim,
>
> I take it you're perth based then? :)
>
> Yeah, the -a 1 is just to point it to my device which for some reason
> chose to be device 1 not device 0 - due to me unplugging and moving the
> usb port while the pc was in suspend... normally it is device 0 though
> and I still have the same issues....
>
> Cheers,
>
> Tom 
>
> -----Original Message-----
> From: timf [mailto:timf@iinet.net.au] 
> Sent: Friday, 4 July 2008 1:46 PM
> To: George, Tom (RTIO)
> Cc: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] dvb_usb_dib0700 tuning problems?
>
> George, Tom (RTIO) wrote:
> <snip>
>   
>> root@jaws:/home/tom# scan -a 1 
>> /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth
>>
>> Anyone got an idea what is going on here???????
>>
>> CHeers,
>>
>> Tom
>>
>> Tom George
>>
>> RTIO WA Demand Coordinator - Office of the CIO
>>
>> Rio Tinto
>>
>> Central Park, 152 - 158 St Georges Terrace, Perth, 6000, Western
>>     
> Australia
>   
>> T: +61 (9) 8 94247251 M: +61 (0) 417940173 F: +61 (0) 8 9327 2456
>>
>> Tom.george@riotinto.com http://www.riotinto.com
>>
>> This email (including all attachments) is the sole property of Rio 
>> Tinto Limited and may be confidential. If you are not the intended 
>> recipient, you must not use or forward the information contained in 
>> it. This message may not be reproduced or otherwise republished 
>> without the written consent of the sender. If you have received this 
>> message in error, please delete the e-mail and notify the sender.
>>
>>     
> ------------------------------------------------------------------------
>   
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>     
> Hi Tom,
>
> I just tried:
>
> scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth
>
> and scan without -a 1 works fine.
>
> (Tuned all channels)
>
> Regards,
> Tim 
>  
> This email (including all attachments) is the sole property of Rio Tinto Limited and may be confidential.  If you are not the intended recipient, you must not use or forward the information contained in it.  This message may not be reproduced or otherwise republished without the written consent of the sender.  If you have received this message in error, please delete the e-mail and notify the sender.
>
>   
Hi Tom,
Yes, in fact I am closer to the Roleystone translator, so I had to 
construct a whole new au-Perth_Roleystone, which will be included with 
newer kernels and Kaffeine.
However, I can still scan Bickley transmitter.
I have a box with 2 tv cards in it, and I just tried:

scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth

scan -a 0 /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth

scan -a 1 /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Perth

and all scanned fine.

This would perhaps indicate some error from earlier than scan in your case.
I do recall with ubuntu that one needs to be careful when removing usb 
devices while in suspend mode.
Any chance of rebooting without the stick attached, then plugging it in, 
then try scan? (on its own without -a N)

If you have already tried that, the changing of channels is generally an 
instruction controlled by the firmware,
however, you appear to have the correct firmware.

Regards,
Tim

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
