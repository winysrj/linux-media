Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:43113 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751343AbaKYU12 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 15:27:28 -0500
Message-ID: <1416947244.8358.12.camel@perches.com>
Subject: Re: [PATCH] staging: media: lirc: lirc_zilog.c: fix quoted strings
 split across lines
From: Joe Perches <joe@perches.com>
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: linux-kernel@vger.kernel.org, jarod@wilsonet.com,
	m.chehab@samsung.com, gregkh@linuxfoundation.org,
	mahfouz.saif.elyazal@gmail.com, dan.carpenter@oracle.com,
	tuomas.tynkkynen@iki.fi, gulsah.1004@gmail.com,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Date: Tue, 25 Nov 2014 12:27:24 -0800
In-Reply-To: <20141125201905.GA10900@biggie>
References: <20141125201905.GA10900@biggie>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2014-11-25 at 20:19 +0000, Luis de Bethencourt wrote:
> checkpatch makes an exception to the 80-colum rule for quotes strings, and
> Documentation/CodingStyle recommends not splitting quotes strings across lines
> because it breaks the ability to grep for the string. Fixing these.
[]
> diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
[]
> @@ -794,8 +792,7 @@ static int fw_load(struct IR_tx *tx)
>  	if (!read_uint8(&data, tx_data->endp, &version))
>  		goto corrupt;
>  	if (version != 1) {
> -		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected"
> -			    "1) -- please upgrade to a newer driver",
> +		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected1) -- please upgrade to a newer driver",
>  			    version);

Hello Luis.

Please look at the strings being coalesced before
submitting patches.

It's a fairly common defect to have either a missing
space between the coalesced fragments or too many
spaces.

It's almost certain that there should be a space
between the "expected" and "1" here.


