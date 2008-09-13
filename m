Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1Keea6-0001NK-Fg
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 01:31:11 +0200
Message-ID: <48CC4D35.3000003@gmail.com>
Date: Sun, 14 Sep 2008 03:31:01 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>	
	<48C66829.1010902@grumpydevil.homelinux.org>	
	<d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>	
	<48CC42D8.8080806@gmail.com>
	<d9def9db0809131556i6f0d07aci49ab288df38a8d5e@mail.gmail.com>
In-Reply-To: <d9def9db0809131556i6f0d07aci49ab288df38a8d5e@mail.gmail.com>
Cc: linux-dvb@linuxtv.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

Markus Rechberger wrote:
> On Sun, Sep 14, 2008 at 12:46 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> Markus Rechberger wrote:
>>
>>> How many devices are currently supported by the multiproto API
>>> compared with the s2 tree?
>> The initial set of DVB-S2 multistandard devices supported by the
>> multiproto tree is follows. This is just the stb0899 based dvb-s2 driver
>> alone. There are more additions by 2 more modules (not devices), but for
>> the simple comparison here is the quick list of them, for which some of
>> the manufacturers have shown support in some way. (There has been quite
>> some contributions from the community as well.):
>>
>> (Also to be noted is that, some BSD chaps also have shown interest in
>> the same)
>>
> 
> they're heavy into moving the whole framework over as far as I've seen
> yes, also including yet unmerged drivers.


Using the same interface, the same applications will work there as well
which is a bonus, but isn't the existing user interface GPL ? (A bit
confused on that aspect)


>> * STB0899 based
>>
>> Anubis
>> Typhoon DVB-S2 PCI
>>
>> Azurewave/Twinhan
>> VP-1041
>> VP-7050
>>
>> Digital Now
>> AD SP400
>> AD SB300
>>
>> KNC1
>> TV Station DVB-S2
>> TV Station DVB-S2 Plus
>>
>> Pinnacle
>> PCTV Sat HDTV Pro USB 452e
>>
>> Satelco
>> TV Station DVB-S2
>> Easywatch HDTV USB CI
>> Easywatch HDTV PCI
>>
>> Technisat
>> Skystar HD
>> Skystar HD2
>> Skystar USB2 HDCI
>>
>> Technotrend
>> TT S2 3200
>> TT S2 3600
>> TT S2 3650
>>
>> Terratec
>> Cinergy S2 PCI HD
>> Cinergy S2 PCI HDCI
>>
> 
> those are pullable now against the current tree?


These devices, depend upon the DVB API update without which it wouldn't
work as they depend heavily on the DVB API framework. Without the
updated framework, it doesn't make any sense to pull them: they won't
even compile. The last but not least reason is that, the stb0899 driver
is a DVB-S2 multistandard device which requires DVB-S2/DSS support
additionally.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
