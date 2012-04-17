Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52331 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186Ab2DQLT3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 07:19:29 -0400
Message-ID: <4F8D51BE.7050808@iki.fi>
Date: Tue, 17 Apr 2012 14:19:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-media@vger.kernel.org
Subject: Re: [media] tda10071: NXP TDA10071 DVB-S/S2 driver
References: <20120417103330.GA13569@elgon.mountain>
In-Reply-To: <20120417103330.GA13569@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Dan,
and thank you. Comments below.

On 17.04.2012 13:33, Dan Carpenter wrote:
> Hi Antti,
>
> Smatch complains about a potential information leak.  I was hoping you
> could take a look.
>
> The patch de8e42035014: "[media] tda10071: NXP TDA10071 DVB-S/S2
> driver" from Aug 1, 2011, leads to the following warning:
> drivers/media/dvb/frontends/tda10071.c:322
> tda10071_diseqc_send_master_cmd()
> 	 error: memcpy() 'diseqc_cmd->msg' too small (6 vs 16)
>
>
> drivers/media/dvb/frontends/tda10071.c
>     290          if (diseqc_cmd->msg_len<  3 || diseqc_cmd->msg_len>  16) {
>                                                 ^^^^^^^^^^^^^^^^^^^^^^^^
> We cap ->msg_len at 16 here.  I wasn't able to figure out where the 16
> came from.  Or the 3 for that matter.

Those numbers are coming from include/linux/dvb/frontend.h struct 
dvb_diseqc_master_cmd. And initially values are from the DiSEqC spec.
But you are correct, it is bug. Upper limit for message len should be 6 
instead of 16 used currently. Likely just typo. Maybe I have done some 
len testing during the development and changed it temporarily 6 => 16 
and forgot switch back. Who knows...

>
>     291                  ret = -EINVAL;
>     292                  goto error;
>     293          }
>     294
>     295          /* wait LNB TX */
>     296          for (i = 500, tmp = 0; i&&  !tmp; i--) {
>     297                  ret = tda10071_rd_reg_mask(priv, 0x47,&tmp, 0x01);
>     298                  if (ret)
>     299                          goto error;
>     300
>     301                  usleep_range(10000, 20000);
>     302          }
>     303
>     304          dbg("%s: loop=%d", __func__, i);
>     305
>     306          if (i == 0) {
>     307                  ret = -ETIMEDOUT;
>     308                  goto error;
>     309          }
>     310
>     311          ret = tda10071_wr_reg_mask(priv, 0x47, 0x00, 0x01);
>     312          if (ret)
>     313                  goto error;
>     314
>     315          cmd.args[0x00] = CMD_LNB_SEND_DISEQC;
>     316          cmd.args[0x01] = 0;
>     317          cmd.args[0x02] = 0;
>     318          cmd.args[0x03] = 0;
>     319          cmd.args[0x04] = 2;
>     320          cmd.args[0x05] = 0;
>     321          cmd.args[0x06] = diseqc_cmd->msg_len;
>     322          memcpy(&cmd.args[0x07], diseqc_cmd->msg, diseqc_cmd->msg_len);
>                                          ^^^^^^^^^^^^^^^
> ->msg is only 6 bytes long so we're copying past the end of the array.
>
> Also cmd.arg is 0x1e (30) bytes long and we only copy 0x07 + 16 bytes
> into it so it leaves the last 7 bytes of cmd.args unitialized.  Btw,
> why are the sizes specified in hex instead of decimal here?
>
>     323          cmd.len = 0x07 + diseqc_cmd->msg_len;

What it happens now is that garbage data will be send to DiSEqC switch - 
in case of garbage data is sent from the user-space. Anyhow, I would 
like to rather move these kind of common validly checking to the 
DVB-core. Not only that case, but for the more commonly too. IMHO there 
is currently too general checking left for the individual drivers...

And for the usage of hex numbering - I don't remember. Overall I prefer 
hex numbering unless values are not clearly decimal ones, like 
frequencies. But I agree indexing like that is seems more readable when 
decimal numbering is used. I have generally used decimal numbering in 
such cases.

Feel free to sent patch - or I will fix it someday later when suitable 
time is found.

thanks,
Antti
-
http://palosaari.fi/
