Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56970 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbaBFU1a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Feb 2014 15:27:30 -0500
Message-ID: <52F3F030.7040207@iki.fi>
Date: Thu, 06 Feb 2014 22:27:28 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David Jedelsky <david.jedelsky@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] stb0899: Fix DVB-S2 support for TechniSat SkyStar
 2 HD CI USB ID 14f7:0002
References: <1391679907-17876-1-git-send-email-david.jedelsky@gmail.com>
In-Reply-To: <1391679907-17876-1-git-send-email-david.jedelsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi David

On 06.02.2014 11:45, David Jedelsky wrote:
> My TechniSat SkyStar 2 HD CI USB ID 14f7:0002 wasn't tuning DVB-S2 channels.
> Investigation revealed that it doesn't read DVB-S2 registers out of stb0899.
> Comparison with usb trafic of the Windows driver showed the correct
> communication scheme. This patch implements it.
> The question is, whether the changed communication doesn't break other devices.
> But the read part of patched _stb0899_read_s2reg routine is now functinally
> same as (not changed) stb0899_read_regs which reads ordinrary DVB-S registers.
> Giving high chance that it should work correctly on other devices too.

That changes I2C functionality from STOP + START to repeated START. 
Current functionality looks also very weird, as there is 5 messages 
sent, all with STOP condition. I am not surprised if actually bug is 
still in adapter... Somehow it should be first resolved how those 
messages are send, with repeated START or STOP. And fix I2C client or 
adapter or both.

regards
Antti

>
> Signed-off-by: David Jedelsky <david.jedelsky@gmail.com>
> ---
>   drivers/media/dvb-frontends/stb0899_drv.c |   44 +++++++++++------------------
>   1 file changed, 17 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
> index 07cd5ea..3084cb2 100644
> --- a/drivers/media/dvb-frontends/stb0899_drv.c
> +++ b/drivers/media/dvb-frontends/stb0899_drv.c
> @@ -305,19 +305,20 @@ u32 _stb0899_read_s2reg(struct stb0899_state *state,
>   		.len	= 6
>   	};
>
> -	struct i2c_msg msg_1 = {
> -		.addr	= state->config->demod_address,
> -		.flags	= 0,
> -		.buf	= buf_1,
> -		.len	= 2
> +	struct i2c_msg msg[] = {
> +		{
> +			.addr	= state->config->demod_address,
> +			.flags	= 0,
> +			.buf	= buf_1,
> +			.len	= 2
> +		}, {
> +			.addr	= state->config->demod_address,
> +			.flags	= I2C_M_RD,
> +			.buf	= buf,
> +			.len	= 4
> +		}
>   	};
>
> -	struct i2c_msg msg_r = {
> -		.addr	= state->config->demod_address,
> -		.flags	= I2C_M_RD,
> -		.buf	= buf,
> -		.len	= 4
> -	};
>
>   	tmpaddr = stb0899_reg_offset & 0xff00;
>   	if (!(stb0899_reg_offset & 0x8))
> @@ -326,6 +327,7 @@ u32 _stb0899_read_s2reg(struct stb0899_state *state,
>   	buf_1[0] = GETBYTE(tmpaddr, BYTE1);
>   	buf_1[1] = GETBYTE(tmpaddr, BYTE0);
>
> +	/* Write address	*/
>   	status = i2c_transfer(state->i2c, &msg_0, 1);
>   	if (status < 1) {
>   		if (status != -ERESTARTSYS)
> @@ -336,28 +338,16 @@ u32 _stb0899_read_s2reg(struct stb0899_state *state,
>   	}
>
>   	/* Dummy	*/
> -	status = i2c_transfer(state->i2c, &msg_1, 1);
> -	if (status < 1)
> -		goto err;
> -
> -	status = i2c_transfer(state->i2c, &msg_r, 1);
> -	if (status < 1)
> +	status = i2c_transfer(state->i2c, msg, 2);
> +	if (status < 2)
>   		goto err;
>
>   	buf_1[0] = GETBYTE(stb0899_reg_offset, BYTE1);
>   	buf_1[1] = GETBYTE(stb0899_reg_offset, BYTE0);
>
>   	/* Actual	*/
> -	status = i2c_transfer(state->i2c, &msg_1, 1);
> -	if (status < 1) {
> -		if (status != -ERESTARTSYS)
> -			printk(KERN_ERR "%s ERR(2), Device=[0x%04x], Base address=[0x%08x], Offset=[0x%04x], Status=%d\n",
> -			       __func__, stb0899_i2cdev, stb0899_base_addr, stb0899_reg_offset, status);
> -		goto err;
> -	}
> -
> -	status = i2c_transfer(state->i2c, &msg_r, 1);
> -	if (status < 1) {
> +	status = i2c_transfer(state->i2c, msg, 2);
> +	if (status < 2) {
>   		if (status != -ERESTARTSYS)
>   			printk(KERN_ERR "%s ERR(3), Device=[0x%04x], Base address=[0x%08x], Offset=[0x%04x], Status=%d\n",
>   			       __func__, stb0899_i2cdev, stb0899_base_addr, stb0899_reg_offset, status);
>


-- 
http://palosaari.fi/
