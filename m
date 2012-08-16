Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43542 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932180Ab2HPSb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 14:31:29 -0400
Received: by lagy9 with SMTP id y9so1641527lag.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 11:31:27 -0700 (PDT)
Message-ID: <502D3C6F.6010507@iki.fi>
Date: Thu, 16 Aug 2012 21:31:11 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb-usb-v2 change broke s2250-loader compilation
References: <201208161233.43618.hverkuil@xs4all.nl> <502CE527.2070006@iki.fi> <502CF98B.1060700@iki.fi> <201208161607.03380.hverkuil@xs4all.nl> <502D03B6.8030708@iki.fi> <502D24DF.8090503@redhat.com>
In-Reply-To: <502D24DF.8090503@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/16/2012 07:50 PM, Mauro Carvalho Chehab wrote:
> Em 16-08-2012 11:29, Antti Palosaari escreveu:
>> On 08/16/2012 05:07 PM, Hans Verkuil wrote:
>>> On Thu August 16 2012 15:45:47 Antti Palosaari wrote:
>>>> On 08/16/2012 03:18 PM, Antti Palosaari wrote:
>>>>> On 08/16/2012 01:33 PM, Hans Verkuil wrote:
>>>>>> Building the kernel with the Sensoray 2250/2251 staging go7007 driver
>>>>>> enabled
>>>>>> fails with this link error:
>>>>>>
>>>>>> ERROR: "usb_cypress_load_firmware"
>>>>>> [drivers/staging/media/go7007/s2250-loader.ko] undefined!
>>>>>>
>>>>>> As far as I can tell this is related to the dvb-usb-v2 changes.
>>>>>>
>>>>>> Can someone take a look at this?
>>>>>>
>>>>>> Thanks!
>>>>>>
>>>>>>       Hans
>>>>>
>>>>> Yes it is dvb usb v2 related. I wasn't even aware that someone took that
>>>>> module use in few days after it was added for the dvb-usb-v2.
>>>>>
>>>>> Maybe it is worth to make it even more common and move out of dvb-usb-v2...
>>>>>
>>>>> regards
>>>>> Antti
>>>>
>>>> And after looking it twice I cannot see the reason. I split that Cypress
>>>> firmware download to own module called dvb_usb_cypress_firmware which
>>>> offer routine usbv2_cypress_load_firmware(). Old DVB USB is left
>>>> untouched. I can confirm it fails to compile for s2250, but there is
>>>> still old dvb_usb_cxusb that is compiling without a error.
>>>>
>>>> Makefile paths seems to be correct also, no idea whats wrong....
>>>
>>> drivers/media/usb/Makefile uses := instead of += for the dvb-usb(-v2) directories,
>>> and that prevents dvb-usb from being build. I think that's the cause of the link
>>> error.
>>
>> For that I cannot say as I don't understand situation enough.
>>
>>> In addition I noticed that in usb/dvb-usb there is a dvb_usb_dvb.c and a
>>> dvb-usb-dvb.c file: there's a mixup with _ and -.
>>
>> These files seems to be my fault. Original patch series removes those,
>> but I was forced to rebase whole set and in that rebased set those are left unremoved.
>> Likely due to some rebase conflict. I will send new patch to remove those.
>
> If you remove the _, they'll conflict with dvb-usb at media-build.git.
>
> The better is to add a _v2 (or -v2) on all dvb-usb-v2 files
> (or to convert the remaining dvb-usb drivers to dvb-usb-v2).

hmm, now I am quite out what you mean.

This is from my first PULL-request:
http://git.linuxtv.org/anttip/media_tree.git/commit/c60c6d44111be2b2fd9ef9b716ea50bd87493893

And this is same patch after large rebase:
http://git.linuxtv.org/anttip/media_tree.git/commit/ac97c6f722aafb5b562ef04062b543147399dff8

Why removing those wrong files will cause conflict in media_build.git ?



OK, those are just wasting space nothing more. But there was that 
original problem too which breaks s2250-loader compilation.

regards
Antti

>
> Regards,
> Mauro
>
>>
>>> Mauro, did that happen during the reorganization?
>>>
>>> Regards,
>>>
>>>      Hans
>>>
>>
>> regards
>> Antti
>>
>


-- 
http://palosaari.fi/
