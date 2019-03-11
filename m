Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A102C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71787206BA
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfCKOZk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:25:40 -0400
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:38202 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726897AbfCKOZk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 10:25:40 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 3LrwhRzi14HFn3LrzhEsUF; Mon, 11 Mar 2019 15:25:38 +0100
Subject: Re: [PATCH] media: atmel: atmel-isc: reworked driver and formats
To:     Ken Sloat <KSloat@aampglobal.com>,
        "Eugen.Hristev@microchip.com" <Eugen.Hristev@microchip.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
References: <1550219467-9532-1-git-send-email-eugen.hristev@microchip.com>
 <BL0PR07MB4115ECEE3BED0B46C342F4A9AD630@BL0PR07MB4115.namprd07.prod.outlook.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <805728da-29ac-bf4b-ad61-95bc71036e23@xs4all.nl>
Date:   Mon, 11 Mar 2019 15:25:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <BL0PR07MB4115ECEE3BED0B46C342F4A9AD630@BL0PR07MB4115.namprd07.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKz+PTmhN7YIqOrPP4/Zfo/kjOxLAEE703kNnB05PmljFNMJTZzoz64P3RPt+cJkmvSCDKra8W4/DrpowR03KIfjMsw83SyHmdJ3RMY9y10UmWrnQLS3
 /MT9dW24y3mS2TsPJ96Bye4j1Hx5beBgHaLdEtdLzpfEUj0zpFI4UWhqddlGWgxmNblEyoFEO89XjuUcbUxfoDhyQ4n/IAARYONmC7uZ3M8vkXg48Vqdqj8X
 ydQUEW/1/qear9bIdRHRxV4j3meL6Jeiv/8yoUL84uuI5zu5TGEMyIHWqCIQsfL1R3NNOOFGc304oC8F4TxLs43bHWEhWc6TPzzObBAoWNTeVytWSfUrgH4U
 nwBujMpWGEnGGriHOi2Oy+yrpMDPh/OuNzRZ6+PvddBBmlTI2cYEHltDfT9dsPsntkiaTcw4+SHDXdp+rz3D0e6ry96XtzHCYRzOvNxcJySkIIsOpsA=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Ken,

On 2/18/19 2:37 PM, Ken Sloat wrote:
>> -----Original Message-----
>> From: Eugen.Hristev@microchip.com <Eugen.Hristev@microchip.com>
>> Sent: Friday, February 15, 2019 3:38 AM
>> To: linux-media@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
>> kernel@vger.kernel.org; mchehab@kernel.org;
>> Nicolas.Ferre@microchip.com; Ken Sloat <KSloat@aampglobal.com>;
>> sakari.ailus@iki.fi; hverkuil@xs4all.nl
>> Cc: Eugen.Hristev@microchip.com
>> Subject: [PATCH] media: atmel: atmel-isc: reworked driver and formats
>>
>> From: Eugen Hristev <eugen.hristev@microchip.com>
>>
>> This change is a redesign in the formats and the way the ISC is configured
>> w.r.t. sensor format and the output format from the ISC.
>> I have changed the splitting between sensor output (which is also ISC input)
>> and ISC output.
>> The sensor format represents the way the sensor is configured, and what ISC
>> is receiving.
>> The format configuration represents the way ISC is interpreting the data and
>> formatting the output to the subsystem.
>> Now it's much easier to figure out what is the ISC configuration for input, and
>> what is the configuration for output.
>> The non-raw format can be obtained directly from sensor or it can be done
>> inside the ISC. The controller format list will include a configuration for each
>> format.
>> The old supported formats are still in place, if we want to dump the sensor
>> format directly to the output, the try format routine will detect and configure
>> the pipeline accordingly.
>> This also fixes the previous issues when the raw format was NULL which
>> resulted in many crashes for sensors which did not have the expected/tested
>> formats.
>>
>> Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
>> ---
>> Hello Ken and possibly others using ISC driver,
>>
>> I would appreciate if you could test this patch with your sensor, because I do
>> not wish to break anything in your setups.
>> Feedback is appreciated if any errors appear, so I can fix them.
>> I tested with ov5640, ov7670, ov7740(only in 4.19 because on latest it's
>> broken for me...) Rebased this patch on top of mediatree.git/master Thanks!
>>
>> Eugen
>>
> Hi Eugen,
> 
> No problem I will try to test sometime this week on my setup. I appreciate you keeping me in the loop.

Were you able to test this patch? And if not, when do you think you can
test this? I think it would be good to test this before committing it
since it is a major change.

Regards,

	Hans
