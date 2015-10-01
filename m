Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:35477 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbbJAVVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 17:21:50 -0400
Received: by laer8 with SMTP id r8so82341830lae.2
        for <linux-media@vger.kernel.org>; Thu, 01 Oct 2015 14:21:48 -0700 (PDT)
Subject: Re: [PATCH] Add Terratec H7 Revision 4 to DVBSky driver
To: Erik Andresen <erik@vontaene.de>, linux-media@vger.kernel.org
References: <55F2ED67.3030306@vontaene.de> <55FD9BB6.9050401@vontaene.de>
 <560D9F1F.7040505@gmail.com>
From: =?UTF-8?Q?Roger_M=c3=a5rtensson?= <roger.martensson@gmail.com>
Message-ID: <560DA3DF.4060401@gmail.com>
Date: Thu, 1 Oct 2015 23:21:35 +0200
MIME-Version: 1.0
In-Reply-To: <560D9F1F.7040505@gmail.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Den 2015-10-01 kl. 23:01, skrev Roger Mårtensson:
> Den 2015-09-19 kl. 19:30, skrev Erik Andresen:
>> Adds Terratec H7 Rev. 4 with USB id 0ccd:10a5 to DVBSky driver.
>
> I have tested this on a Custom Linux 4.2 kernel and it is working as 
> expected.
> Noticed a few things.
>
> 1) "Supported:" on ir-keytable doesn't show anything.
> 1b) Setting RC-5 with ir-keytable -p gives me an error.
> 2) Keymap tt-1500 may be for dvbsky but not for H7 Rev 4. Needed to do 
> my own keymap. (48 button remote)
> 2b) The Remote buttons "Music" and "Pic" doesn't give any scancodes in 
> ir-keytable -t.
>
> I have tested in a DVB-C environment with CAM/CI and encrypted channels.
> I have two H7 devices and one of them seem to get into a hang and 
> needs to be powercycled now and then. At the moment it is always the 
> same one that hangs. A linux reboot does not help but I need to do it 
> sometimes together with a power cycle of the hanging device.
>
>
I forgot something and I'm not sure you have the right documentation for 
it. Some operations seems not to be implemented.
I get a lot of error in MythTV when locking to a channel. It sure would 
be nice to see it implemented. It doesn't do any harm. Only filling up 
the log.

Oct  1 23:11:16 tvpc mythbackend: mythbackend[2911]: E TVRecEvent 
recorders/dvbchannel.cpp:1026 (GetSignalStrength) 
DVBChan[23](/dev/dvb/adapter2/frontend0): Getting Frontend signal 
strength failed.#012#011#011#011eno: Operation not supported (95)
Oct  1 23:11:16 tvpc mythbackend: mythbackend[2911]: W TVRecEvent 
recorders/dvbsignalmonitor.cpp:91 (DVBSignalMonitor) 
DVBSigMon[23](/dev/dvb/adapter2/frontend0): Cannot measure Signal 
Strength#012#011#011#011eno: Operation not supported (95)
Oct  1 23:11:16 tvpc mythbackend: mythbackend[2911]: E TVRecEvent 
recorders/dvbchannel.cpp:1055 (GetSNR) 
DVBChan[23](/dev/dvb/adapter2/frontend0): Getting Frontend signal/noise 
ratio failed.#012#011#011#011eno: Operation not supported (95)
Oct  1 23:11:16 tvpc mythbackend: mythbackend[2911]: W TVRecEvent 
recorders/dvbsignalmonitor.cpp:93 (DVBSignalMonitor) 
DVBSigMon[23](/dev/dvb/adapter2/frontend0): Cannot measure 
S/N#012#011#011#011eno: Operation not supported (95)
Oct  1 23:11:16 tvpc mythbackend: mythbackend[2911]: E TVRecEvent 
recorders/dvbchannel.cpp:1081 (GetBitErrorRate) 
DVBChan[23](/dev/dvb/adapter2/frontend0): Getting Frontend signal error 
rate failed.#012#011#011#011eno: Operation not supported (95)
Oct  1 23:11:16 tvpc mythbackend: mythbackend[2911]: W TVRecEvent 
recorders/dvbsignalmonitor.cpp:95 (DVBSignalMonitor) 
DVBSigMon[23](/dev/dvb/adapter2/frontend0): Cannot measure Bit Error 
Rate#012#011#011#011eno: Operation not supported (95)
Oct  1 23:11:16 tvpc mythbackend: mythbackend[2911]: E TVRecEvent 
recorders/dvbchannel.cpp:1107 (GetUncorrectedBlockCount) 
DVBChan[23](/dev/dvb/adapter2/frontend0): Getting Frontend uncorrected 
block count failed.#012#011#011#011eno: Operation not supported (95)
Oct  1 23:11:16 tvpc mythbackend: mythbackend[2911]: W TVRecEvent 
recorders/dvbsignalmonitor.cpp:97 (DVBSignalMonitor) 
DVBSigMon[23](/dev/dvb/adapter2/frontend0): Cannot count Uncorrected 
Blocks#012#011#011#011eno: Operation not supported (95)
Oct  1 23:11:16 tvpc mythbackend: mythbackend[2911]: E SignalMonitor 
recorders/dvbchannel.cpp:1026 (GetSignalStrength) 
DVBChan[23](/dev/dvb/adapter2/frontend0): Getting Frontend signal 
strength failed.#012#011#011#011eno: Operation not supported (95)

>> Signed-off-by: Erik Andresen <erik@vontaene.de>
>> ---
>>   drivers/media/dvb-core/dvb-usb-ids.h  | 1 +
>>   drivers/media/usb/dvb-usb-v2/dvbsky.c | 4 ++++
>>   2 files changed, 5 insertions(+)
>>
>> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h 
>> b/drivers/media/dvb-core/dvb-usb-ids.h
>> index c117fb3..0a46580 100644
>> --- a/drivers/media/dvb-core/dvb-usb-ids.h
>> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
>> @@ -257,6 +257,7 @@
>>   #define USB_PID_TERRATEC_CINERGY_T_XXS_2        0x00ab
>>   #define USB_PID_TERRATEC_H7                0x10b4
>>   #define USB_PID_TERRATEC_H7_2                0x10a3
>> +#define USB_PID_TERRATEC_H7_3                0x10a5
>>   #define USB_PID_TERRATEC_T3                0x10a0
>>   #define USB_PID_TERRATEC_T5                0x10a1
>>   #define USB_PID_NOXON_DAB_STICK                0x00b3
>> diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c 
>> b/drivers/media/usb/dvb-usb-v2/dvbsky.c
>> index cdf59bc..8f526a4 100644
>> --- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
>> +++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
>> @@ -841,6 +841,10 @@ static const struct usb_device_id 
>> dvbsky_id_table[] = {
>>           USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI,
>>           &dvbsky_t680c_props, "TechnoTrend TT-connect CT2-4650 CI",
>>           RC_MAP_TT_1500) },
>> +        { DVB_USB_DEVICE(USB_VID_TERRATEC,
>> +                USB_PID_TERRATEC_H7_3,
>> +                &dvbsky_t680c_props, "Terratec H7 Rev.4",
>> +                RC_MAP_TT_1500) },
>>       { }
>>   };
>>   MODULE_DEVICE_TABLE(usb, dvbsky_id_table);
>

