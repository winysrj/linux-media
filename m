Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42668 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab3ATSIn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jan 2013 13:08:43 -0500
Message-ID: <50FC327B.6050903@iki.fi>
Date: Sun, 20 Jan 2013 20:07:55 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: mchehab@redhat.com, mkrufky@linuxtv.org, patricechotard@free.fr,
	kosio.dimitrov@gmail.com, liplianin@me.by, danny.kukawka@bisect.de,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] [media] use IS_ENABLED() macro
References: <1358659976-8767-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1358659976-8767-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2013 07:32 AM, Peter Senna Tschudin wrote:
> This patch introduces the use of IS_ENABLED() macro. For example,
> replacing:
>   #if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
>
> with:
>   #if IS_ENABLED(CONFIG_I2C)
>
> All changes made by this patch respect the same replacement pattern.
>
> Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

For my drivers

>   drivers/media/tuners/qt1010.h             | 2 +-
>   drivers/media/tuners/xc4000.h             | 2 +-

Acked-by: Antti Palosaari <crope@iki.fi>


Why you didn't changed all those drivers as once?

I was planning to do just similar change to all dvb drivers (I did it 
for DVB USB V2 remote controller already).

I have also changed some of my new driver printk() calls from these 
headers to new pr/dev _foo() style. Please, could you fix it also :)

regard
Antti

-- 
http://palosaari.fi/
