Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:48991 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758159AbaLJXj0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 18:39:26 -0500
Message-ID: <1418254749.18092.24.camel@perches.com>
Subject: Re: [PATCH v4 1/2] staging: media: lirc: lirc_zilog.c: fix quoted
 strings split across lines
From: Joe Perches <joe@perches.com>
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: m.chehab@samsung.com, jarod@wilsonet.com,
	gregkh@linuxfoundation.org, mahfouz.saif.elyazal@gmail.com,
	gulsah.1004@gmail.com, tuomas.tynkkynen@iki.fi,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Wed, 10 Dec 2014 15:39:09 -0800
In-Reply-To: <20141210223339.GA9397@biggie>
References: <20141210223339.GA9397@biggie>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2014-12-10 at 22:33 +0000, Luis de Bethencourt wrote:
> checkpatch makes an exception to the 80-colum rule for quotes strings, and
> Documentation/CodingStyle recommends not splitting quotes strings across lines
> because it breaks the ability to grep for the string. Fixing these.
[]
> diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
[]
> @@ -794,9 +796,9 @@ static int fw_load(struct IR_tx *tx)
>  	if (!read_uint8(&data, tx_data->endp, &version))
>  		goto corrupt;
>  	if (version != 1) {
> -		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected"
> -			    "1) -- please upgrade to a newer driver",
> -			    version);
> +		dev_err(tx->ir->l.dev,
> +			"unsupported code set file version (%u, expected 1) -- please upgrade to a newer driver",
> +			version);

Unrelated but this one should have a '\n' termination
at the end of the format.

