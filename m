Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:51788 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786Ab3CVLfX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 07:35:23 -0400
Received: by mail-ea0-f177.google.com with SMTP id r16so1300543ead.36
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2013 04:35:22 -0700 (PDT)
Message-ID: <514C41F7.2020201@gmail.com>
Date: Fri, 22 Mar 2013 12:35:19 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: media-tree build is broken
References: <514B4E97.6010903@googlemail.com> <20130322062551.1c42d65c@redhat.com>
In-Reply-To: <20130322062551.1c42d65c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 22/03/2013 10:25, Mauro Carvalho Chehab ha scritto:
> Em Thu, 21 Mar 2013 19:16:55 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> 
>> ...
>> Kernel: arch/x86/boot/bzImage is ready  (#2)
>> ERROR: "__divdi3" [drivers/media/common/siano/smsdvb.ko] undefined!
>> make[1]: *** [__modpost] Fehler 1
>> make: *** [modules] Fehler 2
>>
>>
>> Mauro, I assume this is caused by one of the recent Siano patches ?
> 
> I tried to debug this one, but I couldn't reproduce it here. Not sure why,
> but I'm not capable of producing those errors here for a long time.
> 
> Maybe the gcc compiler version currently provided with Fedora 18 doesn't
> require any library for 64-bit divisions, even when compiling for a
> 32 bits Kernel.
> 
> Anyway, I'm almost sure that the following patch fixes the issue.
> Please test.

Hi Mauro, Frank,
I can confirm the patch fixes the compilation problem.
Tested on a 32 bit Ubuntu 10.04, compiling the latest media_build tree.

Regards,
Gianluca


> 
> Regards,
> Mauro.
> 
> -
> 
> PATCH] [media] siano: use do_div() for 64-bits division
> 
> As reported by Frank Schäfer <fschaefer.oss@googlemail.com>:
> 	ERROR: "__divdi3" [drivers/media/common/siano/smsdvb.ko] undefined!
> 
> Reported-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
> index d965a7a..297f1b2 100644
> --- a/drivers/media/common/siano/smsdvb-main.c
> +++ b/drivers/media/common/siano/smsdvb-main.c
> @@ -22,6 +22,7 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/init.h>
> +#include <asm/div64.h>
>  
>  #include "dmxdev.h"
>  #include "dvbdev.h"
> @@ -244,6 +245,7 @@ static void smsdvb_update_per_slices(struct smsdvb_client_t *client,
>  {
>  	struct dvb_frontend *fe = &client->frontend;
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +	u64 tmp;
>  
>  	client->fe_status = sms_to_status(p->is_demod_locked, p->is_rf_locked);
>  	c->modulation = sms_to_modulation(p->constellation);
> @@ -272,8 +274,9 @@ static void smsdvb_update_per_slices(struct smsdvb_client_t *client,
>  	c->post_bit_count.stat[0].uvalue += p->ber_bit_count;
>  
>  	/* Legacy PER/BER */
> -	client->legacy_per = (p->ets_packets * 65535) /
> -			     (p->ts_packets + p->ets_packets);
> +	tmp = p->ets_packets * 65535;
> +	do_div(tmp, p->ts_packets + p->ets_packets);
> +	client->legacy_per = tmp;
>  }
>  
>  static void smsdvb_update_dvb_stats(struct smsdvb_client_t *client,
> @@ -803,7 +806,7 @@ static int smsdvb_read_snr(struct dvb_frontend *fe, u16 *snr)
>  	rc = smsdvb_send_statistics_request(client);
>  
>  	/* Preferred scale for SNR with legacy API: 0.1 dB */
> -	*snr = c->cnr.stat[0].svalue / 100;
> +	*snr = ((u32)c->cnr.stat[0].svalue) / 100;
>  
>  	led_feedback(client);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

