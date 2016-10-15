Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42454 "EHLO
        einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754452AbcJON7R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Oct 2016 09:59:17 -0400
Date: Sat, 15 Oct 2016 15:47:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        linux1394-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 03/57] [media] firewire: don't break long lines
Message-ID: <20161015154708.047ff2ba@kant>
In-Reply-To: <8c0a43de-1c22-cf69-ca63-8dab838342c8@sakamocchi.jp>
References: <cover.1476475770.git.mchehab@s-opensource.com>
        <9ef158ab98e90748612c9294fff02a621a1accea.1476475771.git.mchehab@s-opensource.com>
        <8c0a43de-1c22-cf69-ca63-8dab838342c8@sakamocchi.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 15 Takashi Sakamoto wrote:
> On Oct 15 2016 05:19, Mauro Carvalho Chehab wrote:
> > Due to the 80-cols checkpatch warnings, several strings
> > were broken into multiple lines. This is not considered
> > a good practice anymore, as it makes harder to grep for
> > strings at the source code. So, join those continuation
> > lines.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> I prefer this patch because of the same reason in patch comment.
> 
> Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>

Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

> > ---
> >  drivers/media/firewire/firedtv-avc.c | 5 +++--
> >  drivers/media/firewire/firedtv-rc.c  | 5 +++--
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/firewire/firedtv-avc.c b/drivers/media/firewire/firedtv-avc.c
> > index 251a556112a9..e04235ea23fb 100644
> > --- a/drivers/media/firewire/firedtv-avc.c
> > +++ b/drivers/media/firewire/firedtv-avc.c
> > @@ -1181,8 +1181,9 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int length)
> >  		if (es_info_length > 0) {
> >  			pmt_cmd_id = msg[read_pos++];
> >  			if (pmt_cmd_id != 1 && pmt_cmd_id != 4)
> > -				dev_err(fdtv->device, "invalid pmt_cmd_id %d "
> > -					"at stream level\n", pmt_cmd_id);
> > +				dev_err(fdtv->device,
> > +					"invalid pmt_cmd_id %d at stream level\n",
> > +					pmt_cmd_id);
> >  
> >  			if (es_info_length > sizeof(c->operand) - 4 -
> >  					     write_pos) {
> > diff --git a/drivers/media/firewire/firedtv-rc.c b/drivers/media/firewire/firedtv-rc.c
> > index f82d4a93feb3..babfb9cee20e 100644
> > --- a/drivers/media/firewire/firedtv-rc.c
> > +++ b/drivers/media/firewire/firedtv-rc.c
> > @@ -184,8 +184,9 @@ void fdtv_handle_rc(struct firedtv *fdtv, unsigned int code)
> >  	else if (code >= 0x4540 && code <= 0x4542)
> >  		code = oldtable[code - 0x4521];
> >  	else {
> > -		printk(KERN_DEBUG "firedtv: invalid key code 0x%04x "
> > -		       "from remote control\n", code);
> > +		printk(KERN_DEBUG
> > +		       "firedtv: invalid key code 0x%04x from remote control\n",
> > +		       code);
> >  		return;
> >  	}  
> 
> 
> Regards
> 
> Takashi Sakamoto
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Stefan Richter
-======----- =-=- -====
http://arcgraph.de/sr/
