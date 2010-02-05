Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933863Ab0BEVwh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 16:52:37 -0500
Message-ID: <4B6C931D.9020208@redhat.com>
Date: Fri, 05 Feb 2010 19:52:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Muralidharan Karicheri <mkaricheri@gmail.com>
CC: linux-media@vger.kernel.org, khilman@deeprootsystems.com,
	hverkuil@xs4all.nl
Subject: Re: [GIT PATCHES FOR 2.6.34] Support for vpfe-capture on DM365
References: <55a3e0ce1002050945k7595d541lb04976344ff91431@mail.gmail.com>
In-Reply-To: <55a3e0ce1002050945k7595d541lb04976344ff91431@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Muralidharan Karicheri wrote:
> Mauro,
> 
> Please pull from the following:-
> 
> The following changes since commit 84b74782ace1ae091c1b0e14ae2ee9bb720532ba:
>   Douglas Schilling Landgraf (1):
>         V4L/DVB: Fix logic for Leadtek winfast tv usbii deluxe
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/mkaricheri/vpfe-vpbe-video.git for_upstream
> 
> Murali Karicheri (6):
>       DaVinci - Adding platform & board changes for vpfe capture on DM365
>       V4L - vpfe capture - header files for ISIF driver
>       V4L - vpfe capture - source for ISIF driver on DM365

Hmm...
+static int isif_get_params(void __user *params)
+{
+       /* only raw module parameters can be set through the IOCTL */
+       if (isif_cfg.if_type != VPFE_RAW_BAYER)
+               return -EINVAL;
+
+       if (copy_to_user(params,
+                       &isif_cfg.bayer.config_params,
+                       sizeof(isif_cfg.bayer.config_params))) {

+/* Parameter operations */
+static int isif_set_params(void __user *params)
+{
+       struct isif_config_params_raw *isif_raw_params;
+       int ret = -EINVAL;
+
+       /* only raw module parameters can be set through the IOCTL */
+       if (isif_cfg.if_type != VPFE_RAW_BAYER)
+               return ret;
+
+       isif_raw_params = kzalloc(sizeof(*isif_raw_params), GFP_KERNEL);
+       if (NULL == isif_raw_params)
+               return -ENOMEM;
+
+       ret = copy_from_user(isif_raw_params,


It seems that you're defining some undocumented new userspace API here.

Cheers,
Mauro
