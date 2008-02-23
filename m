Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JT2ht-0003EG-DZ
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 23:18:57 +0100
Message-ID: <47C09BCC.50403@gmail.com>
Date: Sun, 24 Feb 2008 02:18:52 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Artem Makhutov <artem@makhutov.org>
References: <32245669.2613.1203594791803.JavaMail.tomcat@dali.otenet.gr>	<47C01325.10407@otenet.gr>	<20080223174406.GB30387@moelleritberatung.de>	<47C0803D.2020504@gmail.com>	<20080223212013.GD30387@moelleritberatung.de>	<47C0903B.70606@gmail.com>	<20080223213258.GE30387@moelleritberatung.de>	<20080223214718.GF30387@moelleritberatung.de>
	<47C09519.2090904@gmail.com>
In-Reply-To: <47C09519.2090904@gmail.com>
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

Manu Abraham wrote:
> Artem Makhutov wrote:
>> Hi,
>>
>> On Sat, Feb 23, 2008 at 10:32:58PM +0100, Artem Makhutov wrote:
>>> On Sun, Feb 24, 2008 at 01:29:31AM +0400, Manu Abraham wrote:
>>>> Are you sure that you got the top level 2 changes changeset 7204 and 7203
>>>> respectively ?
>>> Oh, I only got 7203. Will try with 7204 in a few minutes.
>> Awesome! It fixed the problem:
>>
>> Try: 100
>> Failes: 0
>> Tunes: 100
>>
>> Great job!

Also, can you please do a benchmark in lock timings between changeset 
7205 and 7200 ?

The timing can be looked at by enabling the time stamps in the kernel 
config and
looking at timestamps in the logs for start - stop (FE_HAS_LOCK) between 
the 2
changesets.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
