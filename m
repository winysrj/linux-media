Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33138 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbcHAQ6v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 12:58:51 -0400
Received: by mail-pa0-f47.google.com with SMTP id b2so1793842pat.0
        for <linux-media@vger.kernel.org>; Mon, 01 Aug 2016 09:58:24 -0700 (PDT)
Date: Mon, 1 Aug 2016 09:50:07 -0700
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Cc: Bin Liu <b-liu@ti.com>, hdegoede@redhat.com,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: pwc over musb: 100% frame drop (lost) on high resolution stream
Message-ID: <20160801165007.GL4605@ubuntu>
References: <CAJs94EbS7C+m_+P61QReAwn=93Yp0B7x4dZ32A8mMAZAM5+osQ@mail.gmail.com>
 <20160720141334.GC14569@uda0271908>
 <CAJs94Eb-Z4103JgEL6Xu_tesJ+d81F13UKhuCmVc3DPCBZ8z5w@mail.gmail.com>
 <20160720150614.GD14569@uda0271908>
 <CAJs94Eb42kTp0i=Oagip5uGtVTNh6JgoAp_q--+nNGZufD1chA@mail.gmail.com>
 <CAJs94EZt_gw=xenU8Yt79tZxT_jGUW7w1SQjjh2Oe9aCCXSm7A@mail.gmail.com>
 <CAJs94EYPwWivWfsrUtETJZp5HHmpT5Qvujq0RexcgHm+k657aQ@mail.gmail.com>
 <CAJs94Eb=iPC57N8ecvmOr__1LhTjFTuRtHd1svDbwgVXtYX5=g@mail.gmail.com>
 <CAJs94EYzTXJsr6vPw+MmtHUCzcoyxDmSmU-04YENP-9mZ5MdgA@mail.gmail.com>
 <CAJs94EbpTzpzDeubBGOaqPavwBHzgKhb9E0MN0_v_irWRRwJDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJs94EbpTzpzDeubBGOaqPavwBHzgKhb9E0MN0_v_irWRRwJDQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31-07-16, 23:31, Matwey V. Kornilov wrote:
> Hello,
> 
> I've also just found that the same commit breaks cpufreq on BeagleBone Black :)
> 
> So, probably without HCD_BH flag musb works correctly only at 1Ghz CPU
> frequency, which is unlisted and being set to 720Mhz by cpufreq driver
> (as it did whet there was cpufreq driver).
> 
> 2016-07-29 21:01 GMT+03:00 Matwey V. Kornilov <matwey@sai.msu.ru>:
> > Hello,
> >
> > I've found that the following commit fixes the issue:
> >
> > commit 7694ca6e1d6f01122f05039b81f70f64b1ec4063
> > Author: Viresh Kumar <viresh.kumar@linaro.org>
> > Date:   Fri Apr 22 16:58:42 2016 +0530
> >
> >     cpufreq: omap: Use generic platdev driver
> >
> >     The cpufreq-dt-platdev driver supports creation of cpufreq-dt platform
> >     device now, reuse that and remove similar code from platform code.

Sorry for this commit and the man hours wasted to get to this :(

I am trying to figure out why things break though, as this patch shouldn't have
had any functional impacts. So, some of the assumptions I had are surely
incorrect..

The defconfig linked in the original thread [1] has this:

CONFIG_CPUFREQ_DT=m

So, the cpufreq-dt module needs to get inserted to make it work.

Can someone provide the output of:

cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver

with and without this patch ?

It looks like we wanted to select "omap-cpufreq" for beaglebone and selected
"cpufreq-dt" by mistake.

[Note]: I am not subscribed to USB lists and so please include me for any emails
you want my response on.

--
viresh

[1] http://www.spinics.net/lists/linux-usb/msg143956.html

-- 
viresh
