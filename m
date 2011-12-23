Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50833 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab1LYSX7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 13:23:59 -0500
Received: by wgbdr13 with SMTP id dr13so19374492wgb.1
        for <linux-media@vger.kernel.org>; Sun, 25 Dec 2011 10:23:58 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [RFCv1] add DTMB support for DVB API
Date: Fri, 23 Dec 2011 18:30:58 +0100
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <4EF3A171.3030906@iki.fi>
In-Reply-To: <4EF3A171.3030906@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112231830.59716.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

On Thursday, December 22, 2011 10:30:25 PM Antti Palosaari wrote:
> Rename DMB-TH to DTMB.
> 
> Add few new values for existing parameters.
> 
> Add two new parameters, interleaving and carrier.
> DTMB supports interleavers: 240 and 720.
> DTMB supports carriers: 1 and 3780.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/media/dvb/dvb-core/dvb_frontend.c |   19 ++++++++++++++++++-
>   drivers/media/dvb/dvb-core/dvb_frontend.h |    3 +++
>   include/linux/dvb/frontend.h              |   13 +++++++++++--
>   include/linux/dvb/version.h               |    2 +-
>   4 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c
> b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 821b225..ec2cbae 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -924,6 +924,8 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND +
> 1] = {
>   	_DTV_CMD(DTV_CODE_RATE_LP, 1, 0),
>   	_DTV_CMD(DTV_GUARD_INTERVAL, 1, 0),
>   	_DTV_CMD(DTV_TRANSMISSION_MODE, 1, 0),
> +	_DTV_CMD(DTV_CARRIER, 1, 0),

What would you think if instead of adding DTV_CARRIER (which indicates 
whether we are using single carrier or multi carrier, if I understand it 
correctly) we add a TRANSMISSION_MODE_SC.

Then TRANSMISSION_MODE_4K is the multi-carrier mode and TRANSMISSION_MODE_SC 
is the single-carrier mode. We save a new DTV-command.

I'm not making a secret of it, this is how we handled this inside DiBcom and 
it would simplify the integration of our drivers for this standard. This is 
planned to be done during the first half of 2012.

Comments?

--
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
