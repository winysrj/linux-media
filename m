Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:45601 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755048AbdLOMjl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 07:39:41 -0500
Received: by mail-lf0-f68.google.com with SMTP id f13so10287835lff.12
        for <linux-media@vger.kernel.org>; Fri, 15 Dec 2017 04:39:41 -0800 (PST)
Subject: Re: [GIT PULL FOR v4.16] staging/media: add NVIDIA Tegra video
 decoder driver
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <27cd85c2-4e27-707d-6b94-bfad274d1806@xs4all.nl>
 <20171214090612.14aa5696@vento.lan>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <27ac2380-cab4-8d7e-63ed-20d9f77afc4b@gmail.com>
Date: Fri, 15 Dec 2017 15:39:37 +0300
MIME-Version: 1.0
In-Reply-To: <20171214090612.14aa5696@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14.12.2017 14:06, Mauro Carvalho Chehab wrote:
> Em Tue, 12 Dec 2017 16:28:40 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> This adds a new NVIDIA Tegra video decoder driver. It is depending on the
>> request API work since it is a stateless codec, so for now park this in staging.
>>
>> The dts patches should go through nvidia's tree.
>>
>> Regards,
>>
>> 	Hans
>>
>> The following changes since commit 330dada5957e3ca0c8811b14c45e3ac42c694651:
>>
>>   media: dvb_frontend: fix return error code (2017-12-12 07:50:14 -0500)
>>
>> are available in the Git repository at:
>>
>>   git://linuxtv.org/hverkuil/media_tree.git tegradec
>>
>> for you to fetch changes up to c3c530f45e48b33a2cc49cdeec246d255a5ca7db:
>>
>>   staging: media: Introduce NVIDIA Tegra video decoder driver (2017-12-12 16:06:06 +0100)
>>
>> ----------------------------------------------------------------
>> Dmitry Osipenko (2):
>>       media: dt: bindings: Add binding for NVIDIA Tegra Video Decoder Engine
>>       staging: media: Introduce NVIDIA Tegra video decoder driver
> 
> Ok, clearly, there are some things that are not OK on the driver,
> otherwise, it won't be merging at staging. Yet, there warnings
> there that should be considered before moving it out of staging:

Sure, I'm aware of the checkpatch warnings and some of them aren't legit, others
aren't very important and would be corrected later. The main reason of going
into staging should be the lack of V4L2 interface support in the driver
(necessary V4L API isn't there yet), see TODO. Certainly there are other things
to be done besides the V4L interface before de-staging, going into staging is a
very good variant right now, thanks for allowing to do it!

[snip]
