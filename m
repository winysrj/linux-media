Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:52166 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab1L0MZo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 07:25:44 -0500
Message-ID: <4EF9B945.5080706@linuxtv.org>
Date: Tue, 27 Dec 2011 13:25:41 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 24/91] [media] em28xx-dvb: don't initialize drx-d
 non-used fields with zero
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com> <1324948159-23709-10-git-send-email-mchehab@redhat.com> <1324948159-23709-11-git-send-email-mchehab@redhat.com> <1324948159-23709-12-git-send-email-mchehab@redhat.com> <1324948159-23709-13-git-send-email-mchehab@redhat.com> <1324948159-23709-14-git-send-email-mchehab@redhat.com> <1324948159-23709-15-git-send-email-mchehab@redhat.com> <1324948159-23709-16-git-send-email-mchehab@redhat.com> <1324948159-23709-17-git-send-email-mchehab@redhat.com> <1324948159-23709-18-git-send-email-mchehab@redhat.com> <1324948159-23709-19-git-send-email-mchehab@redhat.com> <1324948159-23709-20-git-send-email-mchehab@redhat.com> <1324948159-23709-21-git-send-email-mchehab@redhat.com> <1324948159-23709-22-git-send-email-mchehab@redhat.com> <1324948159-23709-23-git-send-email-mchehab@redhat.com> <1324948159-23709-24-git-send-email-mchehab@redhat.com> <1324948159-23709-25-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-25-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.12.2011 02:08, Mauro Carvalho Chehab wrote:
> There's no need to initialize unused fields with zero, as Kernel does
> it automatically. Don't do that, in order to save some space at the
> data segment.

No space is saved for members of a struct, unless the complete struct is
initialized to zero.

Anyway, it improves readability.

> This also allows the removal of the unused pll_set callback.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/video/em28xx/em28xx-dvb.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
> index 3868c1e..28be043 100644
> --- a/drivers/media/video/em28xx/em28xx-dvb.c
> +++ b/drivers/media/video/em28xx/em28xx-dvb.c
> @@ -302,10 +302,12 @@ static struct zl10353_config em28xx_zl10353_xc3028_no_i2c_gate = {
>  };
>  
>  static struct drxd_config em28xx_drxd = {
> -	.index = 0, .demod_address = 0x70, .demod_revision = 0xa2,
> -	.demoda_address = 0x00, .pll_address = 0x00,
> -	.pll_type = DRXD_PLL_NONE, .clock = 12000, .insert_rs_byte = 1,
> -	.pll_set = NULL, .osc_deviation = NULL, .IF = 42800000,
> +	.demod_address = 0x70,
> +	.demod_revision = 0xa2,
> +	.pll_type = DRXD_PLL_NONE,
> +	.clock = 12000,
> +	.insert_rs_byte = 1,
> +	.IF = 42800000,
>  	.disable_i2c_gate_ctrl = 1,
>  };
>  

