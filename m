Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61246 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0CRPMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 11:12:47 -0400
Received: by bwz1 with SMTP id 1so2140955bwz.21
        for <linux-media@vger.kernel.org>; Thu, 18 Mar 2010 08:12:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BA2419A.4070608@motama.com>
References: <4BA10639.3000407@motama.com> <4BA1F9C6.3020807@motama.com>
	 <829197381003180709t26f76b38y7e641b8c12a2d33d@mail.gmail.com>
	 <4BA2419A.4070608@motama.com>
Date: Thu, 18 Mar 2010 11:12:44 -0400
Message-ID: <829197381003180812n7dfe92e7v236e50d6ab7bdc0@mail.gmail.com>
Subject: Re: Problems with ngene based DVB cards (Digital Devices Cine S2 Dual
	DVB-S2 , Mystique SaTiX S2 Dual)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Marco Lohse <mlohse@motama.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 18, 2010 at 11:07 AM, Marco Lohse <mlohse@motama.com> wrote:
> Devin Heitmueller wrote:
>> On Thu, Mar 18, 2010 at 6:00 AM, Andreas Besse <besse@motama.com> wrote:
>>> Hello,
>>>
>>> We are now able to reproduce the problem faster and easier (using the
>>> patched version of szap-s2 and the scripts included in the tar.gz :
>>> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/17334
>>> and
>>> http://cache.gmane.org//gmane/linux/drivers/video-input-infrastructure/17334-001.bin
>>> )
>>
>> This is pretty interesting.  I'm doing some ngene work over the next
>> few weeks, so I will see if I can reproduce the behavior you are
>> seeing here.
>>
>> I noticed  that you are manually setting the "one_adapter=0" modprobe
>> setting.  Does this have any bearing on the test results?
>>
>
> I will try to answer this one:
>
> No, leaving out this parameter does not change the test results; you
> will only need to use different and additional parameters for szap-s2
> for specifying the correct adapter and sub-devices.
>
> By now, we also found out that the problems can be reproduced much easier:
>
> 0)
>
> szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 0 -n 1 -x |
> grep Delay
>
> Delay : 0.573021
>
> 1)
>
> szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 1 -n 1 -x |
> grep Delay
> Delay : 0.564667
>
> 2)
>
> szap-s2 -H -c channels_DVB-S2_transponder_switch.conf -a 0 -n 1 -x |
> grep Delay
> Delay : 1.741931
>
> Instead of 2) you can also run the included script
>
> 2')
>
> ./run_szap-s2_adapter0.sh
>
> which will result in the device timeout after 30-40 iterations
>
> To summarize
>
> => When opening and closing adapter0, then opening and closing devices
> of adapter1, this will immediately result in problems.
>
> And there a lot more variations of this bug, for example: actually read
> data from adapter0, tune adapter1 using szap-s2, which will result in
> adapter0 to be 'blocked' and not produce any more data after around 60 secs.
>
> We are currently trying to dig into the source code of the driver to
> solve the problems and would appreciate any help.

Hi Marco,

Ok, great.  Like I said, I will see if I can reproduce it here, as
that will help narrow down whether it's really an issue with the ngene
bridge, or whether it's got something to do with that particular
bridge/demod/tuner combination.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
