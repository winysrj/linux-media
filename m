Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lindsay@softlog.com.au>) id 1L4R2I-0006n3-Jg
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 03:18:54 +0100
Received: from [127.0.0.1] by softlog.com.au (MDaemon PRO v9.5.6)
	with ESMTP id 08-md50000010179.msg
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 12:17:43 +1000
Message-ID: <492A0EC6.9090007@softlog.com.au>
Date: Mon, 24 Nov 2008 12:17:42 +1000
From: Lindsay Mathieson <lindsay@softlog.com.au>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <bf82ea70811110306v345c9061sc6d49f6a961647c@mail.gmail.com>	<bf82ea70811110312y487610d8v9656c3e76bf44e0@mail.gmail.com>	<49199510.6040809@iki.fi>
	<49223D1E.9030300@softlog.com.au> <49285BAB.10505@iki.fi>
In-Reply-To: <49285BAB.10505@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DigitalNow TinyTwin second tuner support
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

Antti Palosaari wrote:
> Lindsay Mathieson wrote:
>> Antti Palosaari wrote:
>>> I disabled 2nd tuner by default due to bad performance I faced up 
>>> with my hardware. Anyhow, you can enable it by module param, use 
>>> modprobe dvb-usb-af9015 dual_mode=1 . Test it and please report.
>>>   
>>
>>
>> All this has inspired me to retry my DigitalNow TinyTwin. The results
>> are good (excellent) and badish. I am available to do any testing and
>> builds required. Thanks for all the hard work!
>>
>
> I made other test version of af9015 driver which uses different 
> MXL500x tuner driver. I think it will perform a lot more better. 
> Please test:
> http://linuxtv.org/hg/~anttip/af9015-mxl500x/


Ok, done some initial testing.

- Uninstalled old build, rebooted,  installed new build and rebooted
- /dev/dvb/adaptor0 created
- Tunes and play's back *really* well, I tested with Kaffeine - 
excellent reception, no dropouts or sounds squeaks that I noticed. 
Tested with HD signals as well. This was only for a few miniutes, I 
haven't had a chance to schedule a full recording, but will test that soon.

I enabled the second tuner and ran into the exactly problems as before 
when trying to tune - kernel crash etc. The machine locked up on 
shutdown and required a hard boot.

Thanks! - Lindsay


-- 
Lindsay
Softlog Systems



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
