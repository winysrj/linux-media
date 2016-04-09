Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41859 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbcDIBWO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Apr 2016 21:22:14 -0400
Subject: Re: AVerMedia HD Volar (A867) AF9035 + MXL5007T driver issues
To: Alessandro Radicati <alessandro@radicati.net>,
	Jose Alberto Reguero <jareguero@telefonica.net>
References: <57083b12.ec3ec20a.eed91.1ea1SMTPIN_ADDED_BROKEN@mx.google.com>
 <CAO8Cc0qC79u_BBV3xaat3Cy6E2XB+GtJfJSf3aCJX==Q++BaXg@mail.gmail.com>
 <570851E4.30801@iki.fi>
Cc: linux-media@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <57085943.5010805@iki.fi>
Date: Sat, 9 Apr 2016 04:22:11 +0300
MIME-Version: 1.0
In-Reply-To: <570851E4.30801@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is patches to test:
http://git.linuxtv.org/anttip/media_tree.git/log/?h=af9035

After that both af9015+mxl5007t and af9035+mxl5007t started working. 
Earlier both were returning bogus values for chip id read.

Also I am interested to known which kind of communication there is 
actually seen on I2C bus?

If it starts working then have to find out way to fix it properly so 
that any earlier device didn't broke.

regards
Antti

