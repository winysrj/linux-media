Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:10639 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729259AbeK0TrS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 14:47:18 -0500
Subject: Re: [PATCH] media: unify some sony camera sensors pattern naming
To: Luca Ceresoli <luca@lucaceresoli.net>, bingbu.cao@intel.com,
        linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, tfiga@chromium.org,
        andy.yeh@intel.com
References: <1543291261-26174-1-git-send-email-bingbu.cao@intel.com>
 <9f1be8b6-8736-e204-5e79-89f4c07becba@lucaceresoli.net>
From: Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <a8e26177-5ff2-3884-f6e2-55ce682dad6d@linux.intel.com>
Date: Tue, 27 Nov 2018 16:55:02 +0800
MIME-Version: 1.0
In-Reply-To: <9f1be8b6-8736-e204-5e79-89f4c07becba@lucaceresoli.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/27/2018 04:05 PM, Luca Ceresoli wrote:
> Hi Bingbu,
>
> On 27/11/18 05:01, bingbu.cao@intel.com wrote:
>> From: Bingbu Cao <bingbu.cao@intel.com>
>>
>> Some Sony camera sensors have same test pattern
>> definitions, this patch unify the pattern naming
>> to make it more clear to the userspace.
>>
>> Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
>> ---
>>   drivers/media/i2c/imx258.c | 8 ++++----
>>   drivers/media/i2c/imx319.c | 8 ++++----
>>   drivers/media/i2c/imx355.c | 8 ++++----
>>   3 files changed, 12 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
>> index 31a1e2294843..a8a2880c6b4e 100644
>> --- a/drivers/media/i2c/imx258.c
>> +++ b/drivers/media/i2c/imx258.c
>> @@ -504,10 +504,10 @@ struct imx258_mode {
>>   
>>   static const char * const imx258_test_pattern_menu[] = {
>>   	"Disabled",
>> -	"Color Bars",
>> -	"Solid Color",
>> -	"Grey Color Bars",
>> -	"PN9"
>> +	"Solid Colour",
>> +	"Eight Vertical Colour Bars",
>> +	"Colour Bars With Fade to Grey",
>> +	"Pseudorandom Sequence (PN9)",
> I had a look at imx274, it has many more values but definitely some
> could be unified too.
>
> However I noticed something strange in that driver: The "Horizontal
> Color Bars" pattern has vertical bars, side-by-side, as in ||||.
> "Vertical Color Bars" are one on top of the other, as in ==. Is it just
> me crazy, or are they swapped?
Luca, thanks for your review.
I do not have the manual of imx274.
|||| should be the 'Vertical Color Bars' without any rotation process.
If not, I think the definitions there are swapped.
> Only one minor nitpick about your patch. The USA spelling "color" seems
> a lot more frequent in the kernel sources than the UK "colour", so it's
> probably better to be consistent.
Ack, I will update in next version.

Thanks!
>
