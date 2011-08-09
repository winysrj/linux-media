Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38837 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab1HILGA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2011 07:06:00 -0400
Message-ID: <4E411493.7070803@iki.fi>
Date: Tue, 09 Aug 2011 14:05:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Harald Gustafsson <hgu1972@gmail.com>, mythtv-users@mythtv.org,
	linux-media@vger.kernel.org
Subject: Re: Anyone tested the DVB-T2 dual tuner TBS6280?
References: <CAC3jWv+c1HOqmo0B18Z3vWOwjr=RoPrN7sfR3bqzz4Tw7=fPAQ@mail.gmail.com> <1312887439.2249.38.camel@ares>
In-Reply-To: <1312887439.2249.38.camel@ares>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/09/2011 01:57 PM, Steve Kerrison wrote:
> This TBS card has only just been brought to my attention. I cannot tell
> what PCIe chip it uses and if it's supported. The alleged Linux driver
> download for it doesn't have the cxd2820r code in it, so I can't see
> that having much chance of working.

FE I2C addresses used are those CXD2820R ones so it is CXD2820R.
Frontend driver is binary and strings stripped out.


Antti
-- 
http://palosaari.fi/
