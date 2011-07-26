Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:55705 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751443Ab1GZU5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 16:57:49 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: Linux Media Mailing List <linux-media@vger.kernel.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] drx-k: Fix QAM Annex C selection
Date: Tue, 26 Jul 2011 22:27:06 +0200
Cc: Ralph Metzler <rjkm@metzlerbros.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E2C0BF8.5090006@redhat.com>
In-Reply-To: <4E2C0BF8.5090006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107262227.07515@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 24 July 2011 14:11:36 Mauro Carvalho Chehab wrote:
> Ralph/Oliver,
> 
> As I said before,the DRX-K logic to select DVB-C annex A seems wrong.
> 
> Basically, it sets Annex A at setEnvParameters, but this var is not
> used anywhere.  However, as setParamParameters[2] is not used, I suspect
> that this is a typo.

Yes, it is a typo.
It has no impact for Annex A, and nobody uses Annex C here.

Acked-by: Oliver Endriss <o.endriss@gmx.de>

> The enclosed patch fixes it, but, on my tests here with devices with
> drx-3913k and drx-3926k, DVB-C is not working with the drxk_a3.mc firmware. 
> So, I'm not sure if the devices I have don't support that firmware,
> or if the DVB-C code is broken or is not supported by such firmware.
> 
> I'm getting the drxk_a3.mc via Documentation/dvb/get_dvb_firmware
> from:
> 	http://l4m-daten.de/files/DDTuner.zip

This firmware is guaranteed to work for the drx-3913k spin A3 only.

> With the firmware I'm using, SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM only
> accepts 1 parameter.
> 
> So, I can't actually test it.
> 
> Could you please double-check it?

Please note that the interface may be different for other versions of
the chip or firmware. So you have to be very careful, when you add
support for other DRXK chips.

> Fix the DRX-K logic to select DVB-C annex A
> 
> setEnvParameters, but this var is not used anywhere.  However, as 
> setParamParameters[2] is not used, it seems to be a typo.
> 
> The enclosed patch fixes it.
> 
> This patch was not tested.
> ...
>  	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM, 4, setParamParameters, 1, &cmdResult);
>  	if (status < 0) {
> +		u16 setEnvParameters[5] = { 0, 0, 0, 0, 0 };
>  		/* Fall-back to the simpler call */
>  		setParamParameters[0] = QAM_TOP_ANNEX_A;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Imho this line is a typo, too.
You can remove it, as setParamParameters[0] is initialised below.

>  		if (state->m_OperationMode == OM_QAM_ITU_C)
> @@ -5461,8 +5459,8 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
>  			setEnvParameters[0] = 0;
>  
>  		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 1, setEnvParameters, 1, &cmdResult);
> -	if (status < 0)
> -		goto error;
> +		if (status < 0)
> +			goto error;
>  
>  		setParamParameters[0] = state->m_Constellation; /* constellation     */
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  		setParamParameters[1] = DRXK_QAM_I12_J17;       /* interleave mode   */

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
