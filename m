Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33744 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933267Ab1LFN6x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Dec 2011 08:58:53 -0500
Message-ID: <4EDE1F99.6080200@iki.fi>
Date: Tue, 06 Dec 2011 15:58:49 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	Stefan Ringel <linuxtv@stefanringel.de>
Subject: Re: [PATCH 2/2] [media] tm6000: Fix bad indentation.
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de> <1323178776-12305-1-git-send-email-thierry.reding@avionic-design.de> <1323178776-12305-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1323178776-12305-2-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That question is related to that kind of indentation generally, not only 
that patch.

On 12/06/2011 03:39 PM, Thierry Reding wrote:
> Function parameters on subsequent lines should never be aligned with the
> function name but rather be indented.
[...]
>   			usb_set_interface(dev->udev,
> -			dev->isoc_in.bInterfaceNumber,
> -			0);
> +					dev->isoc_in.bInterfaceNumber, 0);

Which kind of indentation should be used when function params are 
slitted to multiple lines?

In that case two tabs are used (related to function indentation).
example:
	ret= function(param1,
			param2);

Other generally used is only one tab (related to function indentation).
example:
	ret= function(param1,
		param2);

And last generally used is multiple tabs + spaces until same location 
where first param is meet (related to function indentation). I see that 
bad since use of tabs, with only spaces I see it fine. And this many 
times leads situation param level are actually different whilst 
originally idea was to put those same level.
example:
	ret= function(param1,
		      param2);


regards
Antti
-- 
http://palosaari.fi/
