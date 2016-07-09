Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35765 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbcGIS7I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 14:59:08 -0400
Received: by mail-pa0-f43.google.com with SMTP id dx3so22012860pab.2
        for <linux-media@vger.kernel.org>; Sat, 09 Jul 2016 11:59:07 -0700 (PDT)
Subject: Re: [PATCH 06/11] media: adv7180: add bt.656-4 OF property
To: Lars-Peter Clausen <lars@metafoo.de>, linux-media@vger.kernel.org
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846004-12731-7-git-send-email-steve_longerbeam@mentor.com>
 <577E6C98.3020608@metafoo.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <5781497A.2080804@gmail.com>
Date: Sat, 9 Jul 2016 11:59:06 -0700
MIME-Version: 1.0
In-Reply-To: <577E6C98.3020608@metafoo.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/07/2016 07:52 AM, Lars-Peter Clausen wrote:
> On 07/07/2016 12:59 AM, Steve Longerbeam wrote:
>> Add a device tree boolean property "bt656-4" to allow setting
>> the ITU-R BT.656-4 compatible bit.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>
> +	/* select ITU-R BT.656-4 compatible? */
> +	if (of_property_read_bool(client->dev.of_node, "bt656-4"))
> +		state->bt656_4 = true;
> This property needs to be documented. In my opinion it should also be a
> property of the endpoint sub-node rather than the toplevel device node since
> this is a configuration of the endpoint format.

Agreed, it's really a config of the backend capture endpoint. I'll move it
there and also document it in 
Documentation/devicetree/bindings/media/i2c/adv7180.txt.

Steve

