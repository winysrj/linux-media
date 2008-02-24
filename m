Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JTNRc-0003Lu-RY
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 21:27:32 +0100
Message-ID: <47C1D32F.9050900@gmail.com>
Date: Mon, 25 Feb 2008 00:27:27 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Artem Makhutov <artem@makhutov.org>
References: <20080223174406.GB30387@moelleritberatung.de>
	<47C0803D.2020504@gmail.com>
	<20080223212013.GD30387@moelleritberatung.de>
	<47C0903B.70606@gmail.com>
	<20080223213258.GE30387@moelleritberatung.de>
	<20080223214718.GF30387@moelleritberatung.de>
	<47C09519.2090904@gmail.com> <47C09BCC.50403@gmail.com>
	<20080224123736.GH30387@moelleritberatung.de>
	<47C176A7.9070608@gmail.com>
	<20080224174814.GI30387@moelleritberatung.de>
In-Reply-To: <20080224174814.GI30387@moelleritberatung.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechniSat SkyStar HD: Problems scaning and zaping
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

Artem Makhutov wrote:
> Hi,
> 
> On Sun, Feb 24, 2008 at 05:52:39PM +0400, Manu Abraham wrote:
>> Artem Makhutov wrote:
>>> Hi,
>>>
>>> On Sun, Feb 24, 2008 at 02:18:52AM +0400, Manu Abraham wrote:
>>>> Also, can you please do a benchmark in lock timings between changeset 
>>>> 7205 and 7200 ?
>>> Do you mean changeset 7200 or 7204
> 
> I did the benchmark betweet 7205 and 7204.
> The modules were loaded with no additional parameters.
> 
> Tuning time in 7204: ~0.83 seconds (min 0.81191 sec ; max 2.428967 sec)
> Tuning time in 7205: ~0.26 seconds (min 0.24789 sec ; max 1.994216 sec)
> 
> I have attached the logfiles of the tests.
> 
> I made 60 tunes for 7204 and 45 tunes for 7205.


 From the 7205 logs, it looks no lock failure at all. Is this too good 
to believe ?

but i do see that you have a lock loss case in 7204. is that 7204 and 7205
logs got interchanged ?


Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
