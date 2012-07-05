Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab2GEIdF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 04:33:05 -0400
Message-ID: <4FF5515A.1030704@redhat.com>
Date: Thu, 05 Jul 2012 10:33:30 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 4/4] radio-si470x: Lower firmware version requirements
References: <1339681394-11348-1-git-send-email-hdegoede@redhat.com> <1339681394-11348-4-git-send-email-hdegoede@redhat.com> <4FF45FF7.4020300@iki.fi>
In-Reply-To: <4FF45FF7.4020300@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/04/2012 05:23 PM, Antti Palosaari wrote:
> On 06/14/2012 04:43 PM, Hans de Goede wrote:
>> With the changes from the previous patches device firmware version 14 +
>> usb microcontroller software version 1 works fine too.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/media/radio/si470x/radio-si470x-usb.c |    2 +-
>>   drivers/media/radio/si470x/radio-si470x.h     |    2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
>> index 66b1ba8..40b963c 100644
>> --- a/drivers/media/radio/si470x/radio-si470x-usb.c
>> +++ b/drivers/media/radio/si470x/radio-si470x-usb.c
>> @@ -143,7 +143,7 @@ MODULE_PARM_DESC(max_rds_errors, "RDS maximum block errors: *1*");
>>    * Software/Hardware Versions from Scratch Page
>>    **************************************************************************/
>>   #define RADIO_SW_VERSION_NOT_BOOTLOADABLE    6
>> -#define RADIO_SW_VERSION            7
>> +#define RADIO_SW_VERSION            1
>>   #define RADIO_HW_VERSION            1
>>
>>
>> diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
>> index fbf713d..b3b612f 100644
>> --- a/drivers/media/radio/si470x/radio-si470x.h
>> +++ b/drivers/media/radio/si470x/radio-si470x.h
>> @@ -189,7 +189,7 @@ struct si470x_device {
>>    * Firmware Versions
>>    **************************************************************************/
>>
>> -#define RADIO_FW_VERSION    15
>> +#define RADIO_FW_VERSION    14
>
> I just found out this patch serie and tested it - but no luck. Could you say if I do something wrong or is it due to my device firmware version?
>

I believe you're doing something wrong ...

> I compiled radio from http://git.linuxtv.org/xawtv3.git to tune and
 > "arecord  -r96000 -c2 -f S16_LE | aplay - " to play sound. Just silent white noise is heard.

You're not specifying which device arecord should record from so likely it is taking
the default input of your soundcard (line/mic in), rather then recording from the
radio device.

Note the latest radio from http://git.linuxtv.org/xawtv3.git will do the digital loopback of
the sound itself, so try things again with running arecord / aplay, if you then start radio
and exit again (so that you can see its startup messages) you should see something like this:

"Using alsa loopback: cap: hw:1,0 (/dev/radio0), out: default"

Note radio will automatically select the correct alsa device to record from for the radio-usb-stick.

> Jul  4 18:04:33 localhost kernel: [   78.006361] usb 5-2: new full-speed USB device number 2 using ohci_hcd
> Jul  4 18:04:34 localhost kernel: [   78.165127] usb 5-2: New USB device found, idVendor=10c5, idProduct=819a
> Jul  4 18:04:34 localhost kernel: [   78.165131] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> Jul  4 18:04:34 localhost kernel: [   78.165133] usb 5-2: Manufacturer: www.rding.cn
> Jul  4 18:04:34 localhost udevd[412]: specified group 'plugdev' unknown
> Jul  4 18:04:34 localhost mtp-probe: checking bus 5, device 2: "/sys/devices/pci0000:00/0000:00:13.0/usb5/5-2"
> Jul  4 18:04:34 localhost mtp-probe: bus: 5, device: 2 was not an MTP device
> Jul  4 18:04:34 localhost kernel: [   78.189884] Linux media interface: v0.10
> Jul  4 18:04:34 localhost kernel: [   78.191940] Linux video capture interface: v2.00
> Jul  4 18:04:34 localhost kernel: [   78.194058] radio-si470x 5-2:1.2: DeviceID=0x1242 ChipID=0x060c
> Jul  4 18:04:34 localhost kernel: [   78.194061] radio-si470x 5-2:1.2: This driver is known to work with firmware version 14,
> Jul  4 18:04:34 localhost kernel: [   78.194062] radio-si470x 5-2:1.2: but the device has firmware version 12.
> Jul  4 18:04:34 localhost kernel: [   78.196041] radio-si470x 5-2:1.2: software version 1, hardware version 7
> Jul  4 18:04:34 localhost kernel: [   78.196043] radio-si470x 5-2:1.2: If you have some trouble using this driver,
> Jul  4 18:04:34 localhost kernel: [   78.196045] radio-si470x 5-2:1.2: please report to V4L ML at linux-media@vger.kernel.org
> Jul  4 18:04:34 localhost kernel: [   78.339041] usbcore: registered new interface driver radio-si470x
> Jul  4 18:04:34 localhost kernel: [   78.357056] usbcore: registered new interface driver snd-usb-audio
>
>
> And is there any cheap USB FM-radio device that is known to work on Linux ?  I would like to order one...

I've done my testing with this device:
http://www.tinydeal.com/usb-pcear-radio-recorder-for-pc-p-8603.html

And that one works, but I think yours should work fine too.

Regards,

Hans
