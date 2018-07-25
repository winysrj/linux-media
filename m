Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34561 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbeGYOOi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 10:14:38 -0400
Received: by mail-wr1-f66.google.com with SMTP id c13-v6so7352161wrt.1
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2018 06:03:02 -0700 (PDT)
Subject: Re: [PATCH v3 17/35] media: camss: Add 8x96 resources
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
 <1532343772-27382-18-git-send-email-todor.tomov@linaro.org>
 <20180724122154.nkb3px4tlzalhfit@paasikivi.fi.intel.com>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <6914034b-9871-eca6-fa4c-86f97e76b8b8@linaro.org>
Date: Wed, 25 Jul 2018 16:02:57 +0300
MIME-Version: 1.0
In-Reply-To: <20180724122154.nkb3px4tlzalhfit@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24.07.2018 15:21, Sakari Ailus wrote:
> Hi Todor,
> 
> On Mon, Jul 23, 2018 at 02:02:34PM +0300, Todor Tomov wrote:
> ...
>> @@ -61,7 +59,8 @@ struct ispif_device {
>>  	struct mutex power_lock;
>>  	struct ispif_intf_cmd_reg intf_cmd[MSM_ISPIF_VFE_NUM];
>>  	struct mutex config_lock;
>> -	struct ispif_line line[MSM_ISPIF_LINE_NUM];
>> +	int line_num;
> 
> unsigned int?

Yes, thanks :)

> 
> I guess if there are only such changes then a patch on top of the current
> set might be more practical than a new version of the entire set.
> 

-- 
Best regards,
Todor Tomov
