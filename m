Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38878 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185Ab2JEUwi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Oct 2012 16:52:38 -0400
Message-ID: <506F487F.5010903@iki.fi>
Date: Fri, 05 Oct 2012 23:52:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] mxl111sf: revert patch: fix error on stream stop in mxl111sf_ep6_streaming_ctrl()
References: <1349469857-21396-1-git-send-email-crope@iki.fi>
In-Reply-To: <1349469857-21396-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was wondering if that fix USB host controller reset I am seeing but it 
didn't :-(

Anyhow, that should be still fixed.

Oct  5 23:21:05 localhost kernel: [  216.670807] hub 2-0:1.0: >port 2 
disabled by hub (EMI?), re-enabling...
Oct  5 23:21:05 localhost kernel: [  216.670812] usb 2-2: >USB 
disconnect, device number 6
Oct  5 23:21:05 localhost kernel: [  216.671022] dvb-usb: recv bulk 
message failed: -108

Linux localhost.localdomain 3.5.4-2.fc17.x86_64 #1 SMP Wed Sep 26 
21:58:50 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

Same happens for latest 3.6/3.7 too:
Oct  5 23:28:37 localhost kernel: [  319.837639] usb 2-2: dvb_usb_v2: 
'Hauppauge WinTV-Aero-M' successfully initialized and connected
Oct  5 23:28:41 localhost kernel: [  324.551834] hub 2-0:1.0: port 2 
disabled by hub (EMI?), re-enabling...
Oct  5 23:28:41 localhost kernel: [  324.551849] usb 2-2: USB 
disconnect, device number 9
Oct  5 23:28:41 localhost kernel: [  324.561541] usb 2-2: dvb_usb_v2: 
usb_bulk_msg() failed=-71

Linux localhost.localdomain 3.6.0+ #4 SMP Fri Oct 5 23:09:53 EEST 2012 
x86_64 x86_64 x86_64 GNU/Linux

I am quite sure it is some problem (race condition) when powering off 
and starting frontends. It could be reproduced quite easily making 
tuning attempts quickly for frontend 0 and 1. Usually zap -f 1; zap -f 
0; zap -f 1; and kaboom, it reboots USB HCI. AMD SB700 USB HCI used.

When you do that fe switching slowly it does not happen.

regards
Antti


On 10/05/2012 11:44 PM, Antti Palosaari wrote:
> This reverts commits:
> 3fd7e4341e04f80e2605f56bbd8cb1e8b027901a
> [media] mxl111sf: remove an unused variable
> 3be5bb71fbf18f83cb88b54a62a78e03e5a4f30a
> [media] mxl111sf: fix error on stream stop in mxl111sf_ep6_streaming_ctrl()
>
> ...as bug behind these is fixed by the DVB USB v2.
>
> Cc: Michael Krufky <mkrufky@linuxtv.org>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/usb/dvb-usb-v2/mxl111sf.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> index efdcb15..fcfe124 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> @@ -343,6 +343,7 @@ static int mxl111sf_ep6_streaming_ctrl(struct dvb_frontend *fe, int onoff)
>   	struct mxl111sf_state *state = fe_to_priv(fe);
>   	struct mxl111sf_adap_state *adap_state = &state->adap_state[fe->id];
>   	int ret = 0;
> +	u8 tmp;
>
>   	deb_info("%s(%d)\n", __func__, onoff);
>
> @@ -353,13 +354,15 @@ static int mxl111sf_ep6_streaming_ctrl(struct dvb_frontend *fe, int onoff)
>   					      adap_state->ep6_clockphase,
>   					      0, 0);
>   		mxl_fail(ret);
> -#if 0
>   	} else {
>   		ret = mxl111sf_disable_656_port(state);
>   		mxl_fail(ret);
> -#endif
>   	}
>
> +	mxl111sf_read_reg(state, 0x12, &tmp);
> +	tmp &= ~0x04;
> +	mxl111sf_write_reg(state, 0x12, tmp);
> +
>   	return ret;
>   }
>
>


-- 
http://palosaari.fi/
