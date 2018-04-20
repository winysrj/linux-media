Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:45074 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754759AbeDTN2J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 09:28:09 -0400
Subject: Re: [PATCH] media: cx231xx: Add support for AverMedia DVD EZMaker 7
To: Kai Heng Feng <kai.heng.feng@canonical.com>, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180326060616.5354-1-kai.heng.feng@canonical.com>
 <BC47F34C-7BF6-4A61-9EA0-BA8C24E71F6E@canonical.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <463bff2e-4217-0bd7-50b8-fe19de39b48d@xs4all.nl>
Date: Fri, 20 Apr 2018 15:28:05 +0200
MIME-Version: 1.0
In-Reply-To: <BC47F34C-7BF6-4A61-9EA0-BA8C24E71F6E@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/13/18 08:59, Kai Heng Feng wrote:
> Hi,
> 
>> On Mar 26, 2018, at 2:06 PM, Kai-Heng Feng <kai.heng.feng@canonical.com>  
>> wrote:
>>
>> User reports AverMedia DVD EZMaker 7 can be driven by VIDEO_GRABBER.
>> Add the device to the id_table to make it work.
> 
> *Gentle ping*
> I am hoping this patch can get merged in v4.17.

I posted a pull request for 4.17 for this.

Regards,

	Hans

> 
> Kai-Heng
> 
>>
>> BugLink: https://bugs.launchpad.net/bugs/1620762
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
>>  drivers/media/usb/cx231xx/cx231xx-cards.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c  
>> b/drivers/media/usb/cx231xx/cx231xx-cards.c
>> index f9ec7fedcd5b..da01c5125acb 100644
>> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
>> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
>> @@ -945,6 +945,9 @@ struct usb_device_id cx231xx_id_table[] = {
>>  	 .driver_info = CX231XX_BOARD_CNXT_RDE_250},
>>  	{USB_DEVICE(0x0572, 0x58A0),
>>  	 .driver_info = CX231XX_BOARD_CNXT_RDU_250},
>> +	/* AverMedia DVD EZMaker 7 */
>> +	{USB_DEVICE(0x07ca, 0xc039),
>> +	 .driver_info = CX231XX_BOARD_CNXT_VIDEO_GRABBER},
>>  	{USB_DEVICE(0x2040, 0xb110),
>>  	 .driver_info = CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL},
>>  	{USB_DEVICE(0x2040, 0xb111),
>> -- 
>> 2.15.1
