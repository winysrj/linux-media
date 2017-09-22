Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13377 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752109AbdIVVZo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 17:25:44 -0400
Subject: Re: [PATCH v3 0/4] AS3645A fixes
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-leds@vger.kernel.org
Cc: linux-media@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <20170922093238.13070-1-sakari.ailus@linux.intel.com>
 <650b7cb3-f7dd-5959-3147-df7284415521@gmail.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <076725cc-ef46-898d-34e5-099ece5d50b4@linux.intel.com>
Date: Sat, 23 Sep 2017 00:25:39 +0300
MIME-Version: 1.0
In-Reply-To: <650b7cb3-f7dd-5959-3147-df7284415521@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

(Fixed DT list address.)

Jacek Anaszewski wrote:
> Hi Sakari,
>
> On 09/22/2017 11:32 AM, Sakari Ailus wrote:
>> Hi Jacek and others,
>>
>> Here are a few fixes for the as3645a DTS as well as changes in bindings.
>> The driver is not in a release yet.
>>
>> Jacek: Could you take these to your fixes branch so we don't get faulty DT
>> bindings to a release? I've dropped the patches related to LED naming and
>> label property as the discusion appears to continue on that.
>
> No problem. One question - isn't patch 3/4 missing?

Hmm. I can see it on both linux-leds and devicetree.

I've pushed the four patches here, on v4.14-rc1:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=as3645a-fix>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
