Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34921 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbbAMV47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 16:56:59 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so24390471wiw.1
        for <linux-media@vger.kernel.org>; Tue, 13 Jan 2015 13:56:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEt6MX=rmPAb798TysHDWHAQxpVxzKiaDNv4P9ZtUNPz2YEwpA@mail.gmail.com>
References: <CAPx3zdRnHcQOasSjnYZkuE+Hk-L6PVaPVAzBbCMnGdM3ZysxFw@mail.gmail.com>
	<CAEt6MX=f-kkemgmAUNsEdZQzH2tRgtPDacbCn4hwH27uY-upDA@mail.gmail.com>
	<CAPx3zdSLb8gzcGTUcWrktc9icJBCCJ0FbPecxeUJRot3ztHwSA@mail.gmail.com>
	<CAEt6MX=rmPAb798TysHDWHAQxpVxzKiaDNv4P9ZtUNPz2YEwpA@mail.gmail.com>
Date: Tue, 13 Jan 2015 22:56:58 +0100
Message-ID: <CAPx3zdQK+wM1YHfzWfvzQ9ZgWgQb4WEY+6AW=cSb_YOwAKKr4Q@mail.gmail.com>
Subject: Re: Driver/module in kernel fault. Anyone expert to help me? Siano ID 187f:0600
From: Francesco Other <francesco.other@gmail.com>
To: =?UTF-8?Q?Roberto_Alc=C3=A2ntara?= <roberto@eletronica.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I used another working-device for creating the channels.conf file with
this command:

scan frequency > ~/.tzap/channels.conf

----

For example this is a line from that file:

Italia1:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1620:1621:4006

----

So, this is the output for tzap with the NOT-working-device:

$ tzap -r -c ~/.tzap/channels.conf Italia1
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/ionic/.tzap/channels.conf'
Version: 5.10   FE_CAN { DVB-T }
tuning to 698000000 Hz
video pid 0x0654, audio pid 0x0655
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
^C

----

That channel, Italia1, obviously working fine with the working-device.

This is the system log during tzap with the not-working-device:

Jan 13 22:53:15 Linux kernel: [ 3968.930540] smsusb_sendrequest:
sending MSG_SMS_RF_TUNE_REQ(561) size: 20
Jan 13 22:53:15 Linux kernel: [ 3968.930579] smsusb_sendrequest:
sending MSG_SMS_ADD_PID_FILTER_REQ(601) size: 12
Jan 13 22:53:15 Linux kernel: [ 3968.939002] smsusb_sendrequest:
sending MSG_SMS_ADD_PID_FILTER_REQ(601) size: 12
Jan 13 22:53:15 Linux kernel: [ 3968.967963] smsusb_onresponse:
received MSG_SMS_TRANSMISSION_IND(782) size: 56
Jan 13 22:53:15 Linux kernel: [ 3968.967976] smsusb_onresponse:
received MSG_SMS_RF_TUNE_RES(562) size: 12
Jan 13 22:53:15 Linux kernel: [ 3968.967987] smsusb_onresponse:
received MSG_SMS_ADD_PID_FILTER_RES(602) size: 12
Jan 13 22:53:15 Linux kernel: [ 3968.968012] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:53:15 Linux kernel: [ 3968.968082] smsusb_onresponse:
received MSG_SMS_ADD_PID_FILTER_RES(602) size: 12
Jan 13 22:53:15 Linux kernel: [ 3968.968325] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:53:15 Linux kernel: [ 3969.070459] smsusb_onresponse:
received MSG_SMS_HO_INBAND_POWER_IND(631) size: 16
Jan 13 22:53:16 Linux kernel: [ 3969.338962] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.339202] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.339451] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.339575] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.351453] smsusb_onresponse:
received MSG_SMS_SIGNAL_DETECTED_IND(827) size: 8
Jan 13 22:53:16 Linux kernel: [ 3969.351464] smsusb_onresponse:
received MSG_SMS_TRANSMISSION_IND(782) size: 56
Jan 13 22:53:16 Linux kernel: [ 3969.351577] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:53:16 Linux kernel: [ 3969.352576] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:53:16 Linux kernel: [ 3969.368052] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:53:16 Linux kernel: [ 3969.368326] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:53:16 Linux kernel: [ 3969.376075] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.376450] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.376700] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.376824] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.406828] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.406953] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.407200] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.407450] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.441580] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.441700] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.441951] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.442200] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.477202] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1888
Jan 13 22:53:16 Linux kernel: [ 3969.477451] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.477700] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.477950] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.478200] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.513700] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.513951] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.514200] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.514325] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.548711] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.548826] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.549075] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.549325] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.583583] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.583827] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.583951] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.584201] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.584450] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1888
Jan 13 22:53:16 Linux kernel: [ 3969.617827] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.618077] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.618325] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.618450] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.651578] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 22:53:16 Linux kernel: [ 3969.652076] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.652326] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.652575] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.652825] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.685203] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.685451] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.685700] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.685949] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.686074] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.720327] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.720576] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.720700] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.720950] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1888
Jan 13 22:53:16 Linux kernel: [ 3969.755826] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.756074] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.756200] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.756450] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.756699] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.786453] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.786702] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.786950] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.787200] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.818952] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.819200] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.819326] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.819576] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.852576] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.852701] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.852951] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.853200] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1888
Jan 13 22:53:16 Linux kernel: [ 3969.853325] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.885829] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.886076] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.886325] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.886575] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.921452] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.921701] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.921950] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.922200] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.956204] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.956451] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.956574] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.956828] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.968468] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 22:53:16 Linux kernel: [ 3969.974578] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 22:53:16 Linux kernel: [ 3969.991964] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 22:53:16 Linux kernel: [ 3969.992203] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
...
...

