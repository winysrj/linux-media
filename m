Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:42544 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945946Ab3FUUIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 16:08:42 -0400
Received: by mail-la0-f45.google.com with SMTP id fr10so7878963lab.18
        for <linux-media@vger.kernel.org>; Fri, 21 Jun 2013 13:08:40 -0700 (PDT)
Message-ID: <51C4B2CD.2030302@cogentembedded.com>
Date: Sat, 22 Jun 2013 00:08:45 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v6] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201305240211.29665.sergei.shtylyov@cogentembedded.com> <Pine.LNX.4.64.1306131245420.31976@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1306131245420.31976@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 06/13/2013 05:12 PM, Guennadi Liakhovetski wrote:

> Hi Sergei

> Patches, that this commit is based upon are hopefully moving towards the
> mainline, but it's still possible, that some more changes will be
> required. In any case, I wanted to comment to this version to let you
> prepare for a new version in advance.

> In general - looks better!

>> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

>> Add Renesas R-Car VIN (Video In) V4L2 driver.

>> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.

>> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>> [Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed 'enum chip_id'
>> values, reordered rcar_vin_id_table[] entries,  removed senseless parens from
>> to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {} to the
>> *if* statement  and  used 'bool' values instead of 0/1 where necessary, removed
>> unused macros, done some reformatting and clarified some comments.]
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

>> ---

> [snip]

>> Index: media_tree/drivers/media/platform/soc_camera/rcar_vin.c
>> ===================================================================
>> --- /dev/null
>> +++ media_tree/drivers/media/platform/soc_camera/rcar_vin.c
[...]
>> +static irqreturn_t rcar_vin_irq(int irq, void *data)
>> +{
[...]
>> +		if (hw_stopped || !can_run) {
>> +			priv->state = STOPPED;
>> +		} else if (is_continuous_transfer(priv) &&
>> +			   list_empty(&priv->capture) &&
>> +			   priv->state == RUNNING) {
>> +			/*
>> +			 * The continuous capturing requires an explicit stop
>> +			 * operation when there is no buffer to be set into
>> +			 * the VnMBm registers.
>> +			 */
>> +			rcar_vin_request_capture_stop(priv);
>> +		} else {
>> +			rcar_vin_capture(priv);
>> +		}

> You don't need braces here

    Did you mean only *else* branch or the whole *if statement? In both 
cases, I disagree. Removing {} only from *else* contradicts do 
Documenation/CodingStyle, removing them from the *if* branch too also 
don't appeal to me as due to the comment inside the *if* branch. Sorry, 
I'm leaving this as is.

WBR, Sergei

