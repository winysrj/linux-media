Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:11182 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750984AbdIKHva (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 03:51:30 -0400
Subject: Re: [PATCH v9 02/24] v4l: async: Remove re-probing support
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131235.30294-3-sakari.ailus@linux.intel.com>
 <787019fe-7402-7edb-3de6-9a683de78d71@xs4all.nl>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <041af454-9aa7-653c-fa40-6f484829d36e@linux.intel.com>
Date: Mon, 11 Sep 2017 10:51:25 +0300
MIME-Version: 1.0
In-Reply-To: <787019fe-7402-7edb-3de6-9a683de78d71@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/17 10:47, Hans Verkuil wrote:
> On 09/08/2017 03:11 PM, Sakari Ailus wrote:
>> Remove V4L2 async re-probing support. The re-probing support has been
>> there to support cases where the sub-devices require resources provided by
>> the main driver's hardware to function, such as clocks.
>>
>> Reprobing has allowed unbinding and again binding the main driver without
>> explicilty unbinding the sub-device drivers. This is certainly not a
>> common need, and the responsibility will be the user's going forward.
>>
>> An alternative could have been to introduce notifier specific locks.
>> Considering the complexity of the re-probing and that it isn't really a
>> solution to a problem but a workaround, remove re-probing instead.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> I Acked the v8 version, but don't see my Ack here. Did you miss it?

I think I sent v9 around the time you sent the ack. :-) It will be in v10.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
