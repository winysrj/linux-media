Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:62830 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbbAPQsc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 11:48:32 -0500
Received: by mail-ob0-f177.google.com with SMTP id uy5so19320694obc.8
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 08:48:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54B93A49.1010108@apollo.lv>
References: <54B52548.7010109@xs4all.nl>
	<54B55C23.1070409@apollo.lv>
	<54B92620.6020408@xs4all.nl>
	<54B93A49.1010108@apollo.lv>
Date: Fri, 16 Jan 2015 16:48:31 +0000
Message-ID: <CAGj5WxAyS1x+J4WcyBv4GawqUK3DYdFWzStYUbq3CSLjFtByDg@mail.gmail.com>
Subject: Re: [PATCH] cx23885/vb2 regression: please test this patch
From: Luis Alves <ljalvs@gmail.com>
To: Raimonds Cicans <ray@apollo.lv>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>, gtmkramer@xs4all.nl
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

There is another guy having issues with TBS8820 card (uses cx88 and cx24116)

His syslog:
http://paste.ubuntu.com/9284564/

The stackdump makes me believe that the issue also appeared since
"[media] cx88: convert to vb2"
(still to confirm)

Regards,
Luis


On Fri, Jan 16, 2015 at 4:20 PM, Raimonds Cicans <ray@apollo.lv> wrote:
> On 16.01.2015 16:54, Hans Verkuil wrote:
>>
>> On 01/13/2015 06:55 PM, Raimonds Cicans wrote:
>>>
>>> On 13.01.2015 16:01, Hans Verkuil wrote:
>>>>
>>>> Can you both test this patch? It should (I hope) solve the problems you
>>>> both had with the cx23885 driver.
>>>>
>> Can you check that the function cx23885_risc_field in
>> drivers/media/pci/cx23885/cx23885-core.c uses "sg = sg_next(sg);"
>> instead of "sg++;"?
>
> There is no sg++ in whole drivers/media/pci/cx23885/ directory.
>>
>> To avoid confusion I would prefer that you test with a 3.18 or higher
>> kernel
>> and please state which kernel version you use and whether you used the
>> media_build system or a specific git repo to build the drivers.
>
> kernel: Gentoo Hardened kernel 3.18.1 (hardened part turned off)
> media_build: pure original media_build
> media tree: https://github.com/ljalves/linux_media (original linux-media
> plus some
> new out of kernel TBS drivers (from this tree I need TBS6285 driver))
>>
>> I'm also interested if you can reproduce it using just command-line tools
>> (and let me know what it is you do).
>
> For tests I use only command line tools: w_scan & dvb-fe-tool
>
> Tests:
> 1) w_scan on first front end then after 5-10 seconds w_scan on other
> 2) w_scan on second front end then after 5-10 seconds w_scan on first
> 3) "dvb-fe-tool -d DVBS" on first front end then after 5-10 seconds w_scan
> on second front end then after 5-10 seconds w_scan on first
> 4) "dvb-fe-tool -d DVBS" on second front end then after 5-10 seconds w_scan
> on first front end then after 5-10 seconds w_scan on second
>
> w_scan run on both front ends simultaneously.
>
>
>> Use only one DVB adapter, not both.
>
> Do you mean one card or one front end?
>
>
>
> Raimonds Cicans
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
