Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-proxy002.phy.lolipop.jp ([157.7.104.43]:58814 "EHLO
        smtp-proxy002.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751359AbcJOLKS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Oct 2016 07:10:18 -0400
Subject: Re: [PATCH 03/57] [media] firewire: don't break long lines
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
 <9ef158ab98e90748612c9294fff02a621a1accea.1476475771.git.mchehab@s-opensource.com>
Cc: linux1394-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Message-ID: <8c0a43de-1c22-cf69-ca63-8dab838342c8@sakamocchi.jp>
Date: Sat, 15 Oct 2016 20:10:16 +0900
MIME-Version: 1.0
In-Reply-To: <9ef158ab98e90748612c9294fff02a621a1accea.1476475771.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Oct 15 2016 05:19, Mauro Carvalho Chehab wrote:
> Due to the 80-cols checkpatch warnings, several strings
> were broken into multiple lines. This is not considered
> a good practice anymore, as it makes harder to grep for
> strings at the source code. So, join those continuation
> lines.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

I prefer this patch because of the same reason in patch comment.

Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>

> ---
>  drivers/media/firewire/firedtv-avc.c | 5 +++--
>  drivers/media/firewire/firedtv-rc.c  | 5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/firewire/firedtv-avc.c b/drivers/media/firewire/firedtv-avc.c
> index 251a556112a9..e04235ea23fb 100644
> --- a/drivers/media/firewire/firedtv-avc.c
> +++ b/drivers/media/firewire/firedtv-avc.c
> @@ -1181,8 +1181,9 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int length)
>  		if (es_info_length > 0) {
>  			pmt_cmd_id = msg[read_pos++];
>  			if (pmt_cmd_id != 1 && pmt_cmd_id != 4)
> -				dev_err(fdtv->device, "invalid pmt_cmd_id %d "
> -					"at stream level\n", pmt_cmd_id);
> +				dev_err(fdtv->device,
> +					"invalid pmt_cmd_id %d at stream level\n",
> +					pmt_cmd_id);
>  
>  			if (es_info_length > sizeof(c->operand) - 4 -
>  					     write_pos) {
> diff --git a/drivers/media/firewire/firedtv-rc.c b/drivers/media/firewire/firedtv-rc.c
> index f82d4a93feb3..babfb9cee20e 100644
> --- a/drivers/media/firewire/firedtv-rc.c
> +++ b/drivers/media/firewire/firedtv-rc.c
> @@ -184,8 +184,9 @@ void fdtv_handle_rc(struct firedtv *fdtv, unsigned int code)
>  	else if (code >= 0x4540 && code <= 0x4542)
>  		code = oldtable[code - 0x4521];
>  	else {
> -		printk(KERN_DEBUG "firedtv: invalid key code 0x%04x "
> -		       "from remote control\n", code);
> +		printk(KERN_DEBUG
> +		       "firedtv: invalid key code 0x%04x from remote control\n",
> +		       code);
>  		return;
>  	}


Regards

Takashi Sakamoto
