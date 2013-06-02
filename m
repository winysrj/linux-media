Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:39265 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3FBVWj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 17:22:39 -0400
Received: by mail-we0-f181.google.com with SMTP id p58so1179084wes.12
        for <linux-media@vger.kernel.org>; Sun, 02 Jun 2013 14:22:38 -0700 (PDT)
Message-ID: <51ABB79B.60307@gmail.com>
Date: Sun, 02 Jun 2013 23:22:35 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	mkrufky@linuxtv.org
Subject: Re: [PATCH] rtl28xxu: fix buffer overflow when probing Rafael Micro
 r820t tuner
References: <1370199364-30060-1-git-send-email-gennarone@gmail.com> <51AB9D3F.4030804@iki.fi> <51ABA23A.7070500@gmail.com> <51ABA555.8050808@iki.fi>
In-Reply-To: <51ABA555.8050808@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 02/06/2013 22:04, Antti Palosaari ha scritto:
> On 06/02/2013 10:51 PM, Gianluca Gennari wrote:
>> Il 02/06/2013 21:30, Antti Palosaari ha scritto:
>>> On 06/02/2013 09:56 PM, Gianluca Gennari wrote:
>>>> req_r820t wants a buffer with a size of 5 bytes, but the buffer 'buf'
>>>> has a size of 2 bytes.
>>>>
>>>> This patch fixes the kernel oops with the r820t driver on old kernels
>>>> during the probe stage.
>>>> Successfully tested on a 2.6.32 32 bit kernel (Ubuntu 10.04).
>>>> Hopefully it will also help with the random stability issues reported
>>>> by some user on the linux-media list.
>>>>
>>>> This patch and https://patchwork.kernel.org/patch/2524651/
>>>> should go in the next 3.10-rc release, as they fix potential kernel
>>>> crashes.
>>>>
>>>> Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
>>>> ---
>>>>    drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>>>> b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>>>> index 22015fe..48f2e6f 100644
>>>> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>>>> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>>>> @@ -360,7 +360,7 @@ static int rtl2832u_read_config(struct
>>>> dvb_usb_device *d)
>>>>    {
>>>>        struct rtl28xxu_priv *priv = d_to_priv(d);
>>>>        int ret;
>>>> -    u8 buf[2];
>>>> +    u8 buf[5];
>>>>        /* open RTL2832U/RTL2832 I2C gate */
>>>>        struct rtl28xxu_req req_gate_open = {0x0120, 0x0011, 0x0001,
>>>> "\x18"};
>>>>        /* close RTL2832U/RTL2832 I2C gate */
>>>>
>>>
>>> Gianluca, could you make that probe to check chip id as usually. Read
>>> register 0x00 and check value 0x69. Also, please test if writing to that
>>> address different value will not change register value to see it is
>>> really chip id.
>>>
>>> regards
>>> Antti
>>>
>>
>> Hi Antti,
>> surely it makes sense. I will not have the time to check it until the
>> end of the coming week, so if someone else wants to do it in advance I
>> will not take offence ;-)
>>
>> Regards,
>> Gianluca
>>
> 
> Yeah. I would not like to extend that buf to 5 as it is not "proper"
> solution. Current check is more like just a check that there is some
> chip on that I2C address. Reading one byte makes as much sense as
> reading 5 bytes. Maybe Mauro has added that probe "lets implement it
> later" and then forget...

I found the time to do a quick test; this is the code:


	struct rtl28xxu_req req_r820t = {0x0034, CMD_I2C_RD, 1, buf};
	struct rtl28xxu_req req_r820t_write = {0x0034, CMD_I2C_WR, 1, buf};


[snip]

	/* check R820T ID register; reg=00 val=69 */
	ret = rtl28xxu_ctrl_msg(d, &req_r820t);
	if (ret == 0 && buf[0] == 0x69) {
		priv->tuner = TUNER_RTL2832_R820T;
		priv->tuner_name = "R820T";
		//goto found;
	}

	dev_info(&d->udev->dev, "r820t tuner ID: %d\n", buf[0]);
	buf[0] = 0;
	ret = rtl28xxu_ctrl_msg(d, &req_r820t_write);
	if (ret == 0) {
		dev_info(&d->udev->dev, "successfully wrote newr820t tuner ID: %d\n",
buf[0]);
	}
	
	ret = rtl28xxu_ctrl_msg(d, &req_r820t);
	if (ret == 0 && buf[0] == 0x69) {
		dev_info(&d->udev->dev, "Confirmed r820t tuner ID: %d\n", buf[0]);
	}
	dev_info(&d->udev->dev, "r820t tuner ID: %d\n", buf[0]);


and this is the result:

[ 3416.403807] usb 2-1.1: dvb_usb_v2: found a 'Realtek RTL2832U
reference design' in warm state
[ 3416.403855] usbcore: registered new interface driver dvb_usb_rtl28xxu
[ 3416.468531] usb 2-1.1: r820t tuner ID: 105
[ 3416.470657] usb 2-1.1: successfully wrote newr820t tuner ID: 0
[ 3416.472838] usb 2-1.1: Confirmed r820t tuner ID: 105
[ 3416.472842] usb 2-1.1: r820t tuner ID: 105
[ 3416.474934] usb 2-1.1: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[ 3416.474953] DVB: registering new adapter (Realtek RTL2832U reference
design)
[ 3416.491121] usb 2-1.1: DVB: registering adapter 0 frontend 0 (Realtek
RTL2832 (DVB-T))...
[ 3416.505607] r820t 0-001a: creating new instance
[ 3416.517646] r820t 0-001a: Rafael Micro r820t successfully identified
[ 3416.524730] Registered IR keymap rc-empty
[ 3416.524954] input: Realtek RTL2832U reference design as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/rc/rc0/input20
[ 3416.525133] rc0: Realtek RTL2832U reference design as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/rc/rc0
[ 3416.525141] usb 2-1.1: dvb_usb_v2: schedule remote query interval to
400 msecs
[ 3416.537261] usb 2-1.1: dvb_usb_v2: 'Realtek RTL2832U reference
design' successfully initialized and connected


so it looks OK. I will post a v2 patch.


> Northern part of Finland has has very warm weather now in two weeks and
> I haven't found any time to code now :D Crazy, 25-30 C degrees every
> day, hottest place in whole Europe :] I really hope it will go back to
> normal rainy and cold weather soon that I can jump back to coding...

LOL, you should take a vacation here in Italy: you will find all the
cold and rain you need to produce some nice code ;-)

Just make sure your hotel has free wi-fi, or you'll end up spending more
on Internet access than on food :P

> 
> regards
> Antti
> 

Regards,
Gianluca


