Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <morgan.torvolt@gmail.com>) id 1L2nHp-0006ne-Ih
	for linux-dvb@linuxtv.org; Wed, 19 Nov 2008 14:40:06 +0100
Received: by yw-out-2324.google.com with SMTP id 3so1423897ywj.41
	for <linux-dvb@linuxtv.org>; Wed, 19 Nov 2008 05:40:01 -0800 (PST)
Message-ID: <3cc3561f0811190540o341d3807lbd568a8ddb53d9d8@mail.gmail.com>
Date: Wed, 19 Nov 2008 13:40:00 +0000
From: "=?ISO-8859-1?Q?Morgan_T=F8rvolt?=" <morgan.torvolt@gmail.com>
To: Goga777 <goga777@bk.ru>
In-Reply-To: <20081109212526.677d5c76@bk.ru>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081106124730.16840@gmx.net> <20081106144319.268390@gmx.net>
	<200811081130.21951.liplianin@tut.by>
	<1a297b360811081323k61c0dd44vf3834ba965b20466@mail.gmail.com>
	<20081109212526.677d5c76@bk.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] stb0899: Set min symbol rate to 1000000
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

>> Lower than 5MSPS goes below the Half Power bandwidth characteristics.
>> Usually we have limits defined within the characteristic region,
>> rather than absolute limits at which tuning fails
>
>
> that is strange limitation , there's a lot of dvb channels with streams less than 3 mSym/s

Second that. There are lots and lots of muxes with low bandwidth, and
the satellite feeds used by many providers are usually 6111 MS or
something similar. Some people enjoy watching those, as they sometimes
contain football feeds or other such stuff.
C band usually use small bandwidth "muxes" with only one channel in
them also. Why put a limit on it? If it works, it works. I can
understand a limit on frequency, but not on symbolrate.

-Morgan-

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
