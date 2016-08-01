Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36464 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbcHARRY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 13:17:24 -0400
Received: by mail-lf0-f67.google.com with SMTP id 33so8767770lfw.3
        for <linux-media@vger.kernel.org>; Mon, 01 Aug 2016 10:17:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160801165007.GL4605@ubuntu>
References: <CAJs94EbS7C+m_+P61QReAwn=93Yp0B7x4dZ32A8mMAZAM5+osQ@mail.gmail.com>
 <20160720141334.GC14569@uda0271908> <CAJs94Eb-Z4103JgEL6Xu_tesJ+d81F13UKhuCmVc3DPCBZ8z5w@mail.gmail.com>
 <20160720150614.GD14569@uda0271908> <CAJs94Eb42kTp0i=Oagip5uGtVTNh6JgoAp_q--+nNGZufD1chA@mail.gmail.com>
 <CAJs94EZt_gw=xenU8Yt79tZxT_jGUW7w1SQjjh2Oe9aCCXSm7A@mail.gmail.com>
 <CAJs94EYPwWivWfsrUtETJZp5HHmpT5Qvujq0RexcgHm+k657aQ@mail.gmail.com>
 <CAJs94Eb=iPC57N8ecvmOr__1LhTjFTuRtHd1svDbwgVXtYX5=g@mail.gmail.com>
 <CAJs94EYzTXJsr6vPw+MmtHUCzcoyxDmSmU-04YENP-9mZ5MdgA@mail.gmail.com>
 <CAJs94EbpTzpzDeubBGOaqPavwBHzgKhb9E0MN0_v_irWRRwJDQ@mail.gmail.com> <20160801165007.GL4605@ubuntu>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Mon, 1 Aug 2016 20:01:50 +0300
Message-ID: <CAJs94EZH-QbgHHo48=B2Uj6CP4t7F44CiUYSzf9=ENbOhzxALA@mail.gmail.com>
Subject: Re: pwc over musb: 100% frame drop (lost) on high resolution stream
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Bin Liu <b-liu@ti.com>, hdegoede@redhat.com,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-08-01 19:50 GMT+03:00 Viresh Kumar <viresh.kumar@linaro.org>:
> On 31-07-16, 23:31, Matwey V. Kornilov wrote:
>> Hello,
>>
>> I've also just found that the same commit breaks cpufreq on BeagleBone Black :)
>>
>> So, probably without HCD_BH flag musb works correctly only at 1Ghz CPU
>> frequency, which is unlisted and being set to 720Mhz by cpufreq driver
>> (as it did whet there was cpufreq driver).
>>
>> 2016-07-29 21:01 GMT+03:00 Matwey V. Kornilov <matwey@sai.msu.ru>:
>> > Hello,
>> >
>> > I've found that the following commit fixes the issue:
>> >
>> > commit 7694ca6e1d6f01122f05039b81f70f64b1ec4063
>> > Author: Viresh Kumar <viresh.kumar@linaro.org>
>> > Date:   Fri Apr 22 16:58:42 2016 +0530
>> >
>> >     cpufreq: omap: Use generic platdev driver
>> >
>> >     The cpufreq-dt-platdev driver supports creation of cpufreq-dt platform
>> >     device now, reuse that and remove similar code from platform code.
>
> Sorry for this commit and the man hours wasted to get to this :(
>
> I am trying to figure out why things break though, as this patch shouldn't have
> had any functional impacts. So, some of the assumptions I had are surely
> incorrect..

Actually, nothing to sorry about.
I suppose, that with this patch my BeagleBone run at 1Ghz after boot,
because usually cpufreq limits it to 720Mhz saying
[   14.255646] cpu cpu0: dev_pm_opp_set_rate: failed to find current
OPP for freq 1000000000 (-34)
And actually musb is still broken after f551e13529833e052f75ec628a8af7
(" Revert "usb: musb: musb_host")

>
> The defconfig linked in the original thread [1] has this:
>
> CONFIG_CPUFREQ_DT=m
>
> So, the cpufreq-dt module needs to get inserted to make it work.
>

It has been inserted automatically by alias `platform:cpufreq-dt'
Issue here that 4.7 stopped to provide `platfrom:cpufreq-dt' on BeagleBone.
Have you received my patch fixing it yet?

> Can someone provide the output of:
>
> cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver
>
> with and without this patch ?

With this patch, there is no cpufreq directory here.

Without this patch, the output is the following:

nohostname:~ # uname -a
Linux nohostname 4.6.4-3.gecd9058-default #1 SMP PREEMPT Fri Jul 15
08:08:50 UTC 2016 (ecd9058) armv7l armv7l armv7l GNU/Linux
nohostname:~ # cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver
cpufreq-dt

>
> It looks like we wanted to select "omap-cpufreq" for beaglebone and selected
> "cpufreq-dt" by mistake.

No, I am not sure, cpufreq-dt worked well until v4.7 where it is disappeared.

>
> [Note]: I am not subscribed to USB lists and so please include me for any emails
> you want my response on.
>
> --
> viresh
>
> [1] http://www.spinics.net/lists/linux-usb/msg143956.html
>
> --
> viresh
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
