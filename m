Return-path: <linux-media-owner@vger.kernel.org>
Received: from ybbsmtp506.mail.kks.yahoo.co.jp ([183.79.29.145]:26228 "HELO
	ybbsmtp506.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933141Ab2HQBRu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 21:17:50 -0400
Message-ID: <502D9A29.5070407@ybb.ne.jp>
Date: Fri, 17 Aug 2012 10:11:05 +0900
From: Akihiro TSUKADA <tsukada_akihiro@ybb.ne.jp>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dvb_frontend: Multistream support
References: <53381345139167@web11e.yandex.ru>
In-Reply-To: <53381345139167@web11e.yandex.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
> index 7c64c09..bec0cda 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
> @@ -368,11 +368,8 @@ struct dtv_frontend_properties {
>              u8 interleaving;
>          } layer[3];
> 
> - /* ISDB-T specifics */
> - u32 isdbs_ts_id;
> -
> - /* DVB-T2 specifics */
> - u32                     dvbt2_plp_id;
> + /* Multistream specifics */
> + u32 stream_id;
> 
>          /* ATSC-MH specifics */
>          u8 atscmh_fic_ver;

It would be nice if you would include a patch to replace isdbs_ts_id
in dvb/pt1/va1j5jf8007s.c, which is the only file to use the variable.
