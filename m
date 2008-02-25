Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from kane.otenet.gr ([195.170.0.77] ident=OTEnet-mail-system)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vnonas@otenet.gr>) id 1JTixy-0007AC-Qo
	for linux-dvb@linuxtv.org; Mon, 25 Feb 2008 20:26:23 +0100
Message-ID: <47C3327E.8040609@otenet.gr>
Date: Mon, 25 Feb 2008 21:26:22 +0000
From: Vangelis Nonas <vnonas@otenet.gr>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <32245669.2613.1203594791803.JavaMail.tomcat@dali.otenet.gr>	<47C01325.10407@otenet.gr>	<20080223174406.GB30387@moelleritberatung.de>	<47C0803D.2020504@gmail.com>	<20080223212013.GD30387@moelleritberatung.de>	<47C0903B.70606@gmail.com>	<20080223213258.GE30387@moelleritberatung.de>	<20080223214718.GF30387@moelleritberatung.de>	<47C09519.2090904@gmail.com>	<47C09BCC.50403@gmail.com>
	<47C0CADE.6040203@otenet.gr>	<47C0B1F9.1000609@gmail.com>
	<47C1764C.5070103@otenet.gr> <47C1AFC1.7050704@otenet.gr>
	<47C19735.4030601@gmail.com> <47C1D52B.6070906@otenet.gr>
	<47C1C55F.5030406@gmail.com>
In-Reply-To: <47C1C55F.5030406@gmail.com>
Content-Type: multipart/mixed; boundary="------------000107070705020009030408"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechniSat SkyStar HD: Problems scaning and zaping
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------000107070705020009030408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have tested again changesets 7201 and 7205 with verbose 5, 2 and 1 
scanning 101 transponders on Hotbird (I attach my transponders file -- 
it is taken and adopted from ProgDvb).

Here are my statistics:

Changeset   Verbose  channels
--------------------------------
7201         1        2152
7201         2        2105
7201         5        2081
7205         1        1760
7205         2        1608
7205         5        1578


It is very strange that using the 7205 changeset (all verbose) Zagros TV 
for instance and all other channels on transponder
S 11727000 V 27500000 3/4
are NOT found.
But if you try and scan with a transponder file containing just a single 
line for the failing transponder it works correctly!!! (again 7205 
changeset and all verbose).

Moreover, I have noticed that when you scan a single transponder and you 
have placed only one entry in the transponders file, the program (scan) 
actually scans more than one, often many transponders. Is it normal? I 
thought scan only checks the transponders it finds in the file.

Anyway I attach the kernel log of scanning this transponder:
S 10758000 V 27500000 3/4
The transponder itself does not fail, but other transponders it "jumps 
to" fail. The log was taken with change set 7205 and verbose 5. It is 
1.5MB, I hope Manu got it at his private email.


Regards
Vagelis



