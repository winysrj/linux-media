Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:9359 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751247AbdFFU6G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 16:58:06 -0400
Subject: Re: [PATCH v3 5/7] docs-rst: media: Sort topic list alphabetically
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        hverkuil@xs4all.nl
References: <1491829376-14791-1-git-send-email-sakari.ailus@linux.intel.com>
 <1491829376-14791-6-git-send-email-sakari.ailus@linux.intel.com>
 <20170606094834.0152cd6f@vento.lan>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <4d1b8a9a-af82-c72d-3554-f1844d5a5b08@linux.intel.com>
Date: Tue, 6 Jun 2017 23:57:55 +0300
MIME-Version: 1.0
In-Reply-To: <20170606094834.0152cd6f@vento.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab wrote:
> Em Mon, 10 Apr 2017 16:02:54 +0300
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
>
>> Bring some order by alphabetically ordering the list of topics.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  Documentation/media/kapi/v4l2-core.rst | 18 +++++++++---------
>>  1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
>> index d8f6c46..2fbf532 100644
>> --- a/Documentation/media/kapi/v4l2-core.rst
>> +++ b/Documentation/media/kapi/v4l2-core.rst
>> @@ -4,23 +4,23 @@ Video4Linux devices
>>  .. toctree::
>>      :maxdepth: 1
>>
>> -    v4l2-intro
>
> NACK.
>
> The order of the documentation should match what makes sense for the
> user that will be reading the docs, and *not* an alphabetical order.

I wrote the patch to address some of the review comments I got over the 
several versions of the patchset. I have no objections to maintaining 
the current order.

>
> I didn't check what order you did, but for sure the introduction should
> come first, and then the stuff that all drivers use, like
> v4l2-dev, v4l2-device and v4l2-fh. Then, other stuff that it is part of
> the framework but are used only by a subset of the drivers.
>
> That's said, it probably makes sense to use multiple toctrees here, and
> add some description before each of them, in order to better organize
> its contents. Something similar to what it was done with
> 	Documentation/admin-guide/index.rst
>
> I'll rebase patch 6/7 to not depend on this one.

Thanks!

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
