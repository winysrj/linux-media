Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57060 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbcGQI7M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 04:59:12 -0400
Subject: Re: [PATCH] af9035: fix dual tuner detection with PCTV 79e
To: =?UTF-8?Q?Stefan_P=c3=b6schel?= <basic.master@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <5783D80F.2040808@gmx.de>
 <8c71e2a3-ca04-0215-b3cb-c478afa9b1cb@iki.fi> <578A937E.4060502@gmx.de>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <d3013624-68cd-35da-3e1a-f1b190c67328@iki.fi>
Date: Sun, 17 Jul 2016 11:59:06 +0300
MIME-Version: 1.0
In-Reply-To: <578A937E.4060502@gmx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2016 11:05 PM, Stefan Pöschel wrote:
> Am 15.07.2016 um 08:21 schrieb Antti Palosaari:
>> Applied and PULL requested for 4.7.
>
> Great, thanks!
>
>> Anyhow, it does not apply for 4.6. You must backport that patch to 4.6
>> stable also!
>
> I have never done backporting before, so I need some advice I think:
> Am I right that I have to create the patch, now just based on tag "v4.6"
> of the media_tree repo?

Just make patch that compiles and works against kernel tag v4.6. No need 
to backport it to media_tree or media_build. It should go 4.6 kernel 
stable tree.

Antti


> And then move that patch (properly named) to the backports subdir of the
> media_build repo, with regarding modification of the backports.txt:
> Using an "add" entry under "[4.6.255]" and an "delete" entry under
> "[4.5.255]" (so that it just gets applied to 4.6.x) ?
>
> BTW I wonder about the status update of
> https://patchwork.linuxtv.org/patch/35337/ from "New" to "Superseeded"
> (instead of "Accepted")...why is this?
>
> Regards,
> 	Stefan
>
>
>> On 07/11/2016 08:31 PM, Stefan Pöschel wrote:
>>> The value 5 of the EEPROM_TS_MODE register (meaning dual tuner
>>> presence) is
>>> only valid for AF9035 devices. For IT9135 devices it is invalid and
>>> led to a
>>> false positive dual tuner mode detection with PCTV 79e.
>>> Therefore on non-AF9035 devices and with value 5 the driver now
>>> defaults to
>>> single tuner mode and outputs a regarding info message to log.
>>>
>>> This fixes Bugzilla bug #118561.
>>>
>>> Reported-by: Marc Duponcheel <marc@offline.be>
>>> Signed-off-by: Stefan Pöschel <basic.master@gmx.de>
>>> ---
>>>  drivers/media/usb/dvb-usb-v2/af9035.c | 50
>>> +++++++++++++++++++++++------------
>>>  drivers/media/usb/dvb-usb-v2/af9035.h |  2 +-
>>>  2 files changed, 34 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c
>>> b/drivers/media/usb/dvb-usb-v2/af9035.c
>>> index eabede4..ca018cd 100644
>>> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
>>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
>>> @@ -496,7 +496,8 @@ static int af9035_identify_state(struct
>>> dvb_usb_device *d, const char **name)
>>>  {
>>>      struct state *state = d_to_priv(d);
>>>      struct usb_interface *intf = d->intf;
>>> -    int ret;
>>> +    int ret, ts_mode_invalid;
>>> +    u8 tmp;
>>>      u8 wbuf[1] = { 1 };
>>>      u8 rbuf[4];
>>>      struct usb_req req = { CMD_FW_QUERYINFO, 0, sizeof(wbuf), wbuf,
>>> @@ -530,6 +531,36 @@ static int af9035_identify_state(struct
>>> dvb_usb_device *d, const char **name)
>>>          state->eeprom_addr = EEPROM_BASE_AF9035;
>>>      }
>>>
>>> +
>>> +    /* check for dual tuner mode */
>>> +    ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_TS_MODE, &tmp);
>>> +    if (ret < 0)
>>> +        goto err;
>>> +
>>> +    ts_mode_invalid = 0;
>>> +    switch (tmp) {
>>> +    case 0:
>>> +        break;
>>> +    case 1:
>>> +    case 3:
>>> +        state->dual_mode = true;
>>> +        break;
>>> +    case 5:
>>> +        if (state->chip_type != 0x9135 && state->chip_type != 0x9306)
>>> +            state->dual_mode = true;    /* AF9035 */
>>> +        else
>>> +            ts_mode_invalid = 1;
>>> +        break;
>>> +    default:
>>> +        ts_mode_invalid = 1;
>>> +    }
>>> +
>>> +    dev_dbg(&intf->dev, "ts mode=%d dual mode=%d\n", tmp,
>>> state->dual_mode);
>>> +
>>> +    if (ts_mode_invalid)
>>> +        dev_info(&intf->dev, "ts mode=%d not supported, defaulting to
>>> single tuner mode!", tmp);
>>> +
>>> +
>>>      ret = af9035_ctrl_msg(d, &req);
>>>      if (ret < 0)
>>>          goto err;
>>> @@ -698,11 +729,7 @@ static int af9035_download_firmware(struct
>>> dvb_usb_device *d,
>>>       * which is done by master demod.
>>>       * Master feeds also clock and controls power via GPIO.
>>>       */
>>> -    ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_TS_MODE, &tmp);
>>> -    if (ret < 0)
>>> -        goto err;
>>> -
>>> -    if (tmp == 1 || tmp == 3 || tmp == 5) {
>>> +    if (state->dual_mode) {
>>>          /* configure gpioh1, reset & power slave demod */
>>>          ret = af9035_wr_reg_mask(d, 0x00d8b0, 0x01, 0x01);
>>>          if (ret < 0)
>>> @@ -835,17 +862,6 @@ static int af9035_read_config(struct
>>> dvb_usb_device *d)
>>>      }
>>>
>>>
>>> -
>>> -    /* check if there is dual tuners */
>>> -    ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_TS_MODE, &tmp);
>>> -    if (ret < 0)
>>> -        goto err;
>>> -
>>> -    if (tmp == 1 || tmp == 3 || tmp == 5)
>>> -        state->dual_mode = true;
>>> -
>>> -    dev_dbg(&intf->dev, "ts mode=%d dual mode=%d\n", tmp,
>>> state->dual_mode);
>>> -
>>>      if (state->dual_mode) {
>>>          /* read 2nd demodulator I2C address */
>>>          ret = af9035_rd_reg(d,
>>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h
>>> b/drivers/media/usb/dvb-usb-v2/af9035.h
>>> index c91d1a3..1f83c92 100644
>>> --- a/drivers/media/usb/dvb-usb-v2/af9035.h
>>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.h
>>> @@ -113,7 +113,7 @@ static const u32 clock_lut_it9135[] = {
>>>   * 0  TS
>>>   * 1  DCA + PIP
>>>   * 3  PIP
>>> - * 5  DCA + PIP
>>> + * 5  DCA + PIP (AF9035 only)
>>>   * n  DCA
>>>   *
>>>   * Values 0, 3 and 5 are seen to this day. 0 for single TS and 3/5
>>> for dual TS.
>>>
>>

-- 
http://palosaari.fi/
