Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:58913 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbcG2Tcf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2016 15:32:35 -0400
Subject: Re: [PATCH 6/6] media: adv7180: fix field type
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	=?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	<linux-media@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
	<slongerbeam@gmail.com>
References: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
 <20160729174012.14331-7-niklas.soderlund+renesas@ragnatech.se>
 <cc084571-3063-a883-b731-0ffe01c4fefa@cogentembedded.com>
CC: <lars@metafoo.de>, <mchehab@kernel.org>, <hans.verkuil@cisco.com>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <df2a330f-30a3-e296-006e-204fa1771bb5@mentor.com>
Date: Fri, 29 Jul 2016 12:32:30 -0700
MIME-Version: 1.0
In-Reply-To: <cc084571-3063-a883-b731-0ffe01c4fefa@cogentembedded.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 07/29/2016 12:10 PM, Sergei Shtylyov wrote:
> On 07/29/2016 08:40 PM, Niklas Söderlund wrote:
>
>> From: Steve Longerbeam <slongerbeam@gmail.com>
>>
>> The ADV7180 and ADV7182 transmit whole fields, bottom field followed
>> by top (or vice-versa, depending on detected video standard). So
>> for chips that do not have support for explicitly setting the field
>> mode, set the field mode to V4L2_FIELD_ALTERNATE.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> [Niklas: changed filed type from V4L2_FIELD_SEQ_{TB,BT} to
>> V4L2_FIELD_ALTERNATE]
>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>
> Tested-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>
>    IIUC, it's a 4th version of this patch; you should have kept the 
> original change log (below --- tearline) and indicated that in the 
> subject.
>
> MBR, Sergei

This version is fine with me. The i.mx6 h/w motion-compensation 
deinterlacer (VDIC)
needs to know the field order, and it can't get that info from 
V4L2_FIELD_ALTERNATE,
but it can still determine the order via querystd().

But I agree the change log should be preserved, and the 
V4L2_FIELD_ALTERNATE change
added to the change log.

Acked-by: Steve Longerbeam <slongerbeam@gmail.com>

Steve


