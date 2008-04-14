Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JlUi4-0006lr-Oq
	for linux-dvb@linuxtv.org; Mon, 14 Apr 2008 21:51:25 +0200
Received: by ug-out-1314.google.com with SMTP id o29so604285ugd.20
	for <linux-dvb@linuxtv.org>; Mon, 14 Apr 2008 12:51:17 -0700 (PDT)
Message-ID: <4803B5B0.8070803@googlemail.com>
Date: Mon, 14 Apr 2008 20:51:12 +0100
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.1.1206183601.26852.linux-dvb@linuxtv.org>
	<47E4EE5B.1010406@googlemail.com> <4801D2A8.4020903@googlemail.com>
	<4801D735.6040905@googlemail.com>
In-Reply-To: <4801D735.6040905@googlemail.com>
Subject: Re: [linux-dvb] [PATCH] 1/3: BUG FIX in dvb_ringbuffer_flush
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
>> I've just added a comment to patch 1/3.
>> I post it here again.
>>
>> This patch fixes the bug in DMX_SET_BUFFER_SIZE for the demux.
>> Basically it resets read and write pointers to 0 in case they are 
>> beyond the new size of the buffer.
>>
>> In the next patch (2/3) I rewrite this function to behave the same as 
>> the new DMX_SET_BUFFER_SIZE for the dvr.
>> I thought it is a good idea for the 2 very similar ioctl to be 
>> implemented in the same way.
>>
>> Andrea
> 
> I've fixed some formatting errors reported by "make checkpatch".
> 
> Andrea


This patch fixes a bug in DMX_SET_BUFFER_SIZE in case the buffer shrinks.

Signed-off-by: Andrea Odetti <mariofutire@gmail.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
