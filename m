Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:64433 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3FZMwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 08:52:22 -0400
Received: by mail-vc0-f182.google.com with SMTP id id13so1113453vcb.41
        for <linux-media@vger.kernel.org>; Wed, 26 Jun 2013 05:52:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <00ce01ce7246$12a7ff40$37f7fdc0$%debski@samsung.com>
References: <1372157835-27663-1-git-send-email-arun.kk@samsung.com>
	<1372157835-27663-5-git-send-email-arun.kk@samsung.com>
	<CAK9yfHy3uzCn0GhU6d5CcFLw=VXeHVZukJAK_cmgFkJG6iiGeA@mail.gmail.com>
	<CALt3h79G-rKqBXGwgbxKVXSt2ASQ0H603zkEZQekZSUPEs8D1A@mail.gmail.com>
	<CAK9yfHzno9FRM8vrX1OnLCLvbnB0MXeGo53duo1E6KJQ_DC+Pw@mail.gmail.com>
	<00ce01ce7246$12a7ff40$37f7fdc0$%debski@samsung.com>
Date: Wed, 26 Jun 2013 18:22:21 +0530
Message-ID: <CALt3h7_K6dgsUTLnN40ow2CsnvVkSHCQOm6RWYiuo2fF+WdxBg@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] [media] s5p-mfc: Core support for MFC v7
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
	Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>, jtp.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, avnd.kiran@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Wed, Jun 26, 2013 at 1:50 PM, Kamil Debski <k.debski@samsung.com> wrote:
> Hi,
>
>> -----Original Message-----
>> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
>> Sent: Wednesday, June 26, 2013 9:05 AM
>> To: Arun Kumar K
>> Cc: Arun Kumar K; LMML; Kamil Debski; jtp.park@samsung.com; Sylwester
>> Nawrocki; Hans Verkuil; avnd.kiran@samsung.com
>> Subject: Re: [PATCH v3 4/8] [media] s5p-mfc: Core support for MFC v7
>>
>> Hi Arun,
>>
>> On 26 June 2013 12:18, Arun Kumar K <arunkk.samsung@gmail.com> wrote:
>> > Hi Sachin,
>> >
>> > On Tue, Jun 25, 2013 at 4:54 PM, Sachin Kamat
>> <sachin.kamat@linaro.org> wrote:
>> >> Hi Arun,
>> >>
>> >>> @@ -684,5 +685,6 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx
>> *ctx);
>> >>>                                 (dev->variant->port_num ? 1 : 0) :
>> 0) : 0)
>> >>>  #define IS_TWOPORT(dev)                (dev->variant->port_num ==
>> 2 ? 1 : 0)
>> >>>  #define IS_MFCV6_PLUS(dev)     (dev->variant->version >= 0x60 ? 1 :
>> 0)
>> >>> +#define IS_MFCV7(dev)          (dev->variant->version >= 0x70 ? 1 :
>> 0)
>> >>
>> >> Considering the definition and pattern, wouldn't it be appropriate
>> to
>> >> call this  IS_MFCV7_PLUS?
>> >>
>> >
>> > We are still not sure about MFCv8 if it can re-use v7 stuff or not.
>> >
>>
>> OK. In that case probably we can restrict the definition to (dev-
>> >variant->version == 0x70 ? 1 : 0).
>>
>>
>
> Guys, I think that simple ((dev->variant->version & 0xF0) == 0x70) would
> cover
> every 7.x version. Same could apply to versions 6.x and 5.x.
> Then instead of using IS_MFCV6_PLUS(dev) one would use IS_MFCV6(dev) ||
> IS_MFCV7(dev).
> This is a bit longer, but if version 8 will be totally different from v7
> then it is
> much better to use v6||v7 instead of v6_plus.
>

If v8 was known to be different from v7, then we can go without second
thoughts about v6 || v7 check. But we cannot confirm that until v8 is
released. There is a good possibility of v6_plus macro holding good
for v8 also.
So as per current understanding, we can restrict v7 macro to only v7.x FW.
When v8 is released, we will change the name and usage of this macro if needed.
Is that ok?

Regards
Arun
