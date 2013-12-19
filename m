Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4297 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab3LSJVx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 04:21:53 -0500
Message-ID: <52B2BA92.8080706@xs4all.nl>
Date: Thu, 19 Dec 2013 10:21:22 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v3 6/7] rtl2832_sdr: convert to SDR API
References: <1387231688-8647-1-git-send-email-crope@iki.fi> <1387231688-8647-7-git-send-email-crope@iki.fi>
In-Reply-To: <1387231688-8647-7-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2013 11:08 PM, Antti Palosaari wrote:
> It was abusing video device API. Use SDR API instead.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 291 ++++++++++++++++++-----
>  1 file changed, 227 insertions(+), 64 deletions(-)
> 

A question: does this driver only do SDR, or does it also 
do 'regular' video and/or radio?

If it does, then how does it switch from one tuner mode to another?

E.g. from ANALOG_TV to RADIO to SDR?

During the Barcelona summit in 2012 we discussed this. See the last two
slides of my presentation:

http://linuxtv.org/downloads/presentations/media_ws_2012_EU/ambiguities2.odp

Basically this proposal was accepted provided that the code to handle tuner
ownership should be shared between DVB and V4L2.

I made an initial attempt for this here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/tuner

I never had the time to continue with it, but it might be useful for rtl2832.

Regards,

	Hans
