Return-path: <linux-media-owner@vger.kernel.org>
Received: from firefly.pyther.net ([50.116.37.168]:34321 "EHLO
	firefly.pyther.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab2LIOuK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2012 09:50:10 -0500
Message-ID: <50C4A520.6020908@pyther.net>
Date: Sun, 09 Dec 2012 09:50:08 -0500
From: Matthew Gyurgyik <matthew@pyther.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com> <50BD6310.8000808@pyther.net> <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com> <50BE65F0.8020303@googlemail.com> <50BEC253.4080006@pyther.net> <50BF3F9A.3020803@iki.fi> <50BFBE39.90901@pyther.net> <50BFC445.6020305@iki.fi> <50BFCBBB.5090407@pyther.net> <50BFECEA.9060808@iki.fi> <50BFFFF6.1000204@pyther.net> <50C11301.10205@googlemail.com> <50C12302.80603@pyther.net> <50C34628.5030407@googlemail.com> <50C34A50.6000207@pyther.net> <50C35AD1.3040000@googlemail.com> <50C3701D.9000700@pyther .net> <50C37DA8.4080608@googlemai l.com> <50C3B3EB.40606@pyther .net> <50C3B567.3070300@i ki.fi> <50C3B969.1090301@pyth er.net> <50C48891.2050903@googlemail.com>
In-Reply-To: <50C48891.2050903@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/09/2012 07:48 AM, Frank Schäfer wrote:
> Am 08.12.2012 23:04, schrieb Matthew Gyurgyik:
>> On 12/08/2012 04:47 PM, Antti Palosaari wrote:
>>> On 12/08/2012 11:40 PM, Matthew Gyurgyik wrote:
>>>> On 12/08/2012 12:49 PM, Frank Schäfer wrote:
>>>>> Am 08.12.2012 17:51, schrieb Matthew Gyurgyik:
>>>>>
>>>>> That shouldn't be necessary. I just noticed that there is a module
>>>>> parameter 'ir_debug'. ;)
>>>>> With ir_debug enabled, you should see messages
>>>>>
>>>>>           em28xx_ir_handle_key: toggle: XX, count: XX, key XXYYZZ
>>>>>
>>>>> everytime you press a button. Once we know the key codes, we can
>>>>> set up
>>>>> a key map (if it doesn't exist yet).
>>>>>
>>>>
>>>> Maybe I'm doing something wrong but didn't have any luck :(
>>>>
>>>>> [root@tux ~]# sudo rmmod em28xx_rc
>>>>> [root@tux ~]# sudo rmmod em28xx_dvb
>>>>> [root@tux ~]# sudo rmmod em28xx
>>>>> [root@tux ~]# modprobe em28xx_rc ir_debug=1
>>>>
>>>> I don't see any additional messages in dmesg.
>>>>
>>>> I verified the remote still works in windows (a stupidity check on my
>>>> part)
>>>
>>> Maybe Kernel debugs are not enabled? em28xx driver is a little bit
>>> legacy in logging too as it uses own logging whilst nowadays dynamic
>>> logging is recommended.
>>>
>>> replace KERN_DEBUG as KERN_INFO inside em28xx-input.c and test. It will
>>> change driver to use Kernel normal log writings instead of current debug
>>> ones.
>>>
>>> regards
>>> Antti
>>>
>>>
>> That unfortunately doesn't make any difference.
>>
>> I even tried adding a print statment before the debug line got called
>> like this (line 97 added; em28xx-input.c):
>>   97     printk(KERN_INFO "key %02x\n", b);
>>   98     i2cdprintk("key %02x\n", b);
>>
>
> The relevant line is
>
> 297        dprintk("%s: toggle: %d, count: %d, key 0x%02x%02x\n", __func__,
>
> Change it to
>
> 297        printk(KERN_INFO "%s: toggle: %d, count: %d, key
> 0x%02x%02x\n", __func__,
>
> Also double-check that the IR module (em28xx_rc) is enabled / gets loaded.
>
> Regards,
> Frank
>
>
Sadly I'm still not getting anything.

[root@tux ~]# rmmod em28xx_rc 

[root@tux ~]# rmmod em28xx_dvb
[root@tux ~]# rmmod em28xx
[root@tux ~]# lsmod | grep em28xx
[root@tux ~]# modprobe em28xx_rc ir_debug=1

[root@tux ~]# lsmod | grep em28xx
em28xx_dvb             17075  0
em28xx_rc               6250  0
em28xx                 85996  2 em28xx_dvb,em28xx_rc
rc_core                12193  3 rc_msi_digivox_iii,em28xx_rc
dvb_core               86050  2 em28xx_dvb,lgdt3305
tveeprom               13658  1 em28xx
videobuf_vmalloc        4136  1 em28xx
videobuf_core          15216  2 videobuf_vmalloc,em28xx
v4l2_common             6927  1 em28xx
videodev               97480  2 em28xx,v4l2_common


Just to make sure I'm not misunderstanding, the messages should get 
logged to dmesg, correct?


