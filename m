Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aiolos.otenet.gr ([195.170.0.93] ident=OTEnet-mail-system)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vnonas@otenet.gr>) id 1JU7Gx-00025f-He
	for linux-dvb@linuxtv.org; Tue, 26 Feb 2008 22:23:35 +0100
Message-ID: <47C49F79.1080704@otenet.gr>
Date: Tue, 26 Feb 2008 23:23:37 +0000
From: Vangelis Nonas <vnonas@otenet.gr>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <32245669.2613.1203594791803.JavaMail.tomcat@dali.otenet.gr>	<47C01325.10407@otenet.gr>	<20080223174406.GB30387@moelleritberatung.de>	<47C0803D.2020504@gmail.com>	<20080223212013.GD30387@moelleritberatung.de>	<47C0903B.70606@gmail.com>	<20080223213258.GE30387@moelleritberatung.de>	<20080223214718.GF30387@moelleritberatung.de>	<47C09519.2090904@gmail.com>	<47C09BCC.50403@gmail.com>
	<47C0CADE.6040203@otenet.gr>	<47C0B1F9.1000609@gmail.com>
	<47C1764C.5070103@otenet.gr> <47C1AFC1.7050704@otenet.gr>
	<47C19735.4030601@gmail.com> <47C1D52B.6070906@otenet.gr>
	<47C1C55F.5030406@gmail.com> <47C32947.1030604@otenet.gr>
	<47C33CB1.1080502@gmail.com>
In-Reply-To: <47C33CB1.1080502@gmail.com>
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

Hello,

Here is the output of hg log|head -n 5 for two different directories 
(multiproto and multiproto_7200)

for multiproto:
changeset:   7205:9bdb997e38b5
tag:         tip
user:        Manu Abraham <manu@linuxtv.org>
date:        Sun Feb 24 02:10:56 2008 +0400
summary:     We can now reduce the debug levels, just need to look at 
errors only.

for multiproto_7200:
changeset:   7200:45eec532cefa
tag:         tip
parent:      7095:a577a5dbc93d
parent:      7199:0448e5a6d8a6
user:        Manu Abraham <manu@linuxtv.org>


So I guess I was referring to 7200 and not to 7201.
I am very positive about the results because I have tested it many 
times. It is just that it is 7200 instead of 7201.
So as a concluesion, 7200 behaves better than 7205. My corrected little 
table follows below just for clarification.

Changeset   Verbose  channels
--------------------------------
7200         1        2152
7200         2        2105
7200         5        2081
7205         1        1760
7205         2        1608
7205         5        1578


I apologise for the confusion, I may have caused.

Regards
Vagelis




Manu Abraham wrote:
> Vangelis Nonas wrote:
>> Hello,
>>
>> I have tested again changesets 7201 and 7205 with verbose 5, 2 and 1 
>> scanning 101 transponders on Hotbird (I attach my transponders file 
>> -- it is taken and adopted from ProgDvb).
>>
>> Here are my statistics:
>>
>> Changeset   Verbose  channels
>> --------------------------------
>> 7201         1        2152
>> 7201         2        2105
>> 7201         5        2081
>> 7205         1        1760
>> 7205         2        1608
>> 7205         5        1578
>
>
> Are you "really" sure that 7201 behaves better than others. I ask 
> this, since
> there was a bug in 7201 which caused many people not to have a LOCK, the
> bugs which was fixed in 7203 and 7204. I am at a loss now, as to
> understanding this strange phenomena, how a lock was achieved with no
> communication to the tuner.
>
> If it were 7200, i could have still believed, there was a possibility, 
> but 7201
> i am terribly confused.
>
> Can you please verify whether you didn't get mixed up with the changeset
> numbers or the logs that were produced ?
>
>
> Regards,
> Manu
>
>
> .
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
