Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:50019 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab1FEPOD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Jun 2011 11:14:03 -0400
Received: from [94.248.226.13]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QTF1X-0004Js-3K
	for linux-media@vger.kernel.org; Sun, 05 Jun 2011 17:14:01 +0200
Message-ID: <4DEB9D32.2070105@mailbox.hu>
Date: Sun, 05 Jun 2011 17:13:54 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: xc4000  patches folded
References: <4DEB7E9E.6040102@redhat.com> <4DEB8B7E.6070507@redhat.com>
In-Reply-To: <4DEB8B7E.6070507@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/05/2011 03:58 PM, Mauro Carvalho Chehab wrote:

> Don't add \n\t\t at the beginning of the param_desc. Even the extra \t and \n
> format stuff in the middle of the description is unusual. It is better to avoid,
> as it may break scripts.

OK, I will remove the tabs. Is the use of \n allowed in the description?

> Please put all parameters together.

Does this mean that the macro definitions should be moved from between
the parameter definitions ?

> Don't add a card_type. Just add the features that are needed for
> XC4000_CARD_WINFAST_CX88 to work.

Yes, this is a change I have already planned. The following parameters
will be added to the priv and config structures:
  - the default enabling of power management
  - amplitude for DVB-T
The other conditionals might not actually be necessary, they were just
added to avoid changing the behavior of the driver with the PCTV 340e
which I cannot test. A third parameter could be added to enable/disable
the use of XREG_SMOOTHEDCVBS, although it is not really needed with the
currently supported cards (always enabling it should not be a problem).

> Please use a generic parameter. In this case, it seems that it is just
> disabling one video mode. I don't think you need this here, as the better
> is to disable such video mode in cx88. Hard to tell without seeing the
> cx88 code that adds support for the Winfast xc4000-based card.

I do not think making it card-specific is really needed. It is probably
best to just remove the card_type check here. Also, the code is there
only to improve support for old (1.2) firmware versions.

For xc4000.c and xc4000.h, is it enough to create the following three
patches, or should the changes be broken up into more smaller patches ?
  - removing the use of card_type
  - uncommenting the firmware version check
  - coding style / cleanup
