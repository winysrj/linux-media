Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:56885 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab0JMTKp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 15:10:45 -0400
Message-ID: <4CB60433.2010105@iki.fi>
Date: Wed, 13 Oct 2010 22:10:43 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: tvbox <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Support or LME2510(C) DM04/QQBOX USB DVB-S BOXES.
References: <1283459370.3368.23.camel@canaries-desktop>
In-Reply-To: <1283459370.3368.23.camel@canaries-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 09/02/2010 11:29 PM, tvbox wrote:
> DM04/QQBOX DVB-S USB BOX with LME2510C+SHARP:BS2F7HZ7395 or LME2510+LGTDQT-P001F tuner.

> +config DVB_USB_LME2510
> +	tristate "LME DM04/QQBOX DVB-S USB2.0 support"
> +	depends on DVB_USB
> +	select DVB_TDA10086 if !DVB_FE_CUSTOMISE
> +	select DVB_TDA826X if !DVB_FE_CUSTOMISE
> +	select DVB_STV0288 if !DVB_FE_CUSTOMISE
> +	select DVB_IX2505V if !DVB_FE_CUSTOMISE
> +	select IR_CORE
> +	help
> +	  Say Y here to support the LME DM04/QQBOX DVB-S USB2.0 .

Just for curious, is IR_CORE and DVB_USB both needed? DVB_USB also 
depends on IR_CORE ? This was only DVB-USB driver which does that.

Antti
-- 
http://palosaari.fi/
