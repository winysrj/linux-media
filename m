Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab1HTMRp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 08:17:45 -0400
Message-ID: <4E4FA5E0.8050606@redhat.com>
Date: Sat, 20 Aug 2011 05:17:36 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 6/6] EM28xx - don't sleep on disconnect
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com> <4E4D8DFD.5060800@yahoo.com> <4E4DFA65.4090508@redhat.com> <4E4F9C77.6010008@yahoo.com>
In-Reply-To: <4E4F9C77.6010008@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-08-2011 04:37, Chris Rankin escreveu:
> +
> +		if (dev->state & DEV_DISCONNECTED) {
> +			/* We cannot tell the device to sleep
> +			 * once it has been unplugged. */
> +			prevent_sleep(&dvb->fe[0]->ops);
> +			prevent_sleep(&dvb->fe[1]->ops);

This will cause an OOPS if dvb->fe[n] == NULL.

> +		}
> +

