Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:53206 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbZCFNEQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2009 08:04:16 -0500
Message-ID: <49B11F4C.7080205@linuxtv.org>
Date: Fri, 06 Mar 2009 14:04:12 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab via Mercurial <mchehab@redhat.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Kconfig: replace DVB_FE_CUSTOMIZE
 to	DVB_FE_CUSTOMISE
References: <E1LfYFe-0006Vg-Ha@www.linuxtv.org>
In-Reply-To: <E1LfYFe-0006Vg-Ha@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

there are some more occurences of DVB_FE_CUSTOMIZE, e.g.:

Patch from Mauro Carvalho Chehab wrote:
> diff -r 37cf346278b2 -r 6f1afb4c6fab linux/drivers/media/video/au0828/Kconfig
[...]
>  	select MEDIA_TUNER_XC5000 if !DVB_FE_CUSTOMIZE
>  	select MEDIA_TUNER_MXL5007T if !DVB_FE_CUSTOMIZE
>  	select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE
> diff -r 37cf346278b2 -r 6f1afb4c6fab linux/drivers/media/video/cx23885/Kconfig
[...]
>  	select MEDIA_TUNER_MT2131 if !MEDIA_TUNER_CUSTOMIZE
>  	select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE
>  	select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE
> diff -r 37cf346278b2 -r 6f1afb4c6fab linux/drivers/media/video/pvrusb2/Kconfig
[...]
>  	select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE
>  	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMIZE
>  	select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE

Regards,
Andreas

