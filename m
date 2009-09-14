Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:58639 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbZINMjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 08:39:13 -0400
Received: by qyk30 with SMTP id 30so2514030qyk.5
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 05:39:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090914001447.GA15770@systol-ng.god.lan>
References: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com>
	 <20090907124934.GA8339@systol-ng.god.lan>
	 <37219a840909070718q47890f5bgbf76a00ea8826880@mail.gmail.com>
	 <20090907151809.GA12556@systol-ng.god.lan>
	 <37219a840909070912h3678fb2cm94102d7437bec5df@mail.gmail.com>
	 <20090908212733.GA19438@systol-ng.god.lan>
	 <37219a840909081457u610b9c65le6141e79567ab629@mail.gmail.com>
	 <20090909140147.GA24722@systol-ng.god.lan>
	 <303a8ee30909090808u46acfb49l760d660f8a28f503@mail.gmail.com>
	 <20090914001447.GA15770@systol-ng.god.lan>
Date: Mon, 14 Sep 2009 08:33:46 -0400
Message-ID: <303a8ee30909140533k728791b5p503701d4e6b14122@mail.gmail.com>
Subject: Re: [PATCH] tda18271 add FM filter selction + minor fixes
From: Michael Krufky <mkrufky@kernellabs.com>
To: Henk.Vergonet@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 13, 2009 at 8:14 PM,  <spam@systol-ng.god.lan> wrote:
>
> This patch adds support for FM filter selection. The tda18271 has two rf
> inputs RF_IN (45-864 MHz) and FM_IN (65-108 MHz). The code automatically
> enables the antialiasing filter for radio reception and depending on the
> FM input selected configures EB23 register.
>
> Additional fixes:
> - Fixed the temerature comensation, see revision history of TDA18271HD_4
>  spec.
> - Minor cosmetic change in the tda18271_rf_band[]
> - Fixed one value and removed a duplicate in tda18271_cid_target[]
>
> Signed-off-by: Henk.Vergonet@gmail.com
>
>

Henk,

Thank you for your patch.

I have some other tda18271 patches pending merge currently, so it will
be a few days before I'll be able to test and merge your patch.

In the meanwhile, I'd request that this single patch be broken down
into three separate patches, each with a description of the change and
sign-off.  I know that the patch you sent in is small, I just prefer
to apply changes separately.

Do you have FM radio working on the Zolid board after applying this?

Regards,

Mike
