Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab1LYSNi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 13:13:38 -0500
Message-ID: <4EF767CB.10705@redhat.com>
Date: Sun, 25 Dec 2011 16:13:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dennis Sperlich <dsperlich@googlemail.com>
CC: linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: em28xx_isoc_dvb_max_packetsize for EM2884 (Terratec Cinergy HTC
 Stick)
References: <4EF64AF4.2040705@gmail.com> <4EF70077.5040907@redhat.com> <4EF72D61.9090001@gmail.com>
In-Reply-To: <4EF72D61.9090001@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25-12-2011 12:04, Dennis Sperlich wrote:
> On 25.12.2011 11:52, Mauro Carvalho Chehab wrote:
>> On 24-12-2011 19:58, Dennis Sperlich wrote:
>>> Hi,
>>>
>>> I have a Terratec Cinergy HTC Stick an tried the new support for the DVB-C part. It works for SD material (at least for free receivable stations, I tried afair only QAM64), but did not for HD stations (QAM256). I have only access to unencrypted ARD HD, ZDF HD and arte HD (via KabelDeutschland). The HD material was just digital artefacts, as far as mplayer could decode it. When I did a dumpstream and looked at the resulting file size I got something about 1MB/s which seems a little too low, because SD was already about 870kB/s. After looking around I found a solution in increasing the isoc_dvb_max_packetsize from 752 to 940 (multiple of 188). Then an HD stream was about 1.4MB/s and looked good. I'm not sure, whether this is the correct fix, but it works for me.
>>>
>>> If you need more testing pleas tell.
>>>
>>> Regards,
>>> Dennis
>>>
>>>
>>>
>>> index 804a4ab..c518d13 100644
>>> --- a/drivers/media/video/em28xx/em28xx-core.c
>>> +++ b/drivers/media/video/em28xx/em28xx-core.c
>>> @@ -1157,7 +1157,7 @@ int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev)
>>>                   * FIXME: same as em2874. 564 was enough for 22 Mbit DVB-T
>>>                   * but not enough for 44 Mbit DVB-C.
>>>                   */
>>> -               packet_size = 752;
>>> +               packet_size = 940;
>>>          }
>>>
>>>          return packet_size;
>> As you can see there at the code, the packet size depends on the chipset, as
>> not all will support 940 for packet size.
>>
>> Could you please provide us what was the chip detected id?
>>
>> It should be a message on your dmesg like:
>>
>>     chip ID is em2870
>> or
>>     em28xx chip ID = 38
>>
>> The patch should change it only for your specific chipset model, in order to
>> avoid regressions to other supported chipsets, like:
>>
>> int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev)
>> {
>>          unsigned int chip_cfg2;
>>          unsigned int packet_size;
>>
>>          switch (dev->chip_id) {
>>          case CHIP_ID_EM2710:
>>          case CHIP_ID_EM2750:
>>          case CHIP_ID_EM2800:
>>          case CHIP_ID_EM2820:
>> ...
>>     case CHIP_ID_foo:
>>         packet_size = 940;
>> ...
>>          }
>>
>>          return packet_size;
>> }
>>
>> The case you're touching seems to be for em2884, but the switch covers both
>> em2884 and em28174 (plus the default for newer chipsets).
> 
> dmesg says: em28xx #0: chip ID is em2884
> 
> so a patch would be more like:
> 
> index 804a4ab..9280251 100644
> --- a/drivers/media/video/em28xx/em28xx-core.c
> +++ b/drivers/media/video/em28xx/em28xx-core.c
> @@ -1151,6 +1151,8 @@ int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev)
>                 packet_size = 564;
>                 break;
>         case CHIP_ID_EM2884:
> +               packet_size = 940;
> +               break;
>         case CHIP_ID_EM28174:
>         default:
>                 /*
> 
>> Maybe Michael/Devin may have something to say, with regards to a way to detect
>> the maximum supported packet size by each specific em28xx model.
> 
> This would be fine, I tried also 1128 (6 times 188), but then mplayer did not play any more.
> I then tried 1034, but then I got the message " submit of urb 0 failed (error=-90)", so I guess 
> there have to be integer multiples of 188.

The maximum packet size is described at the USB descriptors.

The code at em28xx_set_alternate() seeks for the alternates and selects
the one that will get the best alternate for the analog mode.

There, you'll see a code that gets the best alternate for analog,
and selects the proper packet size for it.

For DVB, it should be a little different, as, on DVB, the driver doesn't
know, in advance, what's the streaming rate. So, the driver needs to get
a high enough packet size to fit for the bandwidth needs.

Also, for DVB, the driver does:
	usb_set_interface(dev->udev, 0, 1);

(e. g. it always use alternate 1)

So, in thesis, that function could be as simple as:
	dev->alt_max_pkt_size[1];

(if the max packet size for alternate 1 would work for all chips)

Or, eventually, the code might be using other alternates for HD, 
but I'm not sure if those chipsets support a different alternate for DVB.

Regards,
Mauro
