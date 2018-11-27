Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:19216 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727542AbeK0Ng1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 08:36:27 -0500
Subject: Re: [PATCH 2/2] media: imx355: fix wrong order in test pattern menus
To: Sakari Ailus <sakari.ailus@linux.intel.com>, bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        rajmohan.mani@intel.com, mchehab+samsung@kernel.org,
        hverkuil@xs4all.nl
References: <1543218214-10767-1-git-send-email-bingbu.cao@intel.com>
 <1543218214-10767-2-git-send-email-bingbu.cao@intel.com>
 <20181126085732.vupidoa2lozp5ndo@paasikivi.fi.intel.com>
From: Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <1f9d131f-8b99-3118-5112-ace6ed1b3d0d@linux.intel.com>
Date: Tue, 27 Nov 2018 10:45:02 +0800
MIME-Version: 1.0
In-Reply-To: <20181126085732.vupidoa2lozp5ndo@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/26/2018 04:57 PM, Sakari Ailus wrote:
> Hi Bing Bu,
>
> On Mon, Nov 26, 2018 at 03:43:34PM +0800, bingbu.cao@intel.com wrote:
>> From: Bingbu Cao <bingbu.cao@intel.com>
>>
>> current imx355 test pattern order in ctrl menu
>> is not correct, this patch fixes it.
>>
>> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
>> ---
>>   drivers/media/i2c/imx355.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/imx355.c b/drivers/media/i2c/imx355.c
>> index 20c8eea5db4b..9c9559dfd3dd 100644
>> --- a/drivers/media/i2c/imx355.c
>> +++ b/drivers/media/i2c/imx355.c
>> @@ -876,8 +876,8 @@ struct imx355 {
>>   
>>   static const char * const imx355_test_pattern_menu[] = {
>>   	"Disabled",
>> -	"100% color bars",
>>   	"Solid color",
>> +	"100% color bars",
>>   	"Fade to gray color bars",
>>   	"PN9"
>>   };
> While at it, could you use the existing test pattern naming as well for the
> drivers? That could be a separate patch.
>
> >From drivers/media/i2c/smiapp/smiapp-core.c :
>
> static const char * const smiapp_test_patterns[] = {
> 	"Disabled",
> 	"Solid Colour",
>    	"Eight Vertical Colour Bars",
> 	"Colour Bars With Fade to Grey",
> 	"Pseudorandom Sequence (PN9)",
> };
>
> It's not strictly necessary from interface point of view, but for the user
> space it'd be good to align the naming.
Sakari, ask a question that not really related to this patch.
I am wondering whether there are some standardization for the camera sensor
pattern generator.
Currently there are varied patterns and every vendor has its own pattern types.
>
