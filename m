Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60710 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaKBKOf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 05:14:35 -0500
Received: by mail-wi0-f173.google.com with SMTP id n3so4298234wiv.12
        for <linux-media@vger.kernel.org>; Sun, 02 Nov 2014 02:14:34 -0800 (PST)
Message-ID: <54560407.8080603@googlemail.com>
Date: Sun, 02 Nov 2014 11:14:31 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: tskd08@gmail.com, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH v3 6/7] v4l-utils/dvb: add COUNTRY property
References: <1414761224-32761-1-git-send-email-tskd08@gmail.com> <1414761224-32761-7-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414761224-32761-7-git-send-email-tskd08@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Hello Coverity detected that dvb_guess_user_country introduces a
resource leak (CID 1250445).

On 31/10/14 14:13, tskd08@gmail.com wrote:
> +enum dvb_country_t dvb_guess_user_country(void)
> +{
> +	char * buf, * pch, * pbuf;
> +	unsigned cat;
> +	enum dvb_country_t id = COUNTRY_UNKNOWN;
> +
> +	for (cat = 0; cat < sizeof(cats)/sizeof(cats[0]); cat++) {
> +
> +		// the returned char * should be "C", "POSIX" or something valid.
> +		// If valid, we can only *guess* which format is returned.
> +		// Assume here something like "de_DE.iso8859-1@euro" or "de_DE.utf-8"
> +		buf = secure_getenv(cats[cat]);
> +		if (! buf || strlen(buf) < 2)
> +			continue;
> +
> +		buf = strdup(buf);
> +		pbuf= buf;
> +
> +		if (! strncmp(buf, "POSIX", MIN(strlen(buf), 5)) ||
> +		    ! (strncmp(buf, "en", MIN(strlen(buf), 2)) && !isalpha(buf[2])) )
> +			continue;
> +
> +		// assuming 'language_country.encoding@variant'
> +
> +		// country after '_', if given
> +		if ((pch = strchr(buf, '_')))
> +			pbuf = pch + 1;
> +
> +		// remove all after '@', including '@'
> +		if ((pch = strchr(pbuf, '@')))
> +			*pch = 0;
> +
> +		// remove all after '.', including '.'
> +		if ((pch = strchr(pbuf, '.')))
> +			*pch = 0;
> +
> +		if (strlen(pbuf) == 2)
> +			id = dvb_country_a2_to_id(pbuf);
> +		free(buf);
> +		if (id != COUNTRY_UNKNOWN)
> +			return id;
> +	}
> +
> +	return COUNTRY_UNKNOWN;
> +}

pbuf / buf may get leaked due to the continue statement.

Could you please post a patch?

Thanks,
Gregor
