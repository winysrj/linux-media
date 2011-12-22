Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45997 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab1LVQpp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 11:45:45 -0500
Message-ID: <4EF35EB5.5010700@iki.fi>
Date: Thu, 22 Dec 2011 18:45:41 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: which is correct name DTMB or CTTB?
References: <4EF1ACA3.8080808@iki.fi>
In-Reply-To: <4EF1ACA3.8080808@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/21/2011 11:53 AM, Antti Palosaari wrote:
> I am adding DTMB/CTTB support for the Linux Kernel DVB API. Do anyone
> have clear idea which correct name?
>
> Background of that discussion can be found from the following patch:
> http://patchwork.linuxtv.org/patch/8827/

There is already defined delivery system SYS_DMBTH. It have been from 
the time S2API was introduced coming from the patch: 
6b73eeafbc856c0cef7166242f0e55403407f355

include/linux/dvb/frontend.h

Should I change that name? Or introduce new names using define? Or just 
leave it as it is. No single driver is using that because all existing 
DTMB/CTTB/DMB-TH drivers are abusing DVB-T...

I still think it is rather safe to change better one, there is likely no 
user space apps using that yet...

regards
Antti
-- 
http://palosaari.fi/
