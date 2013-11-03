Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:44474 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3KCKQE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 05:16:04 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVO00EGSN6SNO10@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sun, 03 Nov 2013 05:16:04 -0500 (EST)
Date: Sun, 03 Nov 2013 08:16:00 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Maik Broemme <mbroemme@parallels.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 06/12] dvb-core: export dvb_usercopy and new DVB device
 constants
Message-id: <20131103081600.163d5b86@samsung.com>
In-reply-to: <20131103003354.GJ7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
 <20131103003354.GJ7956@parallels.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 3 Nov 2013 01:33:54 +0100
Maik Broemme <mbroemme@parallels.com> escreveu:

> Added EXPORT_SYMBOL(dvb_usercopy) to allow new ddbridge driver to
> use it. It is questionable if I should use it in this way or not.
> If not I will fix it.

I don't like the idea of doing that. This likely means that ddbridge
is needing to do something else. The better is to add core support for
that, if pertinent, instead of moving the code to ddbridge.

> 
> Added two new DVB device constants DVB_DEVICE_CI and DVB_DEVICE_MOD
> required by newer ddbridge driver. Again it is questionable to use
> them or modify ddbridge driver.

Why those new types are needed? How those are used?

It could be needed, but then you should document them at DocBook.

It is probably better to open a separate thread to discuss those API
changes in separate (DVB C2 properties and those two new types of
devices).

> 
> Signed-off-by: Maik Broemme <mbroemme@parallels.com>
> ---
>  drivers/media/dvb-core/dvbdev.c | 1 +
>  drivers/media/dvb-core/dvbdev.h | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index 401ef64..e451e9e 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -438,6 +438,7 @@ out:
>  	kfree(mbuf);
>  	return err;
>  }
> +EXPORT_SYMBOL(dvb_usercopy);
>  
>  static int dvb_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
> diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
> index 93a9470..016c46e 100644
> --- a/drivers/media/dvb-core/dvbdev.h
> +++ b/drivers/media/dvb-core/dvbdev.h
> @@ -47,6 +47,8 @@
>  #define DVB_DEVICE_CA         6
>  #define DVB_DEVICE_NET        7
>  #define DVB_DEVICE_OSD        8
> +#define DVB_DEVICE_CI         9
> +#define DVB_DEVICE_MOD       10
>  
>  #define DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr) \
>  	static short adapter_nr[] = \


-- 

Cheers,
Mauro
