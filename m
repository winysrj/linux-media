Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38576 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab3FBUFS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Jun 2013 16:05:18 -0400
Message-ID: <51ABA555.8050808@iki.fi>
Date: Sun, 02 Jun 2013 23:04:37 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	mkrufky@linuxtv.org
Subject: Re: [PATCH] rtl28xxu: fix buffer overflow when probing Rafael Micro
 r820t tuner
References: <1370199364-30060-1-git-send-email-gennarone@gmail.com> <51AB9D3F.4030804@iki.fi> <51ABA23A.7070500@gmail.com>
In-Reply-To: <51ABA23A.7070500@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/02/2013 10:51 PM, Gianluca Gennari wrote:
> Il 02/06/2013 21:30, Antti Palosaari ha scritto:
>> On 06/02/2013 09:56 PM, Gianluca Gennari wrote:
>>> req_r820t wants a buffer with a size of 5 bytes, but the buffer 'buf'
>>> has a size of 2 bytes.
>>>
>>> This patch fixes the kernel oops with the r820t driver on old kernels
>>> during the probe stage.
>>> Successfully tested on a 2.6.32 32 bit kernel (Ubuntu 10.04).
>>> Hopefully it will also help with the random stability issues reported
>>> by some user on the linux-media list.
>>>
>>> This patch and https://patchwork.kernel.org/patch/2524651/
>>> should go in the next 3.10-rc release, as they fix potential kernel
>>> crashes.
>>>
>>> Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
>>> ---
>>>    drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>>> b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>>> index 22015fe..48f2e6f 100644
>>> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>>> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>>> @@ -360,7 +360,7 @@ static int rtl2832u_read_config(struct
>>> dvb_usb_device *d)
>>>    {
>>>        struct rtl28xxu_priv *priv = d_to_priv(d);
>>>        int ret;
>>> -    u8 buf[2];
>>> +    u8 buf[5];
>>>        /* open RTL2832U/RTL2832 I2C gate */
>>>        struct rtl28xxu_req req_gate_open = {0x0120, 0x0011, 0x0001,
>>> "\x18"};
>>>        /* close RTL2832U/RTL2832 I2C gate */
>>>
>>
>> Gianluca, could you make that probe to check chip id as usually. Read
>> register 0x00 and check value 0x69. Also, please test if writing to that
>> address different value will not change register value to see it is
>> really chip id.
>>
>> regards
>> Antti
>>
>
> Hi Antti,
> surely it makes sense. I will not have the time to check it until the
> end of the coming week, so if someone else wants to do it in advance I
> will not take offence ;-)
>
> Regards,
> Gianluca
>

Yeah. I would not like to extend that buf to 5 as it is not "proper" 
solution. Current check is more like just a check that there is some 
chip on that I2C address. Reading one byte makes as much sense as 
reading 5 bytes. Maybe Mauro has added that probe "lets implement it 
later" and then forget...

Northern part of Finland has has very warm weather now in two weeks and 
I haven't found any time to code now :D Crazy, 25-30 C degrees every 
day, hottest place in whole Europe :] I really hope it will go back to 
normal rainy and cold weather soon that I can jump back to coding...

regards
Antti

-- 
http://palosaari.fi/
