Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:6888 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755409AbdCGM64 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Mar 2017 07:58:56 -0500
Subject: Re: [PATCH 1/1] media: entity: Swap pads if route is checked from
 source to sink
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org
References: <1478599875-27700-1-git-send-email-sakari.ailus@linux.intel.com>
 <20170307111551.GJ20587@bigcity.dyn.berto.se>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <0b05bd44-a97d-023a-274e-2f192f5f7f64@linux.intel.com>
Date: Tue, 7 Mar 2017 13:17:11 +0200
MIME-Version: 1.0
In-Reply-To: <20170307111551.GJ20587@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 03/07/17 13:15, Niklas Söderlund wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On 2016-11-08 12:11:15 +0200, Sakari Ailus wrote:
>> This way the pads are always passed to the has_route() op sink pad first.
>> Makes sense.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>> Hi Niklas,
>>
>> This should make it easier to implement the has_route() op in drivers.
>>
>> Feel free to merge this to "[PATCH 02/32] media: entity: Add
>> media_entity_has_route() function" if you like, or add separately after
>> the second patch.
> 
> I choose to append this as a separated patch on top of Laurents patches 
> and include all 3 in my next R-Car VIN series.


Ack. Thanks for the info.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
