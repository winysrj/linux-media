Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:61548 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751065AbdJBMYK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Oct 2017 08:24:10 -0400
Subject: Re: [PATCH v14 07/28] rcar-vin: Use generic parser for parsing fwnode
 endpoints
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
 <20170925222540.371-8-sakari.ailus@linux.intel.com>
 <20170930131709.GP17182@bigcity.dyn.berto.se>
 <3f940721-f190-4662-cfda-d99a0d97bf08@linux.intel.com>
 <20171002121422.GQ17182@bigcity.dyn.berto.se>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <82a055f5-b0ad-bcd2-7d28-f256163a288c@linux.intel.com>
Date: Mon, 2 Oct 2017 15:24:05 +0300
MIME-Version: 1.0
In-Reply-To: <20171002121422.GQ17182@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hejssan,

On 10/02/17 15:14, Niklas Söderlund wrote:
> Hi Sakari,
> 
> On 2017-10-02 14:58:10 +0300, Sakari Ailus wrote:
>> Hi Niklas,
>>
>> On 09/30/17 16:17, Niklas Söderlund wrote:
>>> Hi Sakari,
>>>
>>> Thanks for your patch, I like it. Unfortunately it causes issues :-(
>>>
>>> I picked the first 7 patches of this series on top of media-next and it 
>>> produce problems when tested on Koelsch with CONFIG_OF_DYNAMIC=y.
>>>
>>> 1. It print's 'OF: ERROR: Bad of_node_put() on /video@e6ef0000/port' 
>>>    messages during boot.
>>
>> Do you have your own patch to fix fwnode_graph_get_port_parent()
>> applied? I noticed it doesn't seem to be in Rob's tree; let's continue
>> in the other thread.
>>
>> <URL:https://www.mail-archive.com/linux-media@vger.kernel.org/msg117450.html>
> 
> To produce this issue the fix is not applied. But as I try to describe 
> at the end of my email applying it fixes both issues. So I think this 
> patch is correct (and that is why I Acked it) but my concern is that if 
> it's picked up before the fwnode_graph_get_port_parent() issue is sorted 
> out there will be problems for rcar-vin, and if possible I would like to 
> avoid that.

Oops. I missed that between the oops log and the patch. X-)

Well, good to hear that this isn't an actual bug in this set. I'll try
to be careful in sending pull requests. :-) The same issue would be
present in any other driver using the new convenience functions.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
