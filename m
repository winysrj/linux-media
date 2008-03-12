Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [81.2.121.150] (helo=mail.firshman.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ben@firshman.co.uk>) id 1JZUKN-0005tb-Ql
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 18:01:20 +0100
Received: from macbook.intra ([192.168.211.179])
	by mail.firshman.co.uk with esmtpsa (TLS-1.0:RSA_AES_128_CBC_SHA1:16)
	(Exim 4.63) (envelope-from <ben@firshman.co.uk>) id 1JZUKI-0004sq-LR
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 17:01:15 +0000
Message-Id: <536FA610-348E-42E0-B679-520373BB6DB3@firshman.co.uk>
From: Ben Firshman <ben@firshman.co.uk>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <b04e7ceb0803111537j7ccd5cfau4da464438083b4e2@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Wed, 12 Mar 2008 17:01:13 +0000
References: <20080311110707.GA15085@mythbackend.home.ivor.org>
	<47D701A7.40805@philpem.me.uk> <1205273404.20608.2.camel@youkaida>
	<b04e7ceb0803111537o50b6478ep867d9c26f79b299a@mail.gmail.com>
	<b04e7ceb0803111537j7ccd5cfau4da464438083b4e2@mail.gmail.com>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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

When I was having the problem, I was running 2.6.22 (vanilla ubuntu),  
so it doesn't appear to be related to kernel version.

The fix posted a few weeks ago does seem to have stopped it for me. I  
said I lost a tuner recently, but I think that may have just been a  
loss in reception.

Ben

On 11 Mar 2008, at 22:37, Luis Cidoncha wrote:

> On Tue, Mar 11, 2008 at 11:10 PM, Nicolas Will <nico@youplala.net>  
> wrote:
>
>>> I'm building a kernel from the 2.6.24.2 virgin source on Ubuntu to  
>>> do
>>> some
>>> testing; I'd like to prove that the problem exists in 2.6.24 proper
>>> before
>>> screaming "kernel bug". But if 2.6.22 works, a bug is looking more  
>>> and
>>> more
>>> likely.
>>>
>>
>
> I'm having the "losing one tuner" problem on my Nova T-500 too.
>
> I'm currently running a vanilla 2.6.23.9, without USB_SUSPEND (the
> support for it is in the kernel, but I have it desactivated)
>
> Luis.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
