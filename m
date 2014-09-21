Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53962 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbaIUP2p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 11:28:45 -0400
Message-ID: <541EEEAB.10106@iki.fi>
Date: Sun, 21 Sep 2014 18:28:43 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: JPT <j-p-t@gmx.net>, linux-media@vger.kernel.org
Subject: Re: Running Technisat DVB-S2 on ARM-NAS
References: <541EE016.9030504@gmx.net> <541EE2EB.4000802@iki.fi> <541EEA74.2000909@gmx.net>
In-Reply-To: <541EEA74.2000909@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/21/2014 06:10 PM, JPT wrote:
>>> How my I find out more about the error -12?
>>
>> http://www.virtsync.com/c-error-codes-include-errno
>>
>> #define ENOMEM      12  /* Out of memory */
>>
>> Likely allocating USB stream buffers fails. You could try request
>> smaller buffers. Drop count to 1 and test. Drop framesperurb to 1 and
>> test. Drop framesize to 1 and test. Surely streaming will not work if
>> all buffers are totally wrong and too small, but you will see if it is
>> due to big usb buffers. Then you could try optimize buffers smaller.
>>
>
> Wow, that did it. Thanks Antti!
>
> Works with count = 2, but not with count = 4.
>
> What exactly do I learn from this?
> Where are those buffers? In the RAM? or somewhere in onboard USB hardware?
>
> VDR is now able to connect to the device, but I am not sure if it
> receives anything yet.

.count = 8,
.framesperurb = 32,
.framesize = 2048,

If I didn't remember wrong, that means allocated buffers are 8 * 32 * 
2048 = 524288 bytes. It sounds rather big for my taste. Probably even 
wrong. IIRC USB2.0 frames are 1024 and there could be 1-3 frames. You 
could use lsusb with all verbosity levels to see if it is 
1024/2048/3072. And set value according to that info.

32 framesperurb sounds absolute too much. You could decrease it a lot, 
under 10 should be OK. Maybe 8 is good guess. 8 is number of URBs you 
use for streaming. 8 does not sound bad, but maybe 6 is OK if it works. 
Smallest value depends largely device USB FIFO size vs. stream size. 
Bigger the FIFO less the buffers needed. Smaller the stream, less the 
buffers needed.

So I would recommend
.count = 6,
.framesperurb = 8,
.framesize = 1024,

Use some testing with error and trial to find out smallest working 
buffers, then add some 20% extra for that.

regards
Antti



-- 
http://palosaari.fi/
