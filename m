Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JlUi6-0006lr-Og
	for linux-dvb@linuxtv.org; Mon, 14 Apr 2008 21:51:27 +0200
Received: by ug-out-1314.google.com with SMTP id o29so604285ugd.20
	for <linux-dvb@linuxtv.org>; Mon, 14 Apr 2008 12:51:26 -0700 (PDT)
Message-ID: <4803B5BB.5050208@googlemail.com>
Date: Mon, 14 Apr 2008 20:51:23 +0100
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.1.1206183601.26852.linux-dvb@linuxtv.org>
	<47E813C7.6070208@googlemail.com>
	<200804120235.52939@orion.escape-edv.de>
	<4801D2B1.9050502@googlemail.com> <4801D77A.1070106@googlemail.com>
In-Reply-To: <4801D77A.1070106@googlemail.com>
Subject: Re: [linux-dvb] [PATCH] 2/3: implement DMX_SET_BUFFER_SIZE for dvr
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

Andrea wrote:
> Andrea wrote:
>> Ok.
>>
>> I've changed the second patch to
>> 1) allocate the new buffer before releasing the old one
>> 2) use spin_[un]lock_irq
>>
>> 3) On top of that, I have rearranged the code of DMX_SET_BUFFER_SIZE 
>> for the demux so that it does the same as the dvr (i.e. allocate the 
>> new buffer before releasing the old one). I think it is a good idea 
>> that 2 very similar functions are implemented in the same way. (if you 
>> don't agree, or if you think a 3rd separate patch for this point is a 
>> better idea, let me know.)
>>
>> PS: Both patches 1/3 and 2/3 are against a clean v4l-dvb tree. I do 
>> not know how to generate incremental patch for 2/3.
>>
>> Let me know what you think about that.
>>
>> Andrea
> 
> I've fixed the patch to pass the "make checkpatch" check.
> 
> Andrea

Implementation of DMX_SET_BUFFER_SIZE for dvr.
Synchronization of the code of DMX_SET_BUFFER_SIZE for demux and dvr.

Signed-off-by: Andrea Odetti <mariofutire@gmail.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