On 04/09/2016 03:50 AM, Antti Palosaari wrote:
> uh, how it could be so hard?
>
> I just made few tests and found 3 ways to read it. OK, one is that
> Alessandro already pointed out and I don't feel it correct. But those 2
> are one for look. CMD_I2C_WR / CMD_I2C_RD with 1st priority, then
> CMD_GENERIC_I2C_WR / CMD_GENERIC_I2C_RD....
>
> {
> u8 buf[MAX_XFER_SIZE];
> struct usb_req req = {0, 0, 0, buf, 0, buf};
> #if 0
> req.cmd = CMD_GENERIC_I2C_WR;
> req.wlen = 3 + 2;
> req.rlen = 0;
> buf[0] = 2; // write len
> buf[1] = 0x02; /* I2C bus */ // NOK 3, 1, 0
> buf[2] = 0x60 << 1; // I2C addr
> buf[3] = 0xfb; /* reg addr MSB */
> buf[4] = 0xd9; /* reg addr LSB */
> ret = af9035_ctrl_msg(d, &req);
> dev_dbg(&d->udev->dev, "1mxl5007t %02x\n", 0);
>
> req.cmd = CMD_GENERIC_I2C_RD;
> req.wlen = 3;
> req.rlen = 1;
> buf[0] = 1; // read len
> buf[1] = 0x02; /* I2C bus */ // NOK 3, 1, 0
> buf[2] = 0x60 << 1; // I2C addr
> ret = af9035_ctrl_msg(d, &req);
> dev_dbg(&d->udev->dev, "1mxl5007t %02x\n", buf[0]);
> #endif
>
> #if 0
> req.cmd = CMD_I2C_RD;
> req.wlen = 5;
> req.rlen = 1;
> buf[0] = 1; // read len
> buf[1] = 0x60 << 1; // I2C addr
> buf[2] = 2; /* reg addr len */
> buf[3] = 0xfb; /* reg addr MSB */
> buf[4] = 0xd9; /* reg addr LSB */
> ret = af9035_ctrl_msg(d, &req);
> dev_dbg(&d->udev->dev, "4mxl5007t %02x\n", buf[0]);
> #endif
>
> #if 1
> req.cmd = CMD_I2C_WR;
> req.wlen = 7;
> req.rlen = 0;
> buf[0] = 2; // write len msg[0].len;
> buf[1] = 0x60 << 1; // I2C addr
> buf[2] = 0x00; /* reg addr len */
> buf[3] = 0x00; /* reg addr MSB */
> buf[4] = 0x00; /* reg addr LSB */
> buf[5] = 0xfb;
> buf[6] = 0xd9;
> ret = af9035_ctrl_msg(d, &req);
> dev_dbg(&d->udev->dev, "9mxl5007t %02x\n", buf[0]);
>
> req.cmd = CMD_I2C_RD;
> req.wlen = 5;
> req.rlen = 1;
> buf[0] = 1; // read len
> buf[1] = 0x60 << 1; // I2C addr
> buf[2] = 0x00; /* reg addr len */
> buf[3] = 0x00; /* reg addr MSB */
> buf[4] = 0x00; /* reg addr LSB */
> ret = af9035_ctrl_msg(d, &req);
> dev_dbg(&d->udev->dev, "9mxl5007t %02x\n", buf[0]);
> #endif
> }
>
>
>
>
> On 04/09/2016 02:59 AM, Alessandro Radicati wrote:
>> Jose, Antti,
>> The no_probe option or similar is the only fix I could find (in fact i
>> was going to propose a similar patch to what you have).  I've tried
>> all combinations of firmware and also tried issuing the read command
>> to the tuner in different states (e.g. sleep, just after soft/hard
>> reset) to no avail.  I've modified AverMedia's linux driver to probe
>> as well, and the same thing happens.  I found the following behavior
>> in further testing:
>>
>> - I can arbitrarily read as many bytes as I want from any valid
>> register and the tuner will continue responding until the af9035
>> issues the expected NAK to signal the end of the read so that the
>> mxl5007t can release the bus.  The bus doesn't get released and it
>> stays stuck either high or low indefinitely so subsequent I2C commands
>> fail.
>> - Hard reset of the tuner by cycling af9035 GPIOH12 seems like the
>> only way to recover.  So mxl5007t is probably at fault.  Perhaps I2C
>> speed is too fast (SCL cycles at ~100KHz)?  Faulty hardware design of
>> the usb stick?
>> - Doesn't seem like the OEM drivers ever issue I2C read commands.
>> Maybe it's a known issue to them.
>>
>> I'm pretty much out of ideas to test.  Suggestions are welcome.
>> Otherwise I'll try to push through a patch for just "no_probe".
>>
>> Thanks,
>> Alessandro
>>
>> On Sat, Apr 9, 2016 at 1:13 AM, Jose Alberto Reguero
>> <jareguero@telefonica.net> wrote:
>>> I made a patch long time ago, but it was not accepted.
>>>
>>> https://patchwork.linuxtv.org/patch/16242/
>>>
>>> Jose Alberto
>>>
>>> El 06/04/2016 01:00, Alessandro Radicati <alessandro@radicati.net>
>>> escribió:
>>>>
>>>> On Wed, Apr 6, 2016 at 12:33 AM, Antti Palosaari <crope@iki.fi> wrote:
>>>>> I found one stick having AF9035 + MXL5007T. It is HP branded A867,
>>>>> so it
>>>>> should be similar. It seems to work all three 12.13.15.0 6.20.15.0
>>>>> firmwares:
>>>>> http://palosaari.fi/linux/v4l-dvb/firmware/af9035/
>>>>>
>>>>> mxl5007t 5-0060: creating new instance
>>>>> mxl5007t_get_chip_id: unknown rev (3f)
>>>>> mxl5007t_get_chip_id: MxL5007T detected @ 5-0060
>>>>>
>>>>> That is what AF9035 reports (with debug) as a chip version:
>>>>> dvb_usb_af9035: prechip_version=00 chip_version=03 chip_type=3802
>>>>>
>>>>>
>>>>> Do you have different chip version?
>>>>>
>>>>
>>>> I have a Sky Italy DVB stick with the same chip version.  I see that
>>>> you get the 0x3f response as well... that should be fixed by the I2C
>>>> patch I proposed.  However, your stick seems to handle the read
>>>> properly and process subsequent I2C commands - something that doesn't
>>>> happen with mine.  The vendor drivers in linux and windows never seem
>>>> issue the USB I2C commands to read from the tuner.  I'll test with
>>>> other firmware versions to see if something changes.
>>>>
>>>> Regards,
>>>> Alessandro
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
http://palosaari.fi/
