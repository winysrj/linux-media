Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:64045 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3GYDBq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 23:01:46 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb10so911084pad.9
        for <linux-media@vger.kernel.org>; Wed, 24 Jul 2013 20:01:45 -0700 (PDT)
Date: Thu, 25 Jul 2013 12:01:13 +0900 (JST)
Message-Id: <20130725.120113.75189051.matsu@igel.co.jp>
To: vladimir.barinov@cogentembedded.com
Cc: g.liakhovetski@gmx.de, mchehab@redhat.com,
	linux-media@vger.kernel.org, magnus.damm@gmail.com,
	linux-sh@vger.kernel.org, phil.edworthy@renesas.com,
	sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v8] V4L2: soc_camera: Renesas R-Car VIN driver
From: Katsuya MATSUBARA <matsu@igel.co.jp>
In-Reply-To: <201307200314.35345.sergei.shtylyov@cogentembedded.com>
	<51C58E46.6000801@cogentembedded.com>
References: <201307200314.35345.sergei.shtylyov@cogentembedded.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


 Hi Vladimir,

 Thank you for the revised patch.

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Sat, 20 Jul 2013 03:14:34 +0400

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> 
> Add Renesas R-Car VIN (Video In) V4L2 driver.
> 
> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.
> 
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> [Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed 'enum chip_id'
> values, reordered rcar_vin_id_table[] entries,  removed senseless parens from
> to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {} to the
> *if* statement  and used 'bool' values instead of 0/1 where necessary, removed
> unused macros, done some reformatting and clarified some comments.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo.
> 
> Changes since version 7:
> - remove 'icd' field from 'struct rcar_vin_priv' in accordance with the commit
>   f7f6ce2d09c86bd80ee11bd654a1ac1e8f5dfe13 ([media] soc-camera: move common code
>   to soc_camera.c);
> - added mandatory clock_{start|stop}() methods in accordance with the commit
>   a78fcc11264b824d9651b55abfeedd16d5cd8415 ([media] soc-camera: make .clock_
>   {start,stop} compulsory, .add / .remove optional).

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Subject: Re: [PATCH v6] V4L2: soc_camera: Renesas R-Car VIN driver
Date: Sat, 22 Jun 2013 15:45:10 +0400

>> But, captured images are still incorrect that means wrong
>> order of fields desite '_BT' chosen for V4L2_STD_525_60.
>>   
> I've ordered the NTSC camera.
> I will return once I get it.

 Did you get an NTSC camera and see the field order issue
 occurs on your BOCK-W board?
 You may want to consider adding a workaround into
 the VIN driver if the issue remains in the latest patch.

 Thanks,
---
 Katsuya Matsubara / IGEL Co., Ltd
 matsu@igel.co.jp
