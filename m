Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37774 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbcDIRHF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Apr 2016 13:07:05 -0400
Subject: Re: AVerMedia HD Volar (A867) AF9035 + MXL5007T driver issues
To: Alessandro Radicati <alessandro@radicati.net>
References: <57083b12.ec3ec20a.eed91.1ea1SMTPIN_ADDED_BROKEN@mx.google.com>
 <CAO8Cc0qC79u_BBV3xaat3Cy6E2XB+GtJfJSf3aCJX==Q++BaXg@mail.gmail.com>
 <570851E4.30801@iki.fi> <57085943.5010805@iki.fi>
 <CAO8Cc0p2vw6g_qEVAL8BowU9394gpOJXYVcEbgbQo-e3mN3q0Q@mail.gmail.com>
 <57086642.4060003@iki.fi>
 <CAO8Cc0rwLVxGwotpLARM6H6rO+covxbmfYb5HH_5aP-KdbN-Xw@mail.gmail.com>
 <570910C7.8020606@iki.fi>
 <CAO8Cc0pHXTd_h4PZdE+k0mAcpHVwUcbgfmN4cqua7DVjcaUgoQ@mail.gmail.com>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	linux-media@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <570936B4.7030700@iki.fi>
Date: Sat, 9 Apr 2016 20:07:00 +0300
MIME-Version: 1.0
In-Reply-To: <CAO8Cc0pHXTd_h4PZdE+k0mAcpHVwUcbgfmN4cqua7DVjcaUgoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/09/2016 07:11 PM, Alessandro Radicati wrote:
> On Sat, Apr 9, 2016 at 4:25 PM, Antti Palosaari <crope@iki.fi> wrote:
>> On 04/09/2016 11:13 AM, Alessandro Radicati wrote:
>>>
>>> On Sat, Apr 9, 2016 at 4:17 AM, Antti Palosaari <crope@iki.fi> wrote:
>>>>
>>>> On 04/09/2016 04:52 AM, Alessandro Radicati wrote:
>>>>>
>>>>>
>>>>> On Sat, Apr 9, 2016 at 3:22 AM, Antti Palosaari <crope@iki.fi> wrote:
>>>>>>
>>>>>>
>>>>>> Here is patches to test:
>>>>>> http://git.linuxtv.org/anttip/media_tree.git/log/?h=af9035
>>>>>>
>>>>>
>>>>> I've done this already in my testing, and it works for getting a
>>>>> correct chip_id response, but only because it's avoiding the issue
>>>>> with the write/read case in the af9035 driver.  Don't have an
>>>>> af9015... perhaps there's a similar issue with that code or we are
>>>>> dealing with two separate issues since af9035 never does a repeated
>>>>> start?
>>>>
>>>>
>>>>
>>>> I am pretty sure mxl5007t requires stop between read and write. Usually
>>>> chips are not caring too much if it is repeated start or not, whilst
>>>> datasheets are often register read is S Wr S Rw P.
>>>>
>>>> Even af9035 i2c adapter implementation implements repeated start wrong, I
>>>
>>>
>>> Where does the assumption that CMD_I2C_RD should issue a repeated
>>> start sequence come from?  From the datasheet?  Maybe it was never
>>> intended as repeated start.  Perhaps if there is another stick  with
>>> mxl5007t and a chip that does repeated start, we can put this to bed.
>>
>>
>> Assumption was coming from it just does it as a single USB transaction.
>> Datasheet says there is no repeated start. And kernel I2C API says all
>> messages send using single i2c_transfer() should be send with repeated
>> start, so now it is violating it, but that's not the biggest problem...
>>
>
> Unfortunately there is no way around that problem, but at least it
> means that you can reduce the whole function to just read and write
> since at the I2C level nothing changes.
>
>>>> would not like to add anymore hacks there. It is currently ugly and
>>>> complex
>>>
>>>
>>> Bugfix != hack.  Don't see how putting the register address in the
>>> address fields is a hack (perhaps semantics around the fact that 0xFB
>>> is not really part of the address?); this is the only and intended way
>>> to use that command for write/read.
>>
>>
>> I did bunch of testing and find it is really wrong. Dumped out registers
>> from some tuner chips and those seems to be mostly off by one.
>>
>> I think that skeleton is correct way (and it ends about same you did)
>> if (msg[0].len == 0) // probe message, payload 0
>>    buf[0] = msg[0].len;
>>    buf[1] = msg[0].addr << 1;
>>    buf[2] = 0x00; /* reg addr len */
>>    buf[3] = 0x00; /* reg addr MSB */
>>    buf[4] = 0x00; /* reg addr LSB */
>> else if (msg[0].len == 1)
>>    buf[0] = msg[0].len;
>>    buf[1] = msg[0].addr << 1;
>>    buf[2] = 1; /* reg addr len */
>>    buf[3] = 0x00; /* reg addr MSB */
>>    buf[4] = msg[0].buf[0]; /* reg addr LSB */
>> else if (msg[0].len == 2)
>>    buf[0] = msg[0].len;
>>    buf[1] = msg[0].addr << 1;
>>    buf[2] = 2; /* reg addr len */
>>    buf[3] = msg[0].buf[0]; /* reg addr MSB */
>>    buf[4] = msg[0].buf[1]; /* reg addr LSB */
>> else
>>    buf[0] = msg[0].len;
>>    buf[1] = msg[0].addr << 1;
>>    buf[2] = 2; /* reg addr len */
>>    buf[3] = msg[0].buf[0]; /* reg addr MSB */
>>    buf[4] = msg[0].buf[1]; /* reg addr LSB */
>>    memcpy(&buf[5], msg[2].buf, msg[0].len - 2);
>>
>
> Yes, this is the same, except I kept the original behavior when write
> len > 2.  Hence with my patch the I2C bus would only see a read
> transaction.  With the above, you would write the first two bytes and
> ignore the rest, then read.  This may be worse than just doing a read
> because if a future tuner reg read setup/address is > 2 then you may
> get into a strange situation.  If that case needs to be addressed,
> then might as well get rid of the single write/read usb transaction
> and just support write or read.

