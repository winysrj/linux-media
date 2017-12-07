Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53952 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752766AbdLGLDN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 06:03:13 -0500
Subject: Re: [PATCH v5] v4l2-async: Match parent devices
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        jacopo@jmondi.org, niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
References: <1512572319-20179-1-git-send-email-kbingham@kernel.org>
 <20171207074133.lfz7yumr2je3tvec@kekkonen.localdomain>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
Message-ID: <5af50774-6bc3-7528-d2fc-75a6acd9f299@ideasonboard.com>
Date: Thu, 7 Dec 2017 11:03:09 +0000
MIME-Version: 1.0
In-Reply-To: <20171207074133.lfz7yumr2je3tvec@kekkonen.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 07/12/17 07:41, Sakari Ailus wrote:
> On Wed, Dec 06, 2017 at 02:58:39PM +0000, Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> Devices supporting multiple endpoints on a single device node must set
>> their subdevice fwnode to the endpoint to allow distinct comparisons.
>>
>> Adapt the match_fwnode call to compare against the provided fwnodes
>> first, but to also perform a cross reference comparison against the
>> parent fwnodes of each other.
>>
>> This allows notifiers to pass the endpoint for comparison and still
>> support existing subdevices which store their default parent device
>> node.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>
>> ---
>>
>> Hi Sakari,
>>
>> Since you signed-off on this patch - it has had to be reworked due to the
>> changes on the of_node_full_name() functionality.
>>
>> I believe it is correct now to *just* do the pointer matching, as that matches
>> the current implementation, and converting to device_nodes will be just as
>> equal as the fwnodes, as they are simply containers.
>>
>> Let me know if you are happy to maintain your SOB on this patch - and if we need
>> to work towards getting this integrated upstream, especially in light of your new
>> endpoint matching work.
> 
> I'd really want to avoid resorting to matching opportunistically --- please
> see my reply to Niklas on "[RFC 1/1] v4l: async: Use endpoint node, not
> device node, for fwnode match".

I agree here ... This patch is a workaround to support non-endpoint matching in
a transitioning world. Moving to full endpoint matching will support complex
devices and simple devices ...

If we can go straight to that - then that's fine too.
--
Kieran
