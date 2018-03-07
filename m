Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754580AbeCGTCI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 14:02:08 -0500
Date: Wed, 7 Mar 2018 19:02:05 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: "French, Nicholas A." <naf@ou.edu>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, hans.verkuil@cisco.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: ivtv: use arch_phys_wc_add() and require PAT disabled
Message-ID: <20180307190205.GA14069@wotan.suse.de>
References: <DM5PR03MB3035EE1AFCEE298AFB15AC46D3C60@DM5PR03MB3035.namprd03.prod.outlook.com>
 <20180301171936.GU14069@wotan.suse.de>
 <DM5PR03MB303587F12D7E56B951730A76D3D90@DM5PR03MB3035.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR03MB303587F12D7E56B951730A76D3D90@DM5PR03MB3035.namprd03.prod.outlook.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 06, 2018 at 09:01:10PM +0000, French, Nicholas A. wrote:
> any reason why PAT can't be enabled for ivtvfb as simply as in the attached
> patch?

diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 621b2f613d81..69de110726e8 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -1117,7 +1117,7 @@ static int ivtvfb_init_io(struct ivtv *itv)
 	oi->video_buffer_size = 1704960;
 
 	oi->video_pbase = itv->base_addr + IVTV_DECODER_OFFSET + oi->video_rbase;
-	oi->video_vbase = itv->dec_mem + oi->video_rbase;
+	oi->video_vbase = ioremap_wc(oi->video_pbase, oi->video_buffer_size);

Note that this is the OSD buffer setup. The OSD buffer info is setup at the
start of the routine:

struct osd_info *oi = itv->osd_info;

And note that itv->osd_info is kzalloc()'d via ivtvfb_init_card() right before
ivtvfb_init_io(), which is the routine you are modifying.

Prior to your change the OSD buffer was obtained using the itv->dec_mem + oi->video_rbase
given itv->dec_mem was initialized via the ivtv driver module, one of which's C files
is:

drivers/media/pci/ivtv/ivtv-driver.c

and has:

   if (itv->has_cx23415) {
	...
	itv->dec_mem = ioremap_nocache(itv->base_addr + IVTV_DECODER_OFFSET - oi->video_buffer_size,
                                IVTV_DECODER_SIZE);
	...
   else {
	itv->dec_mem = itv->enc_mem;
   }


The way it used to work then it seems to be that we have a main ivtv driver which
does the ioremap off of the decoder and uses that as offset. If its not
the special cx23415 it still sets the decoder mapped offset to the encoder
offset.

So if you wanted to do what you mention in the above hunk I think you'd then
have to also proactively reduce the size of the ioremap_nocache()'d size on
the ivtv driver first. It would probably make your programming easier if
you know if the cx23415 had no frame buffer too, as then the ivtvfb driver
would not have to be concerned for variants, or the ivtv change would only
be relevant for cx23415 varaint users.

So what I'd do is change the ioremap_nocache()'d size by substracting
oi->video_buffer_size -- but then you have to ask yourself how you'd get
that size. If its something you can figure out then great.

The ivtv driver is a bit odd in that ivtvfb_init() will issue
ivtvfb_callback_init() on each registered device the ivtv driver registered, so
care must be taken with order as well on tear down.

Good luck!

  Luis

@@ -1157,6 +1157,8 @@ static void ivtvfb_release_buffers (struct ivtv *itv)
 	/* Release pseudo palette */
 	kfree(oi->ivtvfb_info.pseudo_palette);
 	arch_phys_wc_del(oi->wc_cookie);
+	if (oi->video_vbase)
+		iounmap(oi->video_vbase);
 	kfree(oi);
 	itv->osd_info = NULL;
 }
@@ -1167,13 +1169,6 @@ static int ivtvfb_init_card(struct ivtv *itv)
 {
 	int rc;
 
-#ifdef CONFIG_X86_64
-	if (pat_enabled()) {
-		pr_warn("ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
-		return -ENODEV;
-	}
-#endif
-
 	if (itv->osd_info) {
 		IVTVFB_ERR("Card %d already initialised\n", ivtvfb_card_id);
 		return -EBUSY;
