Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:47409 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbZFHUUS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 16:20:18 -0400
Received: from host143-65.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KKX006JASHQQN21@mta1.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 08 Jun 2009 16:20:14 -0400 (EDT)
Date: Mon, 08 Jun 2009 16:20:07 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
In-reply-to: <4A2D4778.4090505@gatech.edu>
To: David Ward <david.ward@gatech.edu>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Message-id: <4A2D7277.7080400@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4A2CE866.4010602@gatech.edu> <4A2D1CAA.2090500@kernellabs.com>
 <829197380906080717x37dd1fd8n8f37fb320ab20a37@mail.gmail.com>
 <4A2D3A40.8090307@gatech.edu> <4A2D3CE2.7090307@kernellabs.com>
 <4A2D4778.4090505@gatech.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Ward wrote:
> On 06/08/2009 12:31 PM, Steven Toth wrote:
>> Your SNR is very low, 0x12c is 30db. I assume you're using digital 
>> cable this is borderline.
> Oh okay ... I wasn't sure how to translate those values before.
> 
>> I like my cable system at home to be atleast 32db (0x140) bare 
>> minimum, it's typically 0x160 (36db) for comfort.
> In your opinion, would I have enough justification for asking Comcast to 
> increase the signal strength coming to my house?  I'd like to avoid 
> calling someone to come out to my house to say "your TV works fine, 
> what's the problem?" and get slapped with a repair fee.  I wasn't sure 
> how well I could trust the SNR values reported by the card either...  I 
> wish I had a meter or something to test it on my own.  When I move the 
> computer directly to the input for the entire house, I get an increase 
> of about 0.1dB.

No idea, I debug my own cable network issues. That being said, usually cable 
companies like to deliver 0db to the house which is nice and hot, then it gets 
split and energy loss occurs 9as well as noise injection). I usually take home 
some metering equipment from the office to sweep my home network.

> 
> FYI, the signal strength is about 1dB higher for clear QAM signals.  
> (The values I sent are for ATSC.)
> 
>> It's possible that the tuner and 1409 driver are a little more 
>> optimized under windows.
>>
>> How much attenuation can you add under windows with signal loss? It's 
>> probably reasonably close to the edge also.
>>
> I tuned to the same channel under Windows, and I used the Signal 
> Strength Indicator application from Hauppauge (downloadable under the 
> Accessories page in the Support section).  It's reporting a SNR of 29-30 
> dB, and the value for 'correctable' errors goes to a single-digit value 
> about every 5 seconds -- following the same pattern seen with 'azap'.  
> However, the difference is that 'uncorrectable' errors stays at 0.  
> Under Linux, it seems that all errors are 'uncorrectable'.

So you don't have much leg room with windows either, certainly not enough for my 
liking. The difference between zero errors and a small handful can be pretty 
small in RF terms.

> 
> Does the error correction occur in the driver or in the chipset?  Seems 
> to me like maybe error correction is either not enabled or not 
> implemented correctly by the driver?

Error recovery is done in the chipset and is only as good as the RF signal 
reaching the demodulator.

> 
> I agree that the SNR could be better, and if you think it is worth a 
> try, I'll see what Comcast will do.  However, because Windows and my TV 
> work almost flawlessly, the Linux driver would ideally handle the 
> signals at least as well as them...

No idea and no I don't agree, just because your TV works doesn't mean the Linux 
driver has to be reliable. That's wishful thinking on your part and Comcast are 
not obliged to make your TV tuner work.

Again, if you have 29-30db on Windows you don't have a lot of legroom for signal 
  attenuation before you'll see errors. I frequently had windows reception 
errors when running at 31db with some boards.

We're getting into the realm of 'do you need to amplify and/or debug your cable 
network', and out of the realm of driver development.

Is the mxl5005s Linux tuner driver perfect? Is it as good as windows? Not quite, 
but it's good for many people and it's unlikely to improve in the near future.

Try installing a decent cable amp. Try looking at the MythTV wiki and support 
sites for improving your cable network.

> 
> Let me know what else is helpful from me, and thanks again for your help.
> 
> David

No problem, your welcome. I hope this advice helps.

Regards,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
