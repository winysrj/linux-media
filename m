Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56687 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab1LGNz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 08:55:59 -0500
Received: by iakc1 with SMTP id c1so969493iak.19
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2011 05:55:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1111201746210.32047@urchin.earth.li>
References: <alpine.DEB.2.00.1111201746210.32047@urchin.earth.li>
Date: Wed, 7 Dec 2011 14:55:57 +0100
Message-ID: <CAL7owaDVVqeM_-8LReEgZSeWnwMMkb9mEt=DLXDV61f4_TOqTw@mail.gmail.com>
Subject: Re: [PATCH] Update dvb-t scan frequencies for uk-Oxford, following
 digital switchover
From: Christoph Pfister <christophpfister@gmail.com>
To: Nick Burch <v4l@gagravarr.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updated, thanks.

Christoph


2011/11/20 Nick Burch <v4l@gagravarr.org>:
> Hi All
>
> The scan channels file in dvb-apps/util/scan/dvb-t/uk-Oxford needs to be
> updated with the new frequencies for Oxford, UK, following the digital
> switchover here that happend a short time ago.
>
> Based on some public information, w_scan and some trial+error, I believe the
> patch below will update the file to the new frequencies
>
> Cheers
> Nick
>
> ------------
>
> --- a/util/scan/dvb-t/uk-Oxford Fri Oct 07 01:26:04 2011 +0530
> +++ b/util/scan/dvb-t/uk-Oxford Sun Nov 20 17:44:17 2011 +0000
> @@ -1,10 +1,26 @@
>  # UK, Oxford
> -# Auto-generated from http://www.dtg.org.uk/retailer/dtt_channels.html
> -# and http://www.ofcom.org.uk/static/reception_advice/index.asp.html
> -# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> -T 578000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
> -T 850000000 8MHz 2/3 NONE QAM64 2k 1/32 NONE
> +#
> +# Post-Switchover, found from a mixture of w_scan, trial+error
> +# and http://www.ukfree.tv/txdetail.php?a=SP567105
> +
> +# Local Channels, C51, details still TBA
>  T 713833000 8MHz 2/3 NONE QAM64 2k 1/32 NONE
> -T 721833000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
> -T 690000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
> -T 538000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
> +
> +# PSB1 BBC-A, C53+. Apparently 730.2 but actually looks to be 730.167
> +T 730167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> +
> +# ArqB (COM6), C55, 746.0
> +T 746000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> +
> +# PSB3 BBC-B, C57, 256QAM DVB-T2, TBA
> +# May well be wrong, needs a DVB-T2 tuner to be sure!
> +T 762000000 8MHz 2/3 NONE QAM256 8k 1/32 NONE
> +
> +# ArqA (COM5), C59-, Apparently 777.8 but actually looks to be 777.833
> +T 777833000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> +
> +# PSB2, D3+4, C60-, Apparently 785.0 but actually looks to be 785.833
> +T 785833000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> +
> +# SDN (COM4), C62, 802.0
> +T 802000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
>
> ------------
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