Last else branch should do it - but no idea if it works at all and none 
of tuners are using it and it is very unlikely there will never be.

It is easy to test, but I suspect if you write S Wr[11 11 12 13] P S Rw 
P it will return value from register 13 on a case chip supports writing 
multiple registers using reg address auto-increment as usually.

>>>> as hell. I should be re-written totally in any case. Those tuner I2C
>>>> adapters should be moved to demod. Demod has 1 I2C adapter. USB-bridge
>>>> has 2
>>>> adapters, one for each demod.
>>>>
>>>
>>> Agreed that it can be refactored and improved.  Also to support n
>>> transactions with a simple while loop and only issuing single writes
>>> and reads.  Only downside would be increased USB traffic for 2
>>> commands vs 1 - hence negligible.
>>
>>
>> there is i2c_adapter_quirks nowadays for these adapters which could do only
>> limited set of commands.
>> include/linux/i2c.h
>
> Perhaps just supporting write or read can be done with:
>
> struct i2c_adapter_quirks just_rw = {
> .flags=0,
> .max_num_msgs=1,
> .max_write_len=40,
> .max_read_len=40,
> };
>
> Otherwise as is:
>
> struct i2c_adapter_quirks as_is = {
> .flags=I2C_AQ_COMB_WRITE_THEN_READ,
> .max_num_msgs=2,
> .max_write_len=40,
> .max_read_len=40,
> .max_comb_1st_msg_len=2,
> .max_comb_2nd_msg_len=40,
> };
>
>>
>> In my understanding that is how those chips are wired:
>> +---------------+     +--------+
>> | I2C adapter-1 | --> | eeprom |
>> +---------------+     +--------+
>> +---------------+     +---------+     +---------+
>> | I2C adapter-2 | --> | demod-1 | --> | tuner-1 |
>> +---------------+     +---------+     +---------+
>> +---------------+     +---------+     +---------+
>> | I2C adapter-3 | --> | demod-2 | --> | tuner-2 |
>> +---------------+     +---------+     +---------+
>>
>
> I just have one demod, but as a clue, the address you provided to set
> the tuner I2C speed is named like this in the OEM linux driver:
>
> p_reg_lnk2ofdm_data_63_56
>
>>>> I have to find out af9015 datasheets and check how it is there. But I
>>>> still
>>>> remember one case where I implemented one FX2 firmware and that same
>>>> issues
>>>> raises there as well.
>>>>
>>>>>> After that both af9015+mxl5007t and af9035+mxl5007t started working.
>>>>>> Earlier
>>>>>> both were returning bogus values for chip id read.
>>>>>>
>>>>>> Also I am interested to known which kind of communication there is
>>>>>> actually
>>>>>> seen on I2C bus?
>>>>>
>>>>>
>>>>>
>>>>> With this or the patch I proposed, you see exactly what you expect on
>>>>> the I2C bus with repeated stops, as detailed in my previous mails.
>>>>
>>>>
>>>>
>>>> So it is good?
>>>>
>>>
>>> Yes, I2C looks good.
>>>
>>>>>> If it starts working then have to find out way to fix it properly so
>>>>>> that
>>>>>> any earlier device didn't broke.
>>>>>>
>>>>>
>>>>> I hope that by now I've made abundantly clear that my mxl5007t locks
>>>>> up after *any* read.  It doesn't matter if we are reading the correct
>>>>> register after any of the proposed patches.
>>>>
>>>>
>>>>
>>>> So it still locks up after any read after the chip id read? And does not
>>>> work then? On my devices I can add multiple mxl5007t_get_chip_id() calls
>>>> and
>>>> all are returning correct values.
>>>>
>>>
>>> No, as mentioned before, it locks up at the end of any read command.
>>> Including the chip_id.  The firmware is not aware of the issue and
>>> wont complain until the next I2C transaction.
>>
>>
>> Maybe I2C speed is too fast?
>> I tested with my device it failed when I increased speed to 850kHz. 640kHz
>> was working. I am not sure which is default speed and driver didn't change
>> it. Just try to dropping it to 142kHz (0x12).
>> Speed is calculated using that formula (0x12 in that case is register
>> value):
>> octave:36> 1000000 / (24.4 * 16 * 0x12)
>> ans =  142.304189435337
>>
>> These are related registers:
>> /* I2C master bus 2 clock speed 300k */
>> ret = af9035_wr_reg(d, 0x00f6a7, 0x07);
>> /* I2C master bus 1,3 clock speed 300k */
>> ret = af9035_wr_reg(d, 0x00f103, 0x07);
>>
>> Just add some good place before tuner attach like af9035_frontend_attach().
>>
>
> Found that the default value is 0x00 and results in ~97KHz SCL
> frequency.  Tested up to 0x3C which I measured to ~42KHz, but the bus
> still locks up.  Doesn't seem like speed is the problem.
>
>>>> Could you test what happens if you use that CMD_GENERIC_I2C_WR +
>>>> CMD_GENERIC_I2C_RD ? I suspect it is lower level I2C xfer than those
>>>> CMD_I2C_RD + CMD_I2C_WR, which are likely somehow handled by demod core.
>>>>
>>>
>>> I will test, but the issue is either electrical or with the state of
>>> the mxl5007t.  I2C bus looks good from AF9035 side once the bug in the
>>> above is patched.
>>
>>
>> If dropping I2C speed does not help then I cannot imagine any other fix than
>> adding mxl5007t driver option which disables problematic reads *or* add some
>> hack to af9035 i2c adapter implementation which fakes required problematic
>> commands ones that looks "good".
>>
>
> Unless there is a specific state in which the mxl5007t must be in for
> you to issue a read, I really don't know what else could be wrong.
> Would be nice to know if this issue happens with other demods to
> further justify the "no_probe" fix in the mxl5007t driver.

For me it works even device is ~same. It could be just some hw issues, 
too noisy bus or like that. Maybe different PCB revision.

My device ID is 07ca:0337, yours different. I think it is best add some 
quirk to af9035 i2c-adapter that it looks USB ID and returns fake values 
to mxl5007t driver in order to work-around issue. As thumb of rule all 
device specifics hacks should be added to interface driver leaving chip 
drivers hack free. So add some glue there and that's it. I cannot 
discover any better fix currently.

regards
Antti

-- 
http://palosaari.fi/