Manu Abraham wrote:
> Vangelis Nonas wrote:
>> Hello,
>>
>> I scanned using 7205 changeset. With verbose=5, I get 1801 services. 
>> With verbose=2 I get 1725 services.
>>
>> Using the 7201 changeset with verbose=5 I get 2082 services. I can 
>> check for verbose=2 and changeset 7201 if you think it is useful.
>
> It would be nice to see changeset 7201 with verbose=1 and 2, the results.
>
>> I have the "feeling" that 7201 behaves better. It is much faster also 
>> during scanning( I don't have measurements but I am pretty sure).
>
> You can enable timestamps being output in printk's in the kernel config
> to see the timestamps, with which you compare with the start - stop
> events in the logs.
>
>> Should you need kernel logs for failing transponders either 7201 or 
>> 7205 let me know.
>
> Will need the logs for the failing transponders in 7205, to check for the
> actual cause.
>
>
> Regards,
> Manu
>
>>
>> Regards
>> Vagelis
>>
>>
>>
>>
>> Manu Abraham wrote:
>>> Vangelis Nonas wrote:
>>>> Hello,
>>>>
>>>> I tried scanning with the 7201 changeset and I believe the results 
>>>> are better than the 7205 changeset. In the former case I get 2082 
>>>> services on hotbird, in the latter 1722.
>>>>
>>>
>>> Hmm.. Ok.
>>>
>>> Can you please get 7205 and load the stb0899 and stb6100 modules with
>>> verbose=2 or 5 as module parameters and see whether it makes any 
>>> difference ?
>>> (ie you see more of the services) ie check whether changing the 
>>> module parameters
>>> (verbosity level) makes any difference in the number of services found.
>>>
>>>> I'll shortly send kernel logs for a failing transponder during scan.
>>>>
>>>> And something else:
>>>> When I give to scan the parameter -o vdr it will not output the 
>>>> results after a complete scan.
>>>
>>> Ok, this i had not added in, will look at this aspect.
>>>
>>> Regards,
>>> Manu
>>>
>>>
>>>
>>
>>
>
>
> .
>


--------------000107070705020009030408
Content-Type: text/plain;
 name="Hotbird"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Hotbird"

S 10719000 V 27500000 3/4
S 10723000 H 29900000 3/4
S 10758000 V 27500000 3/4
S 10775000 H 28000000 3/4
S 10796000 V 27500000 3/4
S 10830000 H 3333000 3/4
S 10834000 V 27500000 3/4
S 10853000 H 27500000 3/4
S 10873000 V 27500000 3/4
S 10892000 H 27500000 3/4
S 10911000 V 27500000 3/4
S 10930000 H 27500000 3/4
S 10949000 V 27500000 3/4
S 10971000 H 27500000 3/4
S 10992000 V 27500000 2/3
S 11013000 H 27500000 3/4
S 11034000 V 27500000 3/4
S 11054000 H 27500000 5/6
S 11075000 V 27500000 3/4
S 11096000 H 28000000 3/4
S 11117000 V 27500000 3/4
S 11137000 H 27500000 3/4
S 11158000 V 27500000 3/4
S 11179000 H 27500000 3/4
S 11200000 V 27500000 5/6
S 11219000 H 27500000 3/4
S 11240000 V 27500000 3/4
S 11258000 H 27500000 2/3
S 11278000 V 27500000 3/4
S 11296000 H 27500000 3/4
S 11334000 H 27500000 1/2
S 11355000 V 27500000 3/4
S 11373000 H 19636000 2/3
S 11393000 V 27500000 3/4
S 11411000 H 27500000 5/6
S 11432000 V 27500000 1/2
S 11449000 H 27500000 2/3
S 11470000 V 27500000 5/6
S 11488000 H 27500000 3/4
S 11523000 V 5000000 7/8
S 11526000 H 27500000 3/4
S 11541000 V 22000000 5/6
S 11566000 H 27500000 3/4
S 11585000 V 27500000 3/4
S 11604000 H 27500000 5/6
S 11623000 V 27500000 3/4
S 11642000 H 27500000 3/4
S 11662000 V 27500000 3/4
S 11681000 H 27500000 3/4
S 11727000 V 27500000 3/4
S 11747000 H 27500000 3/4
S 11766000 V 27500000 2/3
S 11785000 H 27500000 3/4
S 11804000 V 27500000 2/3
S 11823000 H 27500000 3/4
S 11843000 V 27500000 3/4
S 11862000 H 27500000 3/4
S 11881000 V 27500000 3/4
S 11900000 H 27500000 3/4
S 11919000 V 27500000 2/3
S 11938000 H 27500000 3/4
S 11958000 V 27500000 3/4
S 11977000 H 27500000 3/4
S 11996000 V 27500000 2/3
S 12015000 H 27500000 3/4
S 12034000 V 27500000 3/4
S 12054000 H 27500000 3/4
S 12073000 V 27500000 3/4
S 12092000 H 27500000 3/4
S 12111000 V 27500000 3/4
S 12145000 H 3333000 3/4
S 12149000 V 27500000 3/4
S 12169000 H 27500000 3/4
S 12188000 V 27500000 3/4
S 12207000 H 27500000 3/4
S 12226000 V 27500000 3/4
S 12245000 H 27500000 3/4
S 12265000 V 27500000 2/3
S 12284000 H 27500000 3/4
S 12303000 V 27500000 3/4
S 12322000 H 27500000 3/4
S 12341000 V 27500000 3/4
S 12360000 H 27500000 3/4
S 12380000 V 27500000 3/4
S 12399000 H 27500000 3/4
S 12418000 V 27500000 3/4
S 12437000 H 27500000 3/4
S 12466000 V 27500000 3/4
S 12476000 H 27500000 3/4
S 12520000 V 27500000 3/4
S 12539000 H 27500000 3/4
S 12558000 V 27500000 3/4
S 12577000 H 27500000 3/4
S 12597000 V 27500000 3/4
S 12616000 H 27500000 3/4
S 12635000 V 27500000 3/4
S 12654000 H 27500000 3/4
S 12673000 V 27500000 3/4
S 12692000 H 27500000 3/4
S 12713000 V 27500000 3/4
S 12731000 H 27500000 3/4

--------------000107070705020009030408
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------000107070705020009030408--
