Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dirk@brenken.org>) id 1JLeFj-0007Ry-BF
	for linux-dvb@linuxtv.org; Sun, 03 Feb 2008 13:47:19 +0100
Message-ID: <47A5B7B9.1050605@brenken.org>
Date: Sun, 03 Feb 2008 13:46:49 +0100
From: Dirk Brenken <dirk@brenken.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47A360FE.2070105@brenken.org>
	<200802030314.22178@orion.escape-edv.de>
In-Reply-To: <200802030314.22178@orion.escape-edv.de>
Subject: Re: [linux-dvb] TT-1401 budget card support broken since 2.6.24-rc6
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Oliver,
I've revoked the changes of the patch you've mentioned below on a plain 
vanilla 2.6.24 kernel - and it works! ;-)

If I should do more testing on this issue, please advice ...

Thanks
Dirk

Oliver Endriss schrieb:
> Dirk Brenken wrote:
>> Hi,
>> I'm running a "budget-only" (Technotrend S-1401) vdr system (1.5.13) 
>> with xinelibouput plugin (latest cvs checkout).  It's based on debian 
>> sid and it runs fine with kernel 2.6.23.14 ... up to kernel 2.6.24-rc5. 
>> After that version, my budget card system stops working ... here some 
>> log file stuff:
>>
>> ...
>>
>> The problem also occurs with kernel 2.6.23.14 plus latest v4l-dvb 
>> checkout. Any idea how to track down this error? Any help is appreciated!
> 
> Could you please check whether patch
>     http://linuxtv.org/hg/v4l-dvb/rev/816f256c2973
> broke the driver?
> 
> CU
> Oliver
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
