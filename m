Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:36840 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754689Ab1C1RUu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 13:20:50 -0400
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Mon, 28 Mar 2011 19:20:45 +0200
From: handygewinnspiel@gmx.de
In-Reply-To: <4D909B59.9040809@redhat.com>
Message-ID: <20110328172045.64750@gmx.net>
MIME-Version: 1.0
References: <4D909B59.9040809@redhat.com>
Subject: Re: [w_scan PATCH] Add Brazil support on w_scan
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

> This patch adds support for both ISDB-T and DVB-C @6MHz used in
> Brazil, and adds a new bit rate of 5.2170 MSymbol/s, found on QAM256
> transmissions at some Brazilian cable operators.

Good. :)

> While here, fix compilation with kernels 2.6.39 and later, where the
> old V4L1 API were removed (so, linux/videodev.h doesn't exist anymore).
> This is needed to compile it on Fedora 15 beta.

videodev.h should have never been in there. Was already reported and will be removed instead.

> @@ -1985,6 +1986,10 @@
>  		dvbc_symbolrate_min=dvbc_symbolrate_max=0;
>  		break;
>  	case FE_QAM:
> +		// 6MHz DVB-C uses lower symbol rates
> +		if (freq_step(channel, this_channellist) == 6000000) {
> +			dvbc_symbolrate_min=dvbc_symbolrate_max=17;
> +		}
>  		break;
>  	case FE_QPSK:
>  		// channel means here: transponder,

This one causes me headache, because this one has side-effects to all other DVB-C cases using 6MHz bandwidth.
Are there *any cases* around, where some country may use DVB-C with symbolrates other than 5.217Mbit/s? I know that for Europe there are many cases where low symbolrates are used, even if higher would be possible.

If there are any doubts, i would prefer a solution like this and add all countries know to use this srate:

  		dvbc_symbolrate_min=dvbc_symbolrate_max=0;
  		break;
  	case FE_QAM:
 +		// 6MHz DVB-C uses lower symbol rates
 +		switch (this_channellist) {
 +                       case DVBC_BR:
 +			      dvbc_symbolrate_min=dvbc_symbolrate_max=17;
 +                            break;
 +                       default:; 
 +		}
  		break;
  	case FE_QPSK:
  		// channel means here: transponder,


I need an valid answer which solution is better to accept this patch.

cheers,
Winfried
-- 
NEU: FreePhone - kostenlos mobil telefonieren und surfen!			
Jetzt informieren: http://www.gmx.net/de/go/freephone
