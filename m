Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JUVFZ-00037l-EW
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 23:59:45 +0100
Message-ID: <47C5EB57.7000903@gmail.com>
Date: Thu, 28 Feb 2008 02:59:35 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: "Oliver Bardenheier (obardenh)" <obardenh@cisco.com>
References: <32245669.2613.1203594791803.JavaMail.tomcat@dali.otenet.gr>	<47C01325.10407@otenet.gr>	<20080223174406.GB30387@moelleritberatung.de>	<47C0803D.2020504@gmail.com>	<20080223212013.GD30387@moelleritberatung.de>	<47C0903B.70606@gmail.com>	<20080223213258.GE30387@moelleritberatung.de>	<20080223214718.GF30387@moelleritberatung.de>	<47C09519.2090904@gmail.com>	<47C09BCC.50403@gmail.com><47C0CADE.6040203@otenet.gr>	<47C0B1F9.1000609@gmail.com><47C1764C.5070103@otenet.gr>
	<47C1AFC1.7050704@otenet.gr><47C19735.4030601@gmail.com>
	<47C1D52B.6070906@otenet.gr><47C1C55F.5030406@gmail.com>
	<47C32947.1030604@otenet.gr><47C33CB1.1080502@gmail.com>
	<47C49F79.1080704@otenet.gr> <47C48845.4030808@gmail.com>
	<7FA4B8777C810C4B8F3ABBB47DF0F375064C4A7B@xmb-ams-332.emea.cisco.com>
In-Reply-To: <7FA4B8777C810C4B8F3ABBB47DF0F375064C4A7B@xmb-ams-332.emea.cisco.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] STB0899 users,
 please verify results was Re: TechniSat SkyStar HD: Problems
 scaning and zaping
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

Oliver Bardenheier (obardenh) wrote:
> I can confirm that current hg-tree breaks SkyStarHD. Mostly unusable,
> many transponders not working.
> I changed back to  45eec532cefa  and everything is working fine.
> 


Thanks for the verification.


Regards,
Manu

> regards
> Oliver
> 
> -----Original Message-----
> From: linux-dvb-bounces@linuxtv.org
> [mailto:linux-dvb-bounces@linuxtv.org] On Behalf Of Manu Abraham
> Sent: Dienstag, 26. Februar 2008 22:45
> To: linux-dvb@linuxtv.org
> Subject: [linux-dvb] STB0899 users, please verify results was Re:
> TechniSat SkyStar HD: Problems scaning and zaping
> 
> Vangelis Nonas wrote:
>> Hello,
>>
>> Here is the output of hg log|head -n 5 for two different directories 
>> (multiproto and multiproto_7200)
>>
>> for multiproto:
>> changeset:   7205:9bdb997e38b5
>> tag:         tip
>> user:        Manu Abraham <manu@linuxtv.org>
>> date:        Sun Feb 24 02:10:56 2008 +0400
>> summary:     We can now reduce the debug levels, just need to look at 
>> errors only.
>>
>> for multiproto_7200:
>> changeset:   7200:45eec532cefa
>> tag:         tip
>> parent:      7095:a577a5dbc93d
>> parent:      7199:0448e5a6d8a6
>> user:        Manu Abraham <manu@linuxtv.org>
>>
>>
>> So I guess I was referring to 7200 and not to 7201.
>> I am very positive about the results because I have tested it many 
>> times. It is just that it is 7200 instead of 7201.
>> So as a concluesion, 7200 behaves better than 7205. My corrected 
>> little table follows below just for clarification.
> 
> 
> Ok, fine this is very much possible. Can other STB0899 users (all of
> them) verify this result, such that i can revert back the changes ?
> 
> 
>> Changeset   Verbose  channels
>> --------------------------------
>> 7200         1        2152
>> 7200         2        2105
>> 7200         5        2081
>> 7205         1        1760
>> 7205         2        1608
>> 7205         5        1578
>>
>>
>> I apologise for the confusion, I may have caused.
> 
> No worries, don't apologise, this is all a part of the testing phase.
> 
> 
> Thanks,
> Manu
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
