Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from kane.otenet.gr ([195.170.0.77] ident=OTEnet-mail-system)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vnonas@otenet.gr>) id 1JTLhc-0006rU-HJ
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 19:35:56 +0100
Message-ID: <47C1D52B.6070906@otenet.gr>
Date: Sun, 24 Feb 2008 20:35:55 +0000
From: Vangelis Nonas <vnonas@otenet.gr>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <32245669.2613.1203594791803.JavaMail.tomcat@dali.otenet.gr>	<47C01325.10407@otenet.gr>	<20080223174406.GB30387@moelleritberatung.de>	<47C0803D.2020504@gmail.com>	<20080223212013.GD30387@moelleritberatung.de>	<47C0903B.70606@gmail.com>	<20080223213258.GE30387@moelleritberatung.de>	<20080223214718.GF30387@moelleritberatung.de>	<47C09519.2090904@gmail.com>	<47C09BCC.50403@gmail.com>
	<47C0CADE.6040203@otenet.gr>	<47C0B1F9.1000609@gmail.com>
	<47C1764C.5070103@otenet.gr> <47C1AFC1.7050704@otenet.gr>
	<47C19735.4030601@gmail.com>
In-Reply-To: <47C19735.4030601@gmail.com>
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

I scanned using 7205 changeset. With verbose=5, I get 1801 services. 
With verbose=2 I get 1725 services.

Using the 7201 changeset with verbose=5 I get 2082 services. I can check 
for verbose=2 and changeset 7201 if you think it is useful.

I have the "feeling" that 7201 behaves better. It is much faster also 
during scanning( I don't have measurements but I am pretty sure).

Should you need kernel logs for failing transponders either 7201 or 7205 
let me know.

Regards
Vagelis




Manu Abraham wrote:
> Vangelis Nonas wrote:
>> Hello,
>>
>> I tried scanning with the 7201 changeset and I believe the results 
>> are better than the 7205 changeset. In the former case I get 2082 
>> services on hotbird, in the latter 1722.
>>
>
> Hmm.. Ok.
>
> Can you please get 7205 and load the stb0899 and stb6100 modules with
> verbose=2 or 5 as module parameters and see whether it makes any 
> difference ?
> (ie you see more of the services) ie check whether changing the module 
> parameters
> (verbosity level) makes any difference in the number of services found.
>
>> I'll shortly send kernel logs for a failing transponder during scan.
>>
>> And something else:
>> When I give to scan the parameter -o vdr it will not output the 
>> results after a complete scan.
>
> Ok, this i had not added in, will look at this aspect.
>
> Regards,
> Manu
>
>
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
