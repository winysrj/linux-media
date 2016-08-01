Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:33417 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbcHARcm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 13:32:42 -0400
Received: by mail-pf0-f170.google.com with SMTP id y134so57320600pfg.0
        for <linux-media@vger.kernel.org>; Mon, 01 Aug 2016 10:32:35 -0700 (PDT)
Date: Mon, 1 Aug 2016 10:06:13 -0700
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Cc: Bin Liu <b-liu@ti.com>, hdegoede@redhat.com,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: pwc over musb: 100% frame drop (lost) on high resolution stream
Message-ID: <20160801170613.GO4605@ubuntu>
References: <CAJs94Eb-Z4103JgEL6Xu_tesJ+d81F13UKhuCmVc3DPCBZ8z5w@mail.gmail.com>
 <20160720150614.GD14569@uda0271908>
 <CAJs94Eb42kTp0i=Oagip5uGtVTNh6JgoAp_q--+nNGZufD1chA@mail.gmail.com>
 <CAJs94EZt_gw=xenU8Yt79tZxT_jGUW7w1SQjjh2Oe9aCCXSm7A@mail.gmail.com>
 <CAJs94EYPwWivWfsrUtETJZp5HHmpT5Qvujq0RexcgHm+k657aQ@mail.gmail.com>
 <CAJs94Eb=iPC57N8ecvmOr__1LhTjFTuRtHd1svDbwgVXtYX5=g@mail.gmail.com>
 <CAJs94EYzTXJsr6vPw+MmtHUCzcoyxDmSmU-04YENP-9mZ5MdgA@mail.gmail.com>
 <CAJs94EbpTzpzDeubBGOaqPavwBHzgKhb9E0MN0_v_irWRRwJDQ@mail.gmail.com>
 <20160801165007.GL4605@ubuntu>
 <CAJs94EZH-QbgHHo48=B2Uj6CP4t7F44CiUYSzf9=ENbOhzxALA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJs94EZH-QbgHHo48=B2Uj6CP4t7F44CiUYSzf9=ENbOhzxALA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01-08-16, 20:01, Matwey V. Kornilov wrote:
> With this patch, there is no cpufreq directory here.
> 
> Without this patch, the output is the following:
> 
> nohostname:~ # uname -a
> Linux nohostname 4.6.4-3.gecd9058-default #1 SMP PREEMPT Fri Jul 15
> 08:08:50 UTC 2016 (ecd9058) armv7l armv7l armv7l GNU/Linux
> nohostname:~ # cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver
> cpufreq-dt

I hope that the below patch fixes it for you?

[PATCH] cpufreq: am33xx: Use generic platdev driver

-- 
viresh
