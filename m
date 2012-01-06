Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43867 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758968Ab2AFSZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 13:25:26 -0500
Received: by yenm11 with SMTP id m11so791151yen.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 10:25:25 -0800 (PST)
Date: Fri, 6 Jan 2012 12:25:19 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Hunold <michael@mihu.de>,
	Johannes Stezenbach <js@sig21.net>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 0/2] Re: [git:v4l-dvb/for_v3.3] [media] dvb-bt8xx: handle
 errors from dvb_net_init
Message-ID: <20120106182519.GE15740@elie.hsd1.il.comcast.net>
References: <E1RjBAD-0006Ue-NL@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <E1RjBAD-0006Ue-NL@www.linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab wrote:

> Subject: [media] dvb-bt8xx: handle errors from dvb_net_init
[...]
> [mchehab.redhat.com: codingstyle fix: printk() should include KERN_ facility level]
[...]
> --- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
> +++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
> @@ -782,7 +782,12 @@ static int __devinit dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
>  		goto err_remove_mem_frontend;
>  	}
>  
> -	dvb_net_init(&card->dvb_adapter, &card->dvbnet, &card->demux.dmx);
> +	result = dvb_net_init(&card->dvb_adapter, &card->dvbnet, &card->demux.dmx);
> +	if (result < 0) {
> +		printk(KERN_ERR,
> +		       "dvb_bt8xx: dvb_net_init failed (errno = %d)\n", result);

I think there is an extra comma here:

	$ make drivers/media/dvb/bt8xx/dvb-bt8xx.o
	  CHK     include/linux/version.h
	  CHK     include/generated/utsrelease.h
	  CALL    scripts/checksyscalls.sh
	  CC [M]  drivers/media/dvb/bt8xx/dvb-bt8xx.o
	drivers/media/dvb/bt8xx/dvb-bt8xx.c: In function ‘dvb_bt8xx_load_card’:
	drivers/media/dvb/bt8xx/dvb-bt8xx.c:788:10: warning: too many arguments for format [-Wformat-extra-args]

Perhaps it would be better to add the KERN_ levels throughout the file
with a separate patch.  Like this:

Jonathan Nieder (2):
  [media] dvb-bt8xx: use dprintk for debug statements
  [media] dvb-bt8xx: convert printks to pr_err()

 drivers/media/dvb/bt8xx/dvb-bt8xx.c |   41 +++++++++++++++++------------------
 1 files changed, 20 insertions(+), 21 deletions(-)
