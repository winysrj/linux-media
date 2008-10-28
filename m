Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1.nijcomplesk5.nl ([83.172.148.40])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jean-paul@goedee.nl>) id 1Kun0S-0002nz-KN
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 12:45:05 +0100
Message-ID: <20081028124505.tvjko4bvkgk4kg4o@webmail.goedee.nl>
Date: Tue, 28 Oct 2008 12:45:05 +0100
From: jean-paul@goedee.nl
To: Manu Abraham <abraham.manu@gmail.com>
References: <20081028111538.1yl7p80uo0cggo80@webmail.goedee.nl>
	<4906E9CC.2040408@gmail.com>
In-Reply-To: <4906E9CC.2040408@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API & TT3200
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

Ok clone the repo and its compiling again. Thanx. Now I want to scan  
channels (scab-s2) on both lnb;s (astra 1 & 3). First transponder  
scans only 13 services and  Diseqc doesn?t work with the second lnb.

WARNING: >>> tuning failed!!!
>>> tune to: 11856:vS1C56:S23.5E:27500: (tuning failed)
DiSEqC: uncommitted switch pos 0
DiSEqC: switch pos 1, 13V, hiband (index 6)
DVB-S IF freq is 1256000
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.


Citeren Manu Abraham <abraham.manu@gmail.com>:

> jean-paul@goedee.nl wrote:
>> Ok again.
>>
>> I using now vdr 1.7.0 and multiproto from  manu to make my two tt
>> 3200-ci working with streamdev. Vdr zapper en MPC. Its working fine
>> except some judder  but its more a vdr issue.
>>
>> For now I have a development system with an TT 3200 to and try to let
>> vdr run with S2API drivers.  After getting the drivers from
>> http://mercurial.intuxication.org/hg/s2-liplianin/ the compile ends
>> with a error:
>
> You can simply clone http://jusst.de/hg/v4l-dvb
> or http://linuxtv.org/hg/v4l-dvb and check
>
> The former contains two more fixes, so better try to test with that.
>
> Regards,
> Manu
>




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