----

Regards

Francesco

2015-01-13 17:13 GMT+01:00 Roberto Alcântara <roberto@eletronica.org>:
> Good to know about DVB on this chip. This is sms2270 id :-)
>
> I think you can get more  information from module debug messages.
>
> Try
>         options smsusb debug=3
> on /etc/modprobe.d.
>
> Then reload it and try to tzap one of channels found by scan to look
> for some lock.  You will have more debug messages now.
>
> Cheers,
>  - Roberto
>
>
>
>
>  - Roberto
>
>
> On Tue, Jan 13, 2015 at 12:35 PM, Francesco Other
> <francesco.other@gmail.com> wrote:
>> Hi Roberto, thanks for your fast reply.
>>
>> I'm from Italy, a DVB-T region. With Windows the device works fine, it
>> receives all the channels from multiplexes.
>> I don't know if my device has the SMS2270 chip, I know the ID,
>> 187f:0600, and the link on the Terratec site:
>> http://www.terratec.net/details.php?artnr=145258#.VLU5Z2SG9LY
>>
>> In that site there are the software and the Windows driver, if you
>> install those driver you can obtain the dvb_rio.inp driver from
>> system32 folder.
>> I forced the DVB-T mode because without it in dmesg output I see that
>> system ask for isdbt_rio.inp, but with DVB-T forced mode the system
>> ask for dvb_rio.inp.
>>
>> I can't understand why I can't receive any channels from multiplexes,
>> the signal is ok, I can see this from many software (Kaffeine, w_scan,
>> scan, TvHeadend).
>>
>> Can you help me please?
>>
>> Best Regards
>>
>> Francesco
>>
>>
>> 2015-01-13 16:21 GMT+01:00 Roberto Alcântara <roberto@eletronica.org>:
>>> Hi Francesco,
>>>
>>> You are using Siano SMS2270, am I right?
>>>
>>> My guess you're using ISDB-T firmware to program your ic, but are you in
>>> ISDB-T region? I use same firmware name here and works fine (Brazil) and it
>>> seems loaded ok on your log.
>>>
>>> I never saw an DVB firmware available to sms2270. Your tuner is working fine
>>> under Windows with provided software ?
>>>
>>> Cheers,
>>>   - Roberto
>>>
>>>
>>>
>>>
>>>
>>>
>>>  - Roberto
>>>
>>> On Tue, Jan 13, 2015 at 11:50 AM, Francesco Other
>>> <francesco.other@gmail.com> wrote:
>>>>
>>>> Is there a gentleman that can help me with my problem? On linuxtv.org
>>>> they said that someone here sure will help me.
>>>>
>>>> I submitted the problem here:
>>>> http://www.spinics.net/lists/linux-media/msg85432.html
>>>>
>>>> Regards
>>>>
>>>> Francesco
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
