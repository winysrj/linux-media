Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49796 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1LFSsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 13:48:47 -0500
Received: by wgbdr13 with SMTP id dr13so6710998wgb.1
        for <linux-media@vger.kernel.org>; Tue, 06 Dec 2011 10:48:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHFNz9KjVzH2RCKNWYH2DcwZXM1oNvSLXCx41Mk3cSiuTT7yaw@mail.gmail.com>
References: <1322577083-24728-1-git-send-email-manio@skyboo.net>
	<CAHFNz9KjVzH2RCKNWYH2DcwZXM1oNvSLXCx41Mk3cSiuTT7yaw@mail.gmail.com>
Date: Wed, 7 Dec 2011 00:18:46 +0530
Message-ID: <CAHFNz9KFO1ykuOP9YqJp1Tu+1uN4h__mjMhF6aRADocso0JE6g@mail.gmail.com>
Subject: Re: [PATCH] stv090x: implement function for reading uncorrected
 blocks count
From: Manu Abraham <abraham.manu@gmail.com>
To: Mariusz Bialonczyk <manio@skyboo.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 7, 2011 at 12:04 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
> On Tue, Nov 29, 2011 at 8:01 PM, Mariusz Bialonczyk <manio@skyboo.net> wrote:
>> This patch add support for reading UNC blocks for stv090x frontend.
>> Partially based on stv0900 code by Abylay Ospan <aospan@netup.ru>
>>
>> Signed-off-by: Mariusz Bialonczyk <manio@skyboo.net>
>> ---
>>  drivers/media/dvb/frontends/stv090x.c |   32 +++++++++++++++++++++++++++++++-
>>  1 files changed, 31 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
>> index 52d8712..ad6141f 100644
>> --- a/drivers/media/dvb/frontends/stv090x.c
>> +++ b/drivers/media/dvb/frontends/stv090x.c
>> @@ -3687,6 +3687,35 @@ static int stv090x_read_cnr(struct dvb_frontend *fe, u16 *cnr)
>>        return 0;
>>  }
>>
>> +static int stv090x_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
>> +{
>> +       struct stv090x_state *state = fe->demodulator_priv;
>> +       u32 reg_0, reg_1;
>> +       u32 val_header_err, val_packet_err;
>> +
>> +       switch (state->delsys) {
>> +       case STV090x_DVBS2:
>> +               /* DVB-S2 delineator error count */
>> +
>> +               /* retrieving number for erronous headers */
>> +               reg_1 = stv090x_read_reg(state, STV090x_P1_BBFCRCKO1);
>> +               reg_0 = stv090x_read_reg(state, STV090x_P1_BBFCRCKO0);
>> +               val_header_err = MAKEWORD16(reg_1, reg_0);
>> +
>> +               /* retrieving number for erronous packets */
>> +               reg_1 = stv090x_read_reg(state, STV090x_P1_UPCRCKO1);
>> +               reg_0 = stv090x_read_reg(state, STV090x_P1_UPCRCKO0);
>> +               val_packet_err = MAKEWORD16(reg_1, reg_0);
>> +
>> +               *ucblocks = val_packet_err + val_header_err;
>
>
> With UCB, what we imply is the uncorrectable blocks in the Outer
> coding. The CRC encoder/decoder is at the Physical layer, much prior
> and is completely different from what is expected of UCB.
>
> With the stv0900/3, you don't really have a Uncorrectable 's register
> field, one would need to really calculate that out, rather than
> reading out CRC errors.

Maybe you can try something like this:
setup ERRCTRL1 to

Bit7-4:1100 (TS error count, packet error final)
Bit3:reserved:0
Bit2-0:000 (reset counter on read) 001 (without reset of counter on read)

and the resultant values can be read from
ERRCNT10

Note that, you get the resultant values as Packet Errors, rather than
bit errors, so you might need to multiply that by 8.

I have not tried this out. but you can possibly try it.

Regards,
Manu
