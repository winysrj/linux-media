Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:51012 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3GXTk5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 15:40:57 -0400
Received: by mail-la0-f45.google.com with SMTP id ev20so667087lab.18
        for <linux-media@vger.kernel.org>; Wed, 24 Jul 2013 12:40:56 -0700 (PDT)
Message-ID: <51F02DC3.4050204@cogentembedded.com>
Date: Wed, 24 Jul 2013 23:40:51 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v8] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201307200314.35345.sergei.shtylyov@cogentembedded.com> <Pine.LNX.4.64.1307241731560.2179@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1307241731560.2179@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 07/24/2013 08:14 PM, Guennadi Liakhovetski wrote:

>> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

>> Add Renesas R-Car VIN (Video In) V4L2 driver.

>> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.

>> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>> [Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed 'enum chip_id'
>> values, reordered rcar_vin_id_table[] entries,  removed senseless parens from
>> to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {} to the
>> *if* statement  and used 'bool' values instead of 0/1 where necessary, removed
>> unused macros, done some reformatting and clarified some comments.]
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

>> ---
>> This patch is against the 'media_tree.git' repo.

>> Changes since version 7:
>> - remove 'icd' field from 'struct rcar_vin_priv' in accordance with the commit
>>    f7f6ce2d09c86bd80ee11bd654a1ac1e8f5dfe13 ([media] soc-camera: move common code
>>    to soc_camera.c);
>> - added mandatory clock_{start|stop}() methods in accordance with the commit
>>    a78fcc11264b824d9651b55abfeedd16d5cd8415 ([media] soc-camera: make .clock_
>>    {start,stop} compulsory, .add / .remove optional).

>> Changes since version 6:
>> - sorted #include's alphabetically once again;
>> - BUG() on invalid format in rcar_vin_setup();

> No, please don't. I think I commented on the use of BUG() in this driver
> already. It shall only be used if the machine cannot continue to run. I
> don't think this is the sace here.

    Note that sh_mobile_ceu_camera.c has BUG() in almost the same case.

WBR, Sergei

