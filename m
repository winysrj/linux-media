Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab1ICQTW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Sep 2011 12:19:22 -0400
Message-ID: <4E625385.4050008@redhat.com>
Date: Sat, 03 Sep 2011 13:19:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] DVB: increment minor version after addition of SYS_TURBO
References: <1313503447-13743-1-git-send-email-obi@linuxtv.org> <1313503447-13743-2-git-send-email-obi@linuxtv.org>
In-Reply-To: <1313503447-13743-2-git-send-email-obi@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

Em 16-08-2011 11:04, Andreas Oberritter escreveu:
> Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
> ---
> Depends on https://patchwork.kernel.org/patch/1045472/
> 
>  include/linux/dvb/version.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
> index 1421cc8..66594b1 100644
> --- a/include/linux/dvb/version.h
> +++ b/include/linux/dvb/version.h
> @@ -24,6 +24,6 @@
>  #define _DVBVERSION_H_
>  
>  #define DVB_API_VERSION 5
> -#define DVB_API_VERSION_MINOR 3
> +#define DVB_API_VERSION_MINOR 4

Could you also please update the DocBooks for it?

Let's avoid increasing the gap between the specs and the
API.

Thank you!
Mauro
