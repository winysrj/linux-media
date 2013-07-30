Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:64537 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3G3HhG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 03:37:06 -0400
Received: by mail-pd0-f173.google.com with SMTP id p11so2266331pdj.32
        for <linux-media@vger.kernel.org>; Tue, 30 Jul 2013 00:37:02 -0700 (PDT)
Date: Tue, 30 Jul 2013 16:36:52 +0900 (JST)
Message-Id: <20130730.163652.28831662.matsu@igel.co.jp>
To: g.liakhovetski@gmx.de
Cc: vladimir.barinov@cogentembedded.com, mchehab@redhat.com,
	linux-media@vger.kernel.org, magnus.damm@gmail.com,
	linux-sh@vger.kernel.org, phil.edworthy@renesas.com,
	sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v8] V4L2: soc_camera: Renesas R-Car VIN driver
From: Katsuya MATSUBARA <matsu@igel.co.jp>
In-Reply-To: <Pine.LNX.4.64.1307261310360.22137@axis700.grange>
References: <51F0CBF7.9080201@cogentembedded.com>
	<20130725.162922.274362407.matsu@igel.co.jp>
	<Pine.LNX.4.64.1307261310360.22137@axis700.grange>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Guennadi,

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Fri, 26 Jul 2013 13:11:52 +0200 (CEST)

> Hello Matsubara-san
> 
> On Thu, 25 Jul 2013, Katsuya MATSUBARA wrote:
> 
>> 
>>  Hi Vladimir,
>> 
>> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>> Date: Thu, 25 Jul 2013 10:55:51 +0400
>> 
>> > Hi  Matsubara-san,
>> > 
>> > On 07/25/2013 07:01 AM, Katsuya MATSUBARA wrote:
>> >>   Hi Vladimir,
>> >>
>> >>   Thank you for the revised patch.
>> >>
>> >> From: Sergei Shtylyov<sergei.shtylyov@cogentembedded.com>
>> >> Date: Sat, 20 Jul 2013 03:14:34 +0400
>> >>
>> >>> From: Vladimir Barinov<vladimir.barinov@cogentembedded.com>
>> >>>
>> >>> Add Renesas R-Car VIN (Video In) V4L2 driver.
>> >>>
>> >>> Based on the patch by Phil Edworthy<phil.edworthy@renesas.com>.
>> >>>
>> >>> Signed-off-by: Vladimir Barinov<vladimir.barinov@cogentembedded.com>
>> >>> [Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed
>> >>> 'enum chip_id'
>> >>> values, reordered rcar_vin_id_table[] entries, removed senseless
>> >>> parens from
>> >>> to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {}
>> >>> to the
>> >>> *if* statement and used 'bool' values instead of 0/1 where necessary,
>> >>> *removed
>> >>> unused macros, done some reformatting and clarified some comments.]
>> >>> Signed-off-by: Sergei Shtylyov<sergei.shtylyov@cogentembedded.com>
>> >>>
>> >>> ---
>> >>> This patch is against the 'media_tree.git' repo.
>> >>>
>> >>> Changes since version 7:
>> >>> - remove 'icd' field from 'struct rcar_vin_priv' in accordance with the
>> >>> - commit
>> >>>    f7f6ce2d09c86bd80ee11bd654a1ac1e8f5dfe13 ([media] soc-camera: move
>> >>>    common code
>> >>>    to soc_camera.c);
>> >>> - added mandatory clock_{start|stop}() methods in accordance with the
>> >>> - commit
>> >>>    a78fcc11264b824d9651b55abfeedd16d5cd8415 ([media] soc-camera: make
>> >>>    .clock_
>> >>>    {start,stop} compulsory, .add / .remove optional).
>> >> From: Vladimir Barinov<vladimir.barinov@cogentembedded.com>
>> >> Subject: Re: [PATCH v6] V4L2: soc_camera: Renesas R-Car VIN driver
>> >> Date: Sat, 22 Jun 2013 15:45:10 +0400
>> >>
>> >>>> But, captured images are still incorrect that means wrong
>> >>>> order of fields desite '_BT' chosen for V4L2_STD_525_60.
>> >>>>
>> >>> I've ordered the NTSC camera.
>> >>> I will return once I get it.
>> >>   Did you get an NTSC camera and see the field order issue
>> >>   occurs on your BOCK-W board?
>> > Yes I did.
>> >>   You may want to consider adding a workaround into
>> >>   the VIN driver if the issue remains in the latest patch.
>> > Have you seen this patch https://linuxtv.org/patch/19278/ ?
>> 
>> Oh, I missed the mail.
>> I tested it now and confirmed the issue has gone!
> 
> Does this mean I can add your Tested-by to v9 of this driver?

Sure.

Unfortunately my marzen board has gone from my office.
But I made sure that the v9 VIN driver and the fixed ml86v7667
sensor driver work fine on a BOCK-W board with a NTSC camera.

Tested-by: Katsuya MATSUBARA <matsu@igel.co.jp>

Thanks,
---
Katsuya Matsubara / IGEL Co. Ltd
matsu@igel.co.jp

