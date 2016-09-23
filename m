Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63503 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759061AbcIWLNi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 07:13:38 -0400
Subject: Re: [PATCH v1.1 5/5] smiapp: Implement support for autosuspend
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-media@vger.kernel.org
References: <1473938961-16067-6-git-send-email-sakari.ailus@linux.intel.com>
 <1474374598-32451-1-git-send-email-sakari.ailus@linux.intel.com>
 <20160923001448.mmeo3fhheajvbqzk@earth>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57E50E5E.6010403@linux.intel.com>
Date: Fri, 23 Sep 2016 14:13:34 +0300
MIME-Version: 1.0
In-Reply-To: <20160923001448.mmeo3fhheajvbqzk@earth>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sebastian Reichel wrote:
> Hi,
>
> On Tue, Sep 20, 2016 at 03:29:58PM +0300, Sakari Ailus wrote:
>> Delay suspending the device by 1000 ms by default.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>
>> since v1:
>>
>> - Increment usage count before register write using
>>    pm_runtime_get_noresume(), and decrement it before returning. This
>>    avoids a serialisation problem with autosuspend.
>>
>>   drivers/media/i2c/smiapp/smiapp-core.c | 10 +++++++---
>>   drivers/media/i2c/smiapp/smiapp-regs.c | 21 +++++++++++++++------
>>   2 files changed, 22 insertions(+), 9 deletions(-)
>
> Reviewed-By: Sebastian Reichel <sre@kernel.org>

Danke schön! :-)

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
