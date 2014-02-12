Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay02.ispgateway.de ([80.67.31.29]:35785 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaBLBQM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 20:16:12 -0500
Message-ID: <52FACB55.2030200@doerges.net>
Date: Wed, 12 Feb 2014 02:16:05 +0100
From: =?UTF-8?B?VGlsbCBEw7ZyZ2Vz?= <till@doerges.net>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: PATCH: Added device (0ccd:00b4) to DVB_USB_RTL28XXU media driver
References: <52FA87CD.2030206@doerges.net> <52FA8DB9.3070300@iki.fi>
In-Reply-To: <52FA8DB9.3070300@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

thanks for the quick response.

Am 11.02.2014 21:53, schrieb Antti Palosaari:

> Thanks for the 'patch' :)
> I am not sure how I should handle that as the code itself is valid, but patch is not
> as it should.
> 
> If you could make a proper patch, using git commit & git format-patch, it will be
> nice. But as I understand it could be quite much of learning many things, I am
> willing to take that and apply half manually. I still need you signed-off-by tag as
> documented [1]. Please reply with signed-off-by or even better if you could make
> formally correct patch.
> 
> [1] https://www.kernel.org/doc/Documentation/SubmittingPatches

I actually read that document before, but apparently I missed the git part (and I
don't have a git checkout of the kernel sources). So if you can help me out, that's
greatly appreciated. :-)

Signed-off-by: Till Dörges <till@doerges.net>

Thanks -- Till

> On 11.02.2014 22:27, Till Dörges wrote:
>> Hi all,
>>
>> I've got the following DAB USB stick that also works fine with the DVB_USB_RTL28XXU
>> driver after I added its USB ID:
>>
>> --- snip ---
>> user@box:~> lsusb -d 0ccd:00b4
>> Bus 001 Device 009: ID 0ccd:00b4 TerraTec Electronic GmbH
>> --- snap ---
>>
>>
>> I tried it on a recent openSUSE 13.1 with this kernel/architecture
>>
>> --- snip ---
>> user@box:~> uname -a
>> Linux box 3.11.10-7-desktop #1 SMP PREEMPT Mon Feb 3 09:41:24 UTC 2014 (750023e)
>> x86_64 x86_64 x86_64 GNU/Linux
>> --- snap ---
>>
>>
>> The patches itself are trivial:
>>
>> --- ./drivers/media/dvb-core/dvb-usb-ids.h.orig 2014-02-09 22:36:35.266625484 +0100
>> +++ ./drivers/media/dvb-core/dvb-usb-ids.h      2014-02-09 22:38:00.128199957 +0100
>> @@ -256,6 +256,7 @@
>>   #define USB_PID_TERRATEC_T5                            0x10a1
>>   #define USB_PID_NOXON_DAB_STICK                                0x00b3
>>   #define USB_PID_NOXON_DAB_STICK_REV2                   0x00e0
>> +#define USB_PID_NOXON_DAB_STICK_REV3                   0x00b4
>>   #define USB_PID_PINNACLE_EXPRESSCARD_320CX             0x022e
>>   #define USB_PID_PINNACLE_PCTV2000E                     0x022c
>>   #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH              0x0228
>>
>>
>> --- ./drivers/media/usb/dvb-usb-v2/rtl28xxu.c.orig      2014-02-03 10:41:24.000000000
>> +0100
>> +++ ./drivers/media/usb/dvb-usb-v2/rtl28xxu.c   2014-02-09 22:37:53.464154845 +0100
>> @@ -1362,6 +1362,8 @@ static const struct usb_device_id rtl28x
>>                  &rtl2832u_props, "TerraTec NOXON DAB Stick", NULL) },
>>          { DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK_REV2,
>>                  &rtl2832u_props, "TerraTec NOXON DAB Stick (rev 2)", NULL) },
>> +       { DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK_REV3,
>> +               &rtl2832u_props, "TerraTec NOXON DAB Stick (rev 3)", NULL) },
>>          { DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_TREKSTOR_TERRES_2_0,
>>                  &rtl2832u_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
>>          { DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1101,
>>
>> HTH -- Till
>>
> 
> 

