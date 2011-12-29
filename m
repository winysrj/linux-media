Return-path: <linux-media-owner@vger.kernel.org>
Received: from skyboo.net ([82.160.187.4]:47898 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752112Ab1L2KUt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 05:20:49 -0500
Message-ID: <4EFC3EF6.4000307@skyboo.net>
Date: Thu, 29 Dec 2011 11:20:38 +0100
From: Mariusz Bialonczyk <manio@skyboo.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Manu Abraham <abraham.manu@gmail.com>,
	Oliver Endriss <o.endriss@gmx.de>,
	Andreas Regel <andreas.regel@gmx.de>
References: <1322577083-24728-1-git-send-email-manio@skyboo.net>	<CAHFNz9KjVzH2RCKNWYH2DcwZXM1oNvSLXCx41Mk3cSiuTT7yaw@mail.gmail.com> <CAHFNz9KFO1ykuOP9YqJp1Tu+1uN4h__mjMhF6aRADocso0JE6g@mail.gmail.com>
In-Reply-To: <CAHFNz9KFO1ykuOP9YqJp1Tu+1uN4h__mjMhF6aRADocso0JE6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] stv090x: implement function for reading uncorrected blocks
 count
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/2011 07:48 PM, Manu Abraham wrote:
>> With UCB, what we imply is the uncorrectable blocks in the Outer
>> coding. The CRC encoder/decoder is at the Physical layer, much prior
>> and is completely different from what is expected of UCB.
>>
>> With the stv0900/3, you don't really have a Uncorrectable 's register
>> field, one would need to really calculate that out, rather than
>> reading out CRC errors.
> 
> Maybe you can try something like this:
> setup ERRCTRL1 to
> 
> Bit7-4:1100 (TS error count, packet error final)
> Bit3:reserved:0
> Bit2-0:000 (reset counter on read) 001 (without reset of counter on read)
> 
> and the resultant values can be read from
> ERRCNT10
> 
> Note that, you get the resultant values as Packet Errors, rather than
> bit errors, so you might need to multiply that by 8.
> 
> I have not tried this out. but you can possibly try it.
Thank you for your tips
I try it using the following code:

static int stv090x_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
{
  struct stv090x_state *state = fe->demodulator_priv;
  u32 reg, v;
  u32 val_header_err, val_packet_err;

  switch (state->delsys) {
  case STV090x_DVBS2:
    /* Reset the packet Error counter1 */
    if (STV090x_WRITE_DEMOD(state, ERRCTRL1, 0xc1) < 0)
      goto err;

    /* Obtain value */
    reg = STV090x_READ_DEMOD(state, ERRCNT10);
    v = STV090x_GETFIELD_Px(reg, ERR_CNT10_FIELD);

    *ucblocks = (v << 3);<->// value * 2^3
    break;
  default:
    return -EINVAL;
  }

  return 0;
err:
  dprintk(FE_ERROR, 1, "I/O error");
  return -1;
}

Unfortunately I always obtain value 0. I was also trying with DVB-S2 channel tunned for the whole night - and morning I still see 0 value.
Is it possible that it is normal when satellite installation is correctly set?
Maybe i need to wait for some difficulties - like snow on dish?
I think we may leave it as it is now if there's no UCB register...

Another thing related with this frontend:
I am not sure but I think that btw I found some c-p mistake. Please correct if I am wrong.
Here's the diff:

diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index e448851..dd02f9a 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -3531,7 +3531,7 @@ static int stv090x_read_per(struct dvb_frontend *fe, u32 *per)
        } else {
                /* Counter 2 */
                reg = STV090x_READ_DEMOD(state, ERRCNT22);
-               h = STV090x_GETFIELD_Px(reg, ERR_CNT2_FIELD);
+               h = STV090x_GETFIELD_Px(reg, ERR_CNT22_FIELD);
 
                reg = STV090x_READ_DEMOD(state, ERRCNT21);
                m = STV090x_GETFIELD_Px(reg, ERR_CNT21_FIELD);

regards,
-- 
Mariusz Białończyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
