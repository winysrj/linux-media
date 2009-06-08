Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:56331 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbZFHQbc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 12:31:32 -0400
Received: from host143-65.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KKX00CWWHWKY790@mta1.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 08 Jun 2009 12:31:33 -0400 (EDT)
Date: Mon, 08 Jun 2009 12:31:30 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
In-reply-to: <4A2D3A40.8090307@gatech.edu>
To: David Ward <david.ward@gatech.edu>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Message-id: <4A2D3CE2.7090307@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4A2CE866.4010602@gatech.edu> <4A2D1CAA.2090500@kernellabs.com>
 <829197380906080717x37dd1fd8n8f37fb320ab20a37@mail.gmail.com>
 <4A2D3A40.8090307@gatech.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Ward wrote:
> On 06/08/2009 10:17 AM, Devin Heitmueller wrote:
>> On Mon, Jun 8, 2009 at 10:14 AM, Steven Toth<stoth@kernellabs.com>  
>> wrote:
>>   
>>>> Please let me know how I should proceed in solving this.  I would be 
>>>> happy
>>>> to provide samples of captured video, results from new tests, etc.
>>>>        
>>> When you tune using azap, and you can see UNC and BER values, what is 
>>> the
>>> SNR value and does it move over the course of 30 seconds?
>>>
>>> -- 
>>> Steven Toth - Kernel Labs
>>> http://www.kernellabs.com
>>>      
>> Also, I believe UNC and BER display garbage when signal lock is lost,
>> so do you see the "status" field change when the BER/UNC fields show
>> data?
>>
>> Devin
>>
>>    
> Steven, Devin,
> 
> Thanks for your replies.  The signal and SNR are usually in the range 
> 0x0128 - 0x0140.  They may increment or decrement on a per-second basis 
> but otherwise remain steady.  The status field does not change most of 
> the time when bit errors occur, but it does lose the lock from time to 
> time for a second.  Here is a representative sample:
> 
> david@delldimension:~$ azap -r RTN
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 555000000 Hz
> video pid 0x0051, audio pid 0x0052
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 1f | signal 012e | snr 012e | ber 00001b04 | unc 00001b04 | 
> FE_HAS_LOCK
> status 1f | signal 012c | snr 012e | ber 00000000 | unc 00000000 | 
> FE_HAS_LOCK

Your SNR is very low, 0x12c is 30db. I assume you're using digital cable this is 
borderline.

I like my cable system at home to be atleast 32db (0x140) bare minimum, it's 
typically 0x160 (36db) for comfort.

It's possible that the tuner and 1409 driver are a little more optimized under 
windows.

How much attenuation can you add under windows with signal loss? It's probably 
reasonably close to the edge also.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
