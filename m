Return-path: <linux-media-owner@vger.kernel.org>
Received: from gpm.stappers.nl ([82.161.218.215]:49477 "EHLO gpm.stappers.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754237AbeDWJT2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 05:19:28 -0400
Date: Mon, 23 Apr 2018 11:09:34 +0200
From: Geert Stappers <stappers@stappers.nl>
To: mjs <mjstork@gmail.com>
Cc: "3 linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: How to proceed ? => [PATCH ?] EM28xx driver ?
Message-ID: <20180423090934.GB2485@gpm.stappers.nl>
References: <5add88aa.47de500a.4764d.a537@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5add88aa.47de500a.4764d.a537@mx.google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 23, 2018 at 09:18:01AM +0200, mjs wrote:
> to try to make a dvb-t ":ZOLID Hybrid TV Stick" to work with linux.
> 
> --- a/em28xx-cards.c
> +++ b/em28xx-cards.c
       ...
> @@ -3063,8 +3090,7 @@ void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl)
>  	case EM2880_BOARD_EMPIRE_DUAL_TV:
>  	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
>  	case EM2882_BOARD_TERRATEC_HYBRID_XS:
> -		ctl->demod = XC3028_FE_ZARLINK456;
> -		break;
> +	case EM2882_BOARD_ZOLID_HYBRID_TV_STICK:
>  	case EM2880_BOARD_TERRATEC_HYBRID_XS:
>  	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
>  	case EM2881_BOARD_PINNACLE_HYBRID_PRO:

The extra line makes sense,
the removed lines shall break  TERRATEC_HYBRID_XS


My appology for not telling you this earlier.

Cheers
Geert Stappers
