Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47337 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933073Ab2ERUr1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 16:47:27 -0400
Message-ID: <4FB6B55D.4060500@iki.fi>
Date: Fri, 18 May 2012 23:47:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: linux-media@vger.kernel.org, pomidorabelisima@gmail.com
Subject: Re: [PATCH v5 0/5] support for rtl2832
References: <1> <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com>
In-Reply-To: <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good evening!

On 18.05.2012 21:47, Thomas Mair wrote:
> Good Evening!
>
> This is the corrected version of the patch series to support the
> RTL2832 demodulator. There where no major changes. The majority of
> the changes consist in fixing style issues and adhering to proper
> naming conventions.

Review done and seems to be OK for my eyes.

> The next question for me is how to proceed when including new
> devices. Poma already sent an extensive list a little while
> ago (http://patchwork.linuxtv.org/patch/10982/). Should they
> all be included at once, or should I wait until somone confirms
> they are working correctly and include them one by one?

It has been rule that device is added after known to work.

Unfortunately DVB USB do not support dynamic USB ID. In order to 
workaround that I have done some small hackish solution for the 
dvb_usb_rtl28xxu driver. Currently it works for RTL2831U based devices, 
but I see it could be easily extended for RTL2832U too by adding module 
parameter.

regards
Antti
-- 
http://palosaari.fi/
