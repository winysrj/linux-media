Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37940 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab2LQJeZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 04:34:25 -0500
Message-ID: <50CEE6FA.4030901@iki.fi>
Date: Mon, 17 Dec 2012 11:33:46 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthew Gyurgyik <matthew@pyther.net>
CC: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jwilson@redhat.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50C4BA20.8060003@googlemail.com> <50C4BAFB.60304@googlemail.com> <50C4C525.6020006@googlemail.com> <50C4D011.6010700@pyther.net> <50C60220.8050908@googlemail.com> <CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com> <50C60772.2010904@googlemail.com> <CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com> <50C6226C.8090302@iki! .fi> <50C636E7.8060003@googlemail.com> <50C64AB0.7020407@iki.fi> <50C79CD6.4060501@googlemail.com> <50C79E9A.3050301@iki.fi> <20121213182336.2cca9da6@redhat.! com> <50CB46CE.60407@googlemail.com> <20121214173950.79bb963e@redhat.com> <20121214222631.1f191d6e@redhat.co! m> <50CBCAB9.602@iki.fi> <20121214235412.2598c91c@redhat.com> <50CC76FC.5030208@googlemail.com> <50CC7D3F.9020108@iki.fi> <50CCA39F.5000309@googlemail.co m> <50CCAAA4.4030808@iki.fi> <50CE70E0.2070809@pyther.net> <50CE74C7.90809@iki.fi> <50CE7763.3030900@pyther.net>
In-Reply-To: <50CE7763.3030900@pyther.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/17/2012 03:37 AM, Matthew Gyurgyik wrote:
> On 12/16/2012 08:26 PM, Antti Palosaari wrote:
>> On 12/17/2012 03:09 AM, Matthew Gyurgyik wrote:
>>> On 12/15/2012 06:21 PM, Frank Schäfer wrote:
>>>>> Matthew, could you please validate your test results and try Mauros
>>>>> patches ? If it doesn't work, please create another USB-log.
>>>>>
>>>
>>> Sorry it took me so long to test the patch, but the results look
>>> promising, I actually got various keycodes!
>>>
>>> dmesg: http://pyther.net/a/digivox_atsc/dec16/dmesg_remote.txt
>>>
>>> evtest was also generating output
>>>
>>> Event: time 1355705906.950551, type 4 (EV_MSC), code 4 (MSC_SCAN), value
>>> 61d618e7
>>> Event: time 1355705906.950551, -------------- SYN_REPORT ------------
>>>
>>> This is the current patch I'm using:
>>> http://pyther.net/a/digivox_atsc/dec16/dmesg_remote.txt
>>>
>>> What needs to be done to generate a keymap file?
>>>
>>> Is there anything I can collect or try to do, to get channel scanning
>>> working?
>>>
>>> Just let me know what you need me to do. I really appreciate all the
>>> help!
>>
>> You don't need to do nothing as that remote is already there. Just
>> ensure buttons are same and we are happy.
>> http://lxr.free-electrons.com/source/drivers/media/IR/keymaps/rc-msi-digivox-iii.c?v=2.6.37
>>
>>
>>
>> RC_MAP_MSI_DIGIVOX_III should be added to your device profile in order
>> to load correct keytable by default. You could test it easily, just add
>> following definition
>>
>> .ir_codes = RC_MAP_MSI_DIGIVOX_III,
>>
>> to em28xx-cards.c board config and it is all.
>>
>> regards
>> Antti
>>
> Maybe I'm missing something but these are different key codes and lengths.
>
> tux:~ $ echo 0x61d643bc | wc -c  # my dmesg dump
> 11
> tux:~ $ echo 0x61d601 | wc -c  # DIGIVOX mini III
> 9

0x61d643bc == 0x61d643
0x61d601fe == 0x61d601

Those are same codes, other (debug) is just 32bit full format. Last byte 
in that case is dropped out as it is used for parity check - formula: DD 
== ~DD

> As I understand it, this was the whole reason for the patches that
> Mauros wrote.

Nope, the reason was it didn't support 32bit at all.

regards
Antti

-- 
http://palosaari.fi/
