Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:34529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab1FAQIq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 12:08:46 -0400
Message-ID: <4DE66405.4000803@redhat.com>
Date: Wed, 01 Jun 2011 13:08:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Make DVB NET configurable in the kernel.
References: <201105231511.44508.hselasky@c2i.net>
In-Reply-To: <201105231511.44508.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-05-2011 10:11, Hans Petter Selasky escreveu:
> --HPS
> 
> 
> dvb-usb-0012.patch
> 
> 
> From 7222450a9d6f96f652237c65019fb25f54586d01 Mon Sep 17 00:00:00 2001
> From: Hans Petter Selasky <hselasky@c2i.net>
> Date: Mon, 23 May 2011 14:43:35 +0200
> Subject: [PATCH] Make DVB NET configurable in the kernel.
> 
> Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
> ---
>  drivers/media/Kconfig                |   12 +++++++++++-
>  drivers/media/dvb/dvb-core/Makefile  |    4 +++-
>  drivers/media/dvb/dvb-core/dvb_net.h |   26 ++++++++++++++++++++++++++
>  3 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 6995940..dc61895 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -68,7 +68,6 @@ config VIDEO_V4L2_SUBDEV_API
>  
>  config DVB_CORE
>  	tristate "DVB for Linux"
> -	depends on NET && INET
>  	select CRC32
>  	help
>  	  DVB core utility functions for device handling, software fallbacks etc.
> @@ -85,6 +84,17 @@ config DVB_CORE
>  
>  	  If unsure say N.
>  
> +config DVB_NET
> +	bool "DVB Network Support"
> +	default (NET && INET)
> +	depends on NET && INET
> +	help
> +	  The DVB network support in the DVB core can
> +	  optionally be disabled if this
> +	  option is set to N.
> +
> +	  If unsure say Y.
> +
>  config VIDEO_MEDIA
>  	tristate
>  	default (DVB_CORE && (VIDEO_DEV = n)) || (VIDEO_DEV && (DVB_CORE = n)) || (DVB_CORE && VIDEO_DEV)
> diff --git a/drivers/media/dvb/dvb-core/Makefile b/drivers/media/dvb/dvb-core/Makefile
> index 0b51828..8f22bcd 100644
> --- a/drivers/media/dvb/dvb-core/Makefile
> +++ b/drivers/media/dvb/dvb-core/Makefile
> @@ -2,8 +2,10 @@
>  # Makefile for the kernel DVB device drivers.
>  #
>  
> +dvb-net-$(CONFIG_DVB_NET) := dvb_net.o
> +
>  dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o dvb_filter.o 	\
>  		 dvb_ca_en50221.o dvb_frontend.o 		\
> -		 dvb_net.o dvb_ringbuffer.o dvb_math.o
> +		 $(dvb-net-y) dvb_ringbuffer.o dvb_math.o
>  
>  obj-$(CONFIG_DVB_CORE) += dvb-core.o
> diff --git a/drivers/media/dvb/dvb-core/dvb_net.h b/drivers/media/dvb/dvb-core/dvb_net.h
> index 3a3126c..8a0907f 100644
> --- a/drivers/media/dvb/dvb-core/dvb_net.h
> +++ b/drivers/media/dvb/dvb-core/dvb_net.h
> @@ -32,6 +32,8 @@
>  
>  #define DVB_NET_DEVICES_MAX 10
>  
> +#ifdef CONFIG_DVB_NET
> +
>  struct dvb_net {
>  	struct dvb_device *dvbdev;
>  	struct net_device *device[DVB_NET_DEVICES_MAX];
> @@ -45,3 +47,27 @@ void dvb_net_release(struct dvb_net *);
>  int  dvb_net_init(struct dvb_adapter *, struct dvb_net *, struct dmx_demux *);
>  
>  #endif
> +
> +#ifndef CONFIG_DVB_NET
> +
> +struct dvb_dev_stub;
> +
> +struct dvb_net {
> +	struct dvb_dev_stub *dvbdev;
> +};
> +
> +static inline void dvb_net_release(struct dvb_net *dvbnet)
> +{
> +	dvbnet->dvbdev = 0;
> +}
> +
> +static inline int dvb_net_init(struct dvb_adapter *adap,
> +    struct dvb_net *dvbnet, struct dmx_demux *dmx)
> +{
> +	dvbnet->dvbdev = (void *)1;
> +	return 0;
> +}
> +
> +#endif
> +
> +#endif
> -- 1.7.1.1
--HPS

Patch is ok, but the code when DVB_NET is not defined can
be simpler.

So, I'm applying the following patch after yours:

commit 92e226848f32fb593f5da0f1d1c30b6a6ec429b6
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Wed Jun 1 13:03:12 2011 -0300

    dvb_net: Simplify the code if DVB NET is not defined
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-core/dvb_net.h b/drivers/media/dvb/dvb-core/dvb_net.h
index cfd2c46..1e53acd 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.h
+++ b/drivers/media/dvb/dvb-core/dvb_net.h
@@ -42,32 +42,25 @@ struct dvb_net {
 	struct dmx_demux *demux;
 };
 
-
 void dvb_net_release(struct dvb_net *);
 int  dvb_net_init(struct dvb_adapter *, struct dvb_net *, struct dmx_demux *);
 
-#endif
-
-#ifndef CONFIG_DVB_NET
-
-struct dvb_dev_stub;
+#else
 
 struct dvb_net {
-	struct dvb_dev_stub *dvbdev;
+	struct dvb_device *dvbdev;
 };
 
 static inline void dvb_net_release(struct dvb_net *dvbnet)
 {
-	dvbnet->dvbdev = 0;
 }
 
 static inline int dvb_net_init(struct dvb_adapter *adap,
 			       struct dvb_net *dvbnet, struct dmx_demux *dmx)
 {
-	dvbnet->dvbdev = (void *)1;
 	return 0;
 }
 
-#endif
+#endif /* ifdef CONFIG_DVB_NET */
 
 #endif
