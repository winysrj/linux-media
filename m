Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JVNnZ-0007BI-3n
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 10:14:29 +0100
Received: by fk-out-0910.google.com with SMTP id z22so6582830fkz.1
	for <linux-dvb@linuxtv.org>; Sat, 01 Mar 2008 01:14:25 -0800 (PST)
Message-ID: <47C91E6E.3060006@googlemail.com>
Date: Sat, 01 Mar 2008 09:14:22 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: Thierry Lelegard <thierry.lelegard@tv-numeric.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAnIT3wzzVLUSYmPE4pB04JwEAAAAA@tv-numeric.com>
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAnIT3wzzVLUSYmPE4pB04JwEAAAAA@tv-numeric.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] RE :  Length of /dev/dvb/adapter0/dvr0's buffer.
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

Thierry Lelegard wrote:
>> I'm trying to read from /dev/dvb/adapter0/dvr0.
>> The problem is that the process reading sometimes is not fast enough and after a while I get errno 
>> 75 when I try to read from it.
>>
>> On average the speed is ok, so it should work.
>> There must be a buffer behind dvr0 that goes in error onece it is full.
>>
>> 1) how can I make it bigger?
>> 2) how can I check how full it is?
> 
> You can set the *demux* buffer size, upstream from dvr, using ioctl DMX_SET_BUFFER_SIZE.
> The default value is 8 kB. Using 1 MB, I can do full TS capture without any loss. 
> 
> 

I've noticed that there are 2 ioctl DMX_SET_BUFFER_SIZE, one for the demux, one for the dvr.
The second is not implemented.

switch (cmd) {
case DMX_SET_BUFFER_SIZE:
         // FIXME: implement
         ret = 0;
         break;

Could you please help me:

1) how many ringbuffers are there?
2) I'm reading from dvr, which one do I need to set?
3) I can try to implement the above code if needed.

Cheers

Andrea



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
