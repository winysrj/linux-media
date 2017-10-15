Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35328 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751792AbdJOMCN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 08:02:13 -0400
Subject: Re: [PATCH] Simplify major/minor non-dynamic logic
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <8382e556b1a2f30c4bf866f021b33577a64f9ebf.1507750393.git.mchehab@s-opensource.com>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <fa28ad3a-10c0-9006-b7c9-88fe9f4a1c44@gentoo.org>
Date: Sun, 15 Oct 2017 14:02:22 +0200
MIME-Version: 1.0
In-Reply-To: <8382e556b1a2f30c4bf866f021b33577a64f9ebf.1507750393.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 11.10.2017 um 21:36 schrieb Mauro Carvalho Chehab:
> changeset 6bbf7a855d20 ("media: dvbdev: convert DVB device types into an enum")
> added a new warning on gcc 6:
> 
>>> drivers/media/dvb-core/dvbdev.c:86:1: warning: control reaches end of non-void function [-Wreturn-type]
> 
> That's because gcc is not smart enough to see that all types are
> present at the switch. Also, the current code is not too optimized.
> 
How should the compiler know that "int type" will only contain values
0..8? dvb_register_adapter is not inlined.

> So, replace it to a more optimized one, based on a static table.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Fixes: 6bbf7a855d20 ("media: dvbdev: convert DVB device types into an enum")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
> I actually suggested this patch to be fold with changeset 6bbf7a855d20.
> Unfortunately, I actually forgot to do that (I guess I did, but on a different
> machine than the one I used today to pick it).
> 
> Anyway, that saves some code space with static minors and cleans up
> a warning. So, let's apply it.
> 
>  drivers/media/dvb-core/dvbdev.c | 28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index a53eb53a4fd5..060c60ddfcc3 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -68,22 +68,20 @@ static const char * const dnames[] = {
>  #else
>  #define DVB_MAX_IDS		4
>  
> -static int nums2minor(int num, enum dvb_device_type type, int id)
> -{
> -	int n = (num << 6) | (id << 4);
> +static const u8 minor_type[] = {
> +       [DVB_DEVICE_VIDEO]      = 0,
> +       [DVB_DEVICE_AUDIO]      = 1,
> +       [DVB_DEVICE_SEC]        = 2,
> +       [DVB_DEVICE_FRONTEND]   = 3,
> +       [DVB_DEVICE_DEMUX]      = 4,
> +       [DVB_DEVICE_DVR]        = 5,
> +       [DVB_DEVICE_CA]         = 6,
> +       [DVB_DEVICE_NET]        = 7,
> +       [DVB_DEVICE_OSD]        = 8,
> +};
>  
> -	switch (type) {
> -	case DVB_DEVICE_VIDEO:		return n;
> -	case DVB_DEVICE_AUDIO:		return n | 1;
> -	case DVB_DEVICE_SEC:		return n | 2;
> -	case DVB_DEVICE_FRONTEND:	return n | 3;
> -	case DVB_DEVICE_DEMUX:		return n | 4;
> -	case DVB_DEVICE_DVR:		return n | 5;
> -	case DVB_DEVICE_CA:		return n | 6;
> -	case DVB_DEVICE_NET:		return n | 7;
> -	case DVB_DEVICE_OSD:		return n | 8;
> -	}
> -}
> +#define nums2minor(num, type, id) \
> +       (((num) << 6) | ((id) << 4) | minor_type[type])

In this code it is problematic that a bad value of type will trigger an
invalid memory access.

>  
>  #define MAX_DVB_MINORS		(DVB_MAX_ADAPTERS*64)
>  #endif
> 

Regards
Matthias
