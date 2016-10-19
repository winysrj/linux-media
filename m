Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48604 "EHLO
        einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941306AbcJSOdV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:33:21 -0400
Date: Wed, 19 Oct 2016 09:56:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux1394-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 53/58] firewire: don't break long lines
Message-ID: <20161019095625.4f3579ad@kant>
In-Reply-To: <84c06fb2-d147-689d-8d42-ce6b1f400a1f@sakamocchi.jp>
References: <cover.1476822924.git.mchehab@s-opensource.com>
        <bce754e03eef20b560c05a33d7cf68f6030e68e7.1476822925.git.mchehab@s-opensource.com>
        <84c06fb2-d147-689d-8d42-ce6b1f400a1f@sakamocchi.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 19 Takashi Sakamoto wrote:
> --- a/drivers/media/firewire/firedtv-rc.c
> +++ b/drivers/media/firewire/firedtv-rc.c
> @@ -184,8 +184,9 @@ void fdtv_handle_rc(struct firedtv *fdtv, unsigned
> int code)
>  	else if (code >= 0x4540 && code <= 0x4542)
>  		code = oldtable[code - 0x4521];
>  	else {
> -		printk(KERN_DEBUG "firedtv: invalid key code 0x%04x "
> -		       "from remote control\n", code);
> +		dev_dbg(fdtv->device,
> +			"invalid key code 0x%04x from remote control\n",
> +			code);
>  		return;
>  	}
> 

Yes, dev_XYZ(fdtv->device, ...) is better here and is already used this
way throughout the firedtv driver.  firedtv-rc.c somehow fell through the
cracks when firedtv was made to use dev_XYZ().

(On an unrelated note, this reminds me that I still need to take care of
Mauro's patches "Add a keymap for FireDTV board" and "firedtv: Port it to
use rc_core" from May 28, 2012.)
-- 
Stefan Richter
-======----- =-=- =--==
http://arcgraph.de/sr/
