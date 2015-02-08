Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:40072 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbbBHLn4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Feb 2015 06:43:56 -0500
Date: Sun, 8 Feb 2015 12:36:24 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media:firewire:Remove unneeded function
 definition,avc_tuner_host2ca
Message-ID: <20150208123624.21bf9c53@kant>
In-Reply-To: <1423371875-11662-1-git-send-email-xerofoify@gmail.com>
References: <1423371875-11662-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Feb 08 Nicholas Krause wrote:
> Removes the function,avc_tuner_host2ca and the ifdef marco statements
> around this function as there are no more callers of this function
> and therefor no need for it's definition anymore.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Your changelog is incorrect.  If you had checked the history, you would
have learned that the function was added without callers in the first
place and never gained any callers since then.

How about first checking what the Host2CA AV/C command is for, and then
deciding on whether to add proper usage of it or to drop its implementation
from the source for good.

> ---
>  drivers/media/firewire/firedtv-avc.c | 31 -------------------------------
>  1 file changed, 31 deletions(-)
> 
> diff --git a/drivers/media/firewire/firedtv-avc.c b/drivers/media/firewire/firedtv-avc.c
> index 251a556..a7f2617 100644
> --- a/drivers/media/firewire/firedtv-avc.c
> +++ b/drivers/media/firewire/firedtv-avc.c
> @@ -912,37 +912,6 @@ void avc_remote_ctrl_work(struct work_struct *work)
>  	avc_register_remote_control(fdtv);
>  }
>  
> -#if 0 /* FIXME: unused */
> -int avc_tuner_host2ca(struct firedtv *fdtv)
> -{
> -	struct avc_command_frame *c = (void *)fdtv->avc_data;
> -	int ret;
> -
> -	mutex_lock(&fdtv->avc_mutex);
> -
> -	c->ctype   = AVC_CTYPE_CONTROL;
> -	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
> -	c->opcode  = AVC_OPCODE_VENDOR;
> -
> -	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
> -	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
> -	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
> -	c->operand[3] = SFE_VENDOR_OPCODE_HOST2CA;
> -	c->operand[4] = 0; /* slot */
> -	c->operand[5] = SFE_VENDOR_TAG_CA_APPLICATION_INFO; /* ca tag */
> -	clear_operands(c, 6, 8);
> -
> -	fdtv->avc_data_length = 12;
> -	ret = avc_write(fdtv);
> -
> -	/* FIXME: check response code? */
> -
> -	mutex_unlock(&fdtv->avc_mutex);
> -
> -	return ret;
> -}
> -#endif
> -
>  static int get_ca_object_pos(struct avc_response_frame *r)
>  {
>  	int length = 1;



-- 
Stefan Richter
-=====-===== --=- -=---
http://arcgraph.de/sr/
