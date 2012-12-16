Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37170 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2LPSPj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 13:15:39 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so2822163eek.19
        for <linux-media@vger.kernel.org>; Sun, 16 Dec 2012 10:15:38 -0800 (PST)
Message-ID: <50CE0FD8.2050900@googlemail.com>
Date: Sun, 16 Dec 2012 19:15:52 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Matthew Gyurgyik <matthew@pyther.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jwilson@redhat.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50C48891.2050903@googlemail.com> <50C4A520.6020908@pyther.net> <CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com> <50C4BA20.8060003@googlemail.com> <50C4BAFB.60304@googlemail.com> <50C4C525.6020006@googlemail.com> <50C4D011.6010700@pyther.net> <50C60220.8050908@googlemail.com> <CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com> <50C60772.2010904@googlemail.com> <CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com> <50C6226C.8090302@iki! .fi> <50C636E7.8060003@googlemail.com> <50C64AB0.7020407@iki.fi> <50C79CD6.4060501@googlemail.com> <50C79E9A.3050301@iki.fi> <20121213182336.2cca9da6@redhat.! com> <50CB46CE.60407@googlemail.com> <20121214173950.79bb963e@redhat.com> <20121214222631.1f191d6e@redhat.co! m> <50CBCAB9.602@iki.fi> <20121214235412.2598c91c@redhat.com> <50CC76FC.5030208@googlemail.com> <50CC7D3F.9020108@iki.fi> <50CCA39F.5000309@googlemail.com> <50CCAAA4.4030808@iki.fi>
In-Reply-To: <50CCAAA4.4030808@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 15.12.2012 17:51, schrieb Antti Palosaari:
> On 12/15/2012 06:21 PM, Frank Schäfer wrote:
>> Am 15.12.2012 14:38, schrieb Antti Palosaari:
>>> On 12/15/2012 03:11 PM, Frank Schäfer wrote:
>>>> Am 15.12.2012 02:54, schrieb Mauro Carvalho Chehab:
>>>>> Em Sat, 15 Dec 2012 02:56:25 +0200
>>>>> Antti Palosaari <crope@iki.fi> escreveu:
>>>>>
>>>>>> On 12/15/2012 02:26 AM, Mauro Carvalho Chehab wrote:
>>>>>>> Em Fri, 14 Dec 2012 17:39:50 -0200
>>>>>>> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
>
>>>> Am 10.12.2012 17:00, schrieb Matthew Gyurgyik:
>>>>>>> Here is the dmesg output:
>>>>>>>
>>>>>>>> [root@tux ~]# dmesg -t | sort | uniq | grep 'em28xx IR' | grep
>>>>>>>> handle
>>>>>>>> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 0,
>>>>>>>> count: 1,
>>>>>>>> key 0x61d6
>>>>>>>> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 0,
>>>>>>>> count: 2,
>>>>>>>> key 0x61d6
>>>>>>>> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 1,
>>>>>>>> count: 1,
>>>>>>>> key 0x61d6
>>>>>>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0,
>>>>>>>> count: 1,
>>>>>>>> key 0x61d6
>>>>>>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0,
>>>>>>>> count: 2,
>>>>>>>> key 0x61d6
>>>>>>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 1,
>>>>>>>> count: 1,
>>>>>>>> key 0x61d6
>>>>>>>> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 1,
>>>>>>>> count: 2,
>>>>>>>> key 0x61d6
>>>>>>>
>>>>>>> I pressed all the buttons on the remote (40 buttons).
>>>>>>
>>>>>> Did you cut the dmesg output ? Or do you really get these
>>>>>> messages for
>>>>>> key 0x61d6 only ?
>>>>>
>>>>> Correct, I only got the messages for key 0x61d6 regardless of which
>>>>> physical button I press.
>>>>
>>>> So if Matthew didn't make any mistakes, the problem seems to be the
>>>> read
>>>> count handling...
>>>
>>> That is what happened and it is correct behavior as Matthews remote is
>>> 24 bit NEC (and driver does not know how to handle it). If you look
>>> again those raw dumps which I send previous mail you could see the
>>> issue. 61d6 seen here is remote controller address, two first bits. It
>>> outputs that because debug does not output rest 2 remaining bytes
>>> where is actual key code. If you set em28xx to 32bit NEC mode then key
>>> code for that remote set 61d6 by driver mistakenly as it does not know
>>> there is 2 bytes more to handle.
>>
>> Antti, the problem with Matthews RC isn't the number of bytes printed to
>> the log.
>> The problems is, that NO messages appear in the log (with one
>> exception).
>
> What is that exception?
>
> In that case there should be around 40 similar debug lines - as
> address byte is same for all buttons and debug prints only address
> byte, toggle and count.

