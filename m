Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59284 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbbHVRwf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:52:35 -0400
Date: Sat, 22 Aug 2015 14:52:29 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 33/39] fixup: dvb_tuner_info
Message-ID: <20150822145229.703af950@recife.lan>
In-Reply-To: <d4222ac1aba318967aef10bce248252efd040bf7.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
	<d4222ac1aba318967aef10bce248252efd040bf7.1440264165.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 22 Aug 2015 14:28:18 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
> index afcd02932a92..8fc8d3a98382 100644
> --- a/drivers/media/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb-core/dvb_frontend.h
> @@ -76,7 +76,8 @@ struct dvb_frontend;
>   * @bandwidth_max:	maximum frontend bandwidth supported
>   * @bandwidth_step:	frontend bandwidth step
>   *
> - * NOTE: step_size is in Hz, for terrestrial/cable or kHz for satellite
> + * NOTE: frequency parameters are in Hz, for terrestrial/cable or kHz for
> + * satellite.
>   */
>  struct dvb_tuner_info {
>  	char name[128];

Obviously this patch should be merged with patch 30/39. Forgot to
do it before sending this mailbomb.

Regards,
Mauro
