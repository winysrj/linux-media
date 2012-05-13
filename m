Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44105 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab2EMRVK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 13:21:10 -0400
Message-ID: <4FAFED82.1000801@iki.fi>
Date: Sun, 13 May 2012 20:21:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
Subject: Re: [PATCH] Support for tuner FC0012, revised version 0.4
References: <201202222321.35533.hfvogt@gmx.net> <4F67CED1.407@redhat.com> <201203202314.35920.hfvogt@gmx.net> <201204010026.28542.hfvogt@gmx.net>
In-Reply-To: <201204010026.28542.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.04.2012 01:26, Hans-Frieder Vogt wrote:
> Support for tuner Fitipower FC0012, revised version 0.4.
> Changes compared to version 0.3:
> - write function for multiple bytes at once removed again (because the maximum allowable length of an i2c
> transfer may be different between various demodulators),
> - introduction of i2c_gate_ctrl calls,
> - usage of pr_debug instead of self designed deb_info,
> - corrected setting of priv->frequency. Error spotted by Michael Büsch, thanks very much!
> - replaced a few spaces with tabs (superfluous spaces also identified by Michael Büsch),
>
> The patch is against the snapshot linux-media-2012-03-28.
>
> Support for tuner Fitipower FC0012
>
> Signed-off-by: Hans-Frieder Vogt<hfvogt@gmx.net>

This patch is no longer valid as new version is sent. Please drop.

regards
Antti
-- 
http://palosaari.fi/