That's what I mean. He said he didn't cut dmesg.


> As toggle and count still outputs some numbers we will see that many
> line. Without toggle and count there is likely only one debug line
> seen as output is piped through uniq which drops similar lines.
>
>>> I copy & pasted here relevant lines from the em28xx driver. Maybe you
>>> could now see why code is wrong - why the extended address byte is set
>>> as to scancode mistakenly. Look especially care following variables:
>>> msg[1], msg[2], poll_result->rc_address and poll_result.rc_data[0]
>>>
>>> static int em2874_polling_getkey()
>>> {
>>> rc = dev->em28xx_read_reg_req_len(dev, 0, EM2874_R51_IR, msg,
>>> sizeof(msg));
>>>
>>> /* Remote Control Address (Reg 0x52) */
>>> poll_result->rc_address = msg[1];
>>>
>>> /* Remote Control Data (Reg 0x53-55) */
>>> poll_result->rc_data[0] = msg[2];
>>> poll_result->rc_data[1] = msg[3];
>>> poll_result->rc_data[2] = msg[4];
>>> }
>>>
>>
>> You missed the relevant part of the code:
>>
>> static int em2874_polling_getkey()
>> {
>> ...
>>      /* Infrared read count (Reg 0x51[6:0] */
>>      poll_result->read_count = (msg[0] & 0x7f);
>> ...
>> }
>>
>>
>>>
>>>
>>> static void em28xx_ir_handle_key()
>>> {
>>> dprintk("%s: toggle: %d, count: %d, key 0x%02x%02x\n", __func__,
>>>      poll_result.toggle_bit, poll_result.read_count,
>>>      poll_result.rc_address, poll_result.rc_data[0]);
>>> }
>>>
>>
>> Same here, you missed the if () statement:
>>
>> static void em28xx_ir_handle_key(struct em28xx_IR *ir)
>> {
>> ...
>>      if (unlikely(poll_result.read_count != ir->last_readcount)) {
>>          dprintk("%s: toggle: %d, count: %d, key 0x%02x%02x\n",
>> __func__,
>>              poll_result.toggle_bit, poll_result.read_count,
>>              poll_result.rc_address, poll_result.rc_data[0]);
>> ...
>> }
>>
>>
>> It doesn't matter which format the scancode (4 bytes) has, a message
>> should be printed in any case.
>> But according to Matthew, that doesn't happen. Hence, the
>> poll_result.read_count != ir->last_readcount must be the problem.
>
> I don't see which messages are missing.
>
> I think read_count is not incremented in case NEC 16bit checksum fails
> - hw just discards whole code => read_count not increase => no debug.
> For my tests there was always 81/01 when key was pressed and 00 when
> no key pressed (as seen also logs I posted yesterday).

I don't know, I don't have the data sheet, I don't have the hardware and
I didn't make the test myself.
If you are sure you can declare it working, fine.

Care to fix the tuner issues ?

Regards,
Frank

>
>>> I am about 99% sure Mauro's patch works correctly for Matthews device.
>>>
>>
>> If Matthew didn't make any mistakes, I can't see how these patches can
>> make it work. Which doesn't mean that they don't make sense.
>>
>>
>> Matthew, could you please validate your test results and try Mauros
>> patches ?
>> If it doesn't work, please create another USB-log.
>>
>>
>>> Maybe you missed point hardware returns different format in case of
>>> 32bit and 16bit values. If it is 16bit mode it return only 2 bytes and
>>> if 32bit mode it returns 4 bytes?
>>>
>>
>> No.
>>
>>
>> Regards,
>> Frank
>
> regards
> Antti
>

