Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:36474 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbEASny (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2015 14:43:54 -0400
Received: by qgeb100 with SMTP id b100so41311103qge.3
        for <linux-media@vger.kernel.org>; Fri, 01 May 2015 11:43:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEk3jHhCXDCt=A-epo_VXuLmc+c2XHQaq0JTCkgE9qRLd13yjQ@mail.gmail.com>
References: <CAEk3jHjE0ufT_CqqTSxsZ0XSxQW5D9GnVh7cQHQuFGL_KLz6RQ@mail.gmail.com>
	<CAAZRmGwvyZJMa_qDg1P1LfGEDvmZRAzd029CPdNk5wi5zxHznQ@mail.gmail.com>
	<CAEk3jHhCXDCt=A-epo_VXuLmc+c2XHQaq0JTCkgE9qRLd13yjQ@mail.gmail.com>
Date: Fri, 1 May 2015 20:43:53 +0200
Message-ID: <CAEk3jHgVwfnojoRu+X1Dayj3z0oXiCG7ObD-8BGdNmuTJ3RP5w@mail.gmail.com>
Subject: Re: issue with TechnoTrend CT2-4650 CI
From: Michal B <developer.m3@gmail.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olli,

i'm taking back my question ...
so i found that vdr is most suitable for me ...
thank You for helping me to get through it
also running correctly encrypted chans ...

thank You again,

Kind regards,

Michal


2015-05-01 16:52 GMT+02:00 Michal B <developer.m3@gmail.com>:
> Hi Olli,
>
> thank You very much for your reply,
> it was misunderstanding on my side, because i thought that this module message:
> [  102.005119] dvb_ca adapter 0: DVB CAM detected and initialised successfully
>
> means that CAM was initialized  ...
>
> so i used :
> dvb-fe-tool -d DVBC/ANNEX_A
> -- my tuner was originally in DVB-T mode, so gnutv was unsuccessful ...
> gnutv -timeout 1 -out file /var/tmp/test.ts -channels .......
>
> results are that i can tune channels correctly but i'm unable to watch
> encrypted channels,
> i used vlc,
> on wind* i can watch also encrypted :-(
>
> please could you help me ?
> Kind regards,
>
> Michal
>
>
>
> 2015-05-01 15:46 GMT+02:00 Olli Salonen <olli.salonen@iki.fi>:
>> Hi Michal,
>>
>> I've seen something like this before with some CAMs. It seems that the
>> CAM needs to be initialized if it is plugged in. This does not happen
>> if you use software which does not have CAM support (such as w_scan).
>>
>> The linuxtv.org wiki has the following comment on the CT2-4650 page:
>>
>> Some CAMs require initialization before they will work. Without
>> initialization it's possible that even non-encrypted channels do not
>> work. If there's no CAM inserted, there's no issue.
>>
>> gnutv could be used to initialize the CAM, for example:
>> gnutv -timeout 1 -out file /var/tmp/test.ts -channels ~/channels.conf FOX
>>
>> Of course ideally the CAM should be initialized by the driver...
>>
>> Cheers,
>> -olli
>>
>>
>>
>> On 1 May 2015 at 11:39, Michal B <developer.m3@gmail.com> wrote:
>>> Hi all,
>>>
>>> i bought new TechnoTrend  CT2-4650 CI ,
>>> i tried to use it on wind* , successfuly also with encrypted channels with CAM,
>>> then i tried on linux with kernel 3.19.6, and i got two behaviors:
>>> when CAM is unplugged i'm able to watch unencrypted channels correctly,
>>> but when i plugged in CAM i'm unable to find any channel during scan
>>> with w_scan,
>>> and also i'm unable to tune any channel previously found,
>>>
>>> and i have second issue: when i have CAM plugged and i unplug
>>> TechnoTrend from USB on my computer - my computer freezes - so i have
>>> to reset by button on the case,
>>>
>>> please somebody could help me to get it running with CAM to watch
>>> encrypted channels ?
>>>
>>> here is output when CAM is unplugged:
>>>
>>> [ 1381.807428] usb 3-10: new high-speed USB device number 4 using xhci_hcd
>>> [ 1381.935870] usb 3-10: New USB device found, idVendor=0b48, idProduct=3012
>>> [ 1381.935872] usb 3-10: New USB device strings: Mfr=1, Product=2,
>>> SerialNumber=3
>>> [ 1381.935874] usb 3-10: Product: TechnoTrend USB2.0
>>> [ 1381.935874] usb 3-10: Manufacturer: CityCom GmbH
>>> [ 1381.935875] usb 3-10: SerialNumber: 20130422
>>> [ 1382.222836] usb 3-10: dvb_usb_v2: found a 'TechnoTrend TT-connect
>>> CT2-4650 CI' in warm state
>>> [ 1382.222868] usb 3-10: dvb_usb_v2: will pass the complete MPEG2
>>> transport stream to the software demuxer
>>> [ 1382.222875] DVB: registering new adapter (TechnoTrend TT-connect CT2-4650 CI)
>>> [ 1382.224114] usb 3-10: dvb_usb_v2: MAC address: bc:ea:2b:65:00:ad
>>> [ 1382.245403] i2c i2c-7: Added multiplexed i2c bus 8
>>> [ 1382.245406] si2168 7-0064: Silicon Labs Si2168 successfully attached
>>> [ 1382.259984] si2157 8-0060: Silicon Labs Si2147/2148/2157/2158
>>> successfully attached
>>> [ 1382.273787] sp2 7-0040: CIMaX SP2 successfully attached
>>> [ 1382.273794] usb 3-10: DVB: registering adapter 0 frontend 0
>>> (Silicon Labs Si2168)...
>>> [ 1382.310693] Registered IR keymap rc-tt-1500
>>> [ 1382.310744] input: TechnoTrend TT-connect CT2-4650 CI as
>>> /devices/pci0000:00/0000:00:14.0/usb3/3-10/rc/rc0/input23
>>> [ 1382.310827] rc0: TechnoTrend TT-connect CT2-4650 CI as
>>> /devices/pci0000:00/0000:00:14.0/usb3/3-10/rc/rc0
>>> [ 1382.310831] usb 3-10: dvb_usb_v2: schedule remote query interval to 300 msecs
>>> [ 1382.310832] usb 3-10: dvb_usb_v2: 'TechnoTrend TT-connect CT2-4650
>>> CI' successfully initialized and connected
>>> [ 1382.310847] usbcore: registered new interface driver dvb_usb_dvbsky
>>>
>>> when i start vlc:
>>> [ 1485.824805] si2168 7-0064: found a 'Silicon Labs Si2168' in cold state
>>> [ 1485.835991] si2168 7-0064: downloading firmware from file
>>> 'dvb-demod-si2168-a20-01.fw'
>>> [ 1491.074442] si2168 7-0064: found a 'Silicon Labs Si2168' in warm state
>>> [ 1491.083144] si2157 8-0060: found a 'Silicon Labs
>>> Si2146/2147/2148/2157/2158' in cold state
>>> [ 1491.090486] si2157 8-0060: downloading firmware from file
>>> 'dvb-tuner-si2158-a20-01.fw'
>>>
>>>
>>> Kind regards,
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
