Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35642 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbcHASXY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 14:23:24 -0400
MIME-Version: 1.0
In-Reply-To: <20160801170613.GO4605@ubuntu>
References: <CAJs94Eb-Z4103JgEL6Xu_tesJ+d81F13UKhuCmVc3DPCBZ8z5w@mail.gmail.com>
 <20160720150614.GD14569@uda0271908> <CAJs94Eb42kTp0i=Oagip5uGtVTNh6JgoAp_q--+nNGZufD1chA@mail.gmail.com>
 <CAJs94EZt_gw=xenU8Yt79tZxT_jGUW7w1SQjjh2Oe9aCCXSm7A@mail.gmail.com>
 <CAJs94EYPwWivWfsrUtETJZp5HHmpT5Qvujq0RexcgHm+k657aQ@mail.gmail.com>
 <CAJs94Eb=iPC57N8ecvmOr__1LhTjFTuRtHd1svDbwgVXtYX5=g@mail.gmail.com>
 <CAJs94EYzTXJsr6vPw+MmtHUCzcoyxDmSmU-04YENP-9mZ5MdgA@mail.gmail.com>
 <CAJs94EbpTzpzDeubBGOaqPavwBHzgKhb9E0MN0_v_irWRRwJDQ@mail.gmail.com>
 <20160801165007.GL4605@ubuntu> <CAJs94EZH-QbgHHo48=B2Uj6CP4t7F44CiUYSzf9=ENbOhzxALA@mail.gmail.com>
 <20160801170613.GO4605@ubuntu>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Mon, 1 Aug 2016 21:11:23 +0300
Message-ID: <CAJs94EYqb=A8q88mHLPcyfZA_8D_-DZN1QyZ8DQ7nhmWCNK5eg@mail.gmail.com>
Subject: Re: pwc over musb: 100% frame drop (lost) on high resolution stream
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Bin Liu <b-liu@ti.com>, hdegoede@redhat.com,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-08-01 20:06 GMT+03:00 Viresh Kumar <viresh.kumar@linaro.org>:
> On 01-08-16, 20:01, Matwey V. Kornilov wrote:
>> With this patch, there is no cpufreq directory here.
>>
>> Without this patch, the output is the following:
>>
>> nohostname:~ # uname -a
>> Linux nohostname 4.6.4-3.gecd9058-default #1 SMP PREEMPT Fri Jul 15
>> 08:08:50 UTC 2016 (ecd9058) armv7l armv7l armv7l GNU/Linux
>> nohostname:~ # cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver
>> cpufreq-dt
>
> I hope that the below patch fixes it for you?
>

Yes, it is. Thank you.

> [PATCH] cpufreq: am33xx: Use generic platdev driver
>
> --
> viresh
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
