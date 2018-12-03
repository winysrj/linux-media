Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:52699 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbeLCCsk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 2 Dec 2018 21:48:40 -0500
Subject: Re: [PATCH] media: unify some sony camera sensors pattern naming
To: Tomasz Figa <tfiga@chromium.org>,
        Cao Bing Bu <bingbu.cao@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>
References: <1543291261-26174-1-git-send-email-bingbu.cao@intel.com>
 <CAAFQd5Dzk2AxMXA+QUFJ+LqRudVe6T6-tt2wY1q4Zpw2Hhhhrw@mail.gmail.com>
From: Bingbu Cao <bingbu.cao@linux.intel.com>
Message-ID: <28de442c-5893-adc4-5801-c54f45a82849@linux.intel.com>
Date: Mon, 3 Dec 2018 10:53:34 +0800
MIME-Version: 1.0
In-Reply-To: <CAAFQd5Dzk2AxMXA+QUFJ+LqRudVe6T6-tt2wY1q4Zpw2Hhhhrw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/01/2018 02:08 AM, Tomasz Figa wrote:
> Hi Bingbu,
>
> On Mon, Nov 26, 2018 at 7:56 PM <bingbu.cao@intel.com> wrote:
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
> Thanks for the patch! One comment inline.
>
>> diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
>> index 31a1e2294843..a8a2880c6b4e 100644
>> --- a/drivers/media/i2c/imx258.c
>> +++ b/drivers/media/i2c/imx258.c
>> @@ -504,10 +504,10 @@ struct imx258_mode {
>>
>>   static const char * const imx258_test_pattern_menu[] = {
>>          "Disabled",
>> -       "Color Bars",
>> -       "Solid Color",
>> -       "Grey Color Bars",
>> -       "PN9"
>> +       "Solid Colour",
>> +       "Eight Vertical Colour Bars",
> Is it just me or "solid color" and "color bars" are being swapped
> here? Did the driver had the names mixed up before or the order of
> modes is different between these sensors?
The test pattern value order of the 3 camera sensors should be same.
All are:
0 - Disabled
1 - Solid Colour
2 - Eight Vertical Colour Bars
...

This patch swapped the first 2 item for imx258 (wrong order before) and use unified
name for all 3 sensors.
>
> Best regards,
> Tomasz
>
