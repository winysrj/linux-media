Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab2K2JXT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 04:23:19 -0500
Message-ID: <50B729FF.6020402@redhat.com>
Date: Thu, 29 Nov 2012 10:25:19 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Antonio Ospite <ospite@studenti.unina.it>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca - ov534: Fix the light frequency filter
References: <20121122124652.3a832e33@armhf> <20121123180909.021c55a8c3795329836c42b7@studenti.unina.it> <20121123191232.7ed9c546@armhf>
In-Reply-To: <20121123191232.7ed9c546@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Francois, Antonio Ospite,

Could it be that you're both right, and that the register
Jean-Francois suggest is used (0x13) and uses in his patch
is for enabling / disabling the light-freq filter, where
as the register which were used before this patch
(0x2a, 0x2b) are used to select the light frequency to
filter for?

That would explain everything the 2 50 / 60 hz testers are
seeing. This assumes that reg 0x13 has the filter always
enabled before the patch, and the code before the patch
simply changes the filter freq to such a value it
effectively disables the filter for 50 Hz. This also
assumes that the default values in 0x2a and 0x2b are
valid for 60hz, which explains why Jean Francois' patch
works for 60 Hz, so with all this combined we should
have all pieces of the puzzle ...

Anyone wants to do a patch to prove I'm right (or wrong :)
?

Regards,

Hans


On 11/23/2012 07:12 PM, Jean-Francois Moine wrote:
> On Fri, 23 Nov 2012 18:09:09 +0100
> Antonio Ospite <ospite@studenti.unina.it> wrote:
>
>> On Thu, 22 Nov 2012 12:46:52 +0100
> 	[snip]
>> Jean-Francois Moine <moinejf@free.fr> wrote:
>>> This patch was done thanks to the documentation of the right
>>> OmniVision sensors.
>>
>> In the datasheet I have for ov772x, bit[6] of register 0x13 is described
>> as:
>>
>>    Bit[6]: AEC - Step size limit
>>      0: Step size is limited to vertical blank
>>      1: Unlimited step size
>
> Right, but I don't use the bit 6, it is the bit 5:
>
>>> +		sccb_reg_write(gspca_dev, 0x13,		/* auto */
>>> +				sccb_reg_read(gspca_dev, 0x13) | 0x20);
>
> which is described as:
>
>     Bit[5]:  Banding filter ON/OFF
>
>> And the patch makes Light Frequency _NOT_ work with the PS3 eye (based
>> on ov772x).
>>
>> What does the ov767x datasheet say?
>
> Quite the same thing:
>
>     Bit[5]: Banding filter ON/OFF - In order to turn ON the banding
>             filter, BD50ST (0x9D) or BD60ST (0x9E) must be set to a
>             non-zero value.
>             0: OFF
>             1: ON
>
> (the registers 9d and 9e are non zero for the ov767x in ov534.c)
>
>> Maybe we should use the new values only when
>> 	sd->sensor == SENSOR_OV767x
>>
>> What sensor does Alexander's webcam use?
>
> He has exactly the same webcam as yours: 1415:2000 (ps eye) with
> sensor ov772x.
>
>>> Note: The light frequency filter is either off or automatic.
>>> The application will see either off or "50Hz" only.
>>>
>>> Tested-by: alexander calderon <fabianp902@gmail.com>
>>> Signed-off-by: Jean-François Moine <moinejf@free.fr>
>>>
>>> --- a/drivers/media/usb/gspca/ov534.c
>>> +++ b/drivers/media/usb/gspca/ov534.c
>>> @@ -1038,13 +1038,12 @@
>>>   {
>>>   	struct sd *sd = (struct sd *) gspca_dev;
>>>
>>
>> drivers/media/usb/gspca/ov534.c: In function ‘setlightfreq’:
>> drivers/media/usb/gspca/ov534.c:1039:13: warning: unused variable ‘sd’ [-Wunused-variable]
>
> Thanks.
>
> Well, here is one of the last message I received from Alexander (in
> fact, his first name is Fabian):
>
>> Thanks for all your help, it is very kind of you, I used the code below,the
>> 60 Hz filter appear to work even at 100fps, but when I used 125 fps it
>> didnt work :( , i guess it is something of detection speed. If you have any
>> other idea I'll be very thankful.
>>
>> Sincerely Fabian Calderon
>
> So, how may we advance?
>
