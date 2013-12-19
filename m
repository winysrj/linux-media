Return-path: <linux-media-owner@vger.kernel.org>
Received: from microschulz.de ([79.140.41.212]:45333 "EHLO microschulz.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870Ab3LSVqu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 16:46:50 -0500
Date: Thu, 19 Dec 2013 22:25:45 +0100
From: Nikolaus Schulz <ns@htonl.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] libdvbv5: more fixes in the T2 delivery descriptor
 handler
Message-ID: <20131219212545.GA19472@zorro.zusammrottung.local>
References: <1386256203-3007-1-git-send-email-schulz@macnetix.de>
 <20131218104931.743fc6d3@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218104931.743fc6d3@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 18, 2013 at 10:49:31AM -0200, Mauro Carvalho Chehab wrote:
> > * Properly use lengths of centre_frequency loop and subcell_info loop
> >   (they count bytes, not entries)
> 
> I'm not sure about this one. On all other similar descriptors, we're storing
> the number of elements at the descriptor's structure, instead of its size,
> as that makes easier to handle them.

OK, I had been looking into other descriptor handlers and didn't spot
anything like that, but isdbt_desc_terrestrial_delivery_system.num_freqs
at least indeed does count array members.

> Also, having all delivery_system descriptors using the number of elements
> makes easier to avoid confusion when writing the handling code.

I agree, it also is way more natural.  Actually I felt that from the
start, but considering that the structs in the code very closely
correlate to the binary DVBSI format, I adopted the byte count
accordingly.

> Btw, I think that this change will likely break the code that handles this
> descriptor at dvb-scan.

Indeed, add_update_nit_dvbt2() would be affected.

> So, could you please redo your patch in order for it to keep storing the
> number of elements at the dvb_desc_t2_delivery::frequency_loop_length
> field? If you prefer, you can rename it to frequency_loop_nmemb (or a
> similar naming) to make it clearer.

I'll re-send it using frequency_loop_nmemb and subcel_info_loop_nmemb,
in order to avoid confusion with the {frequency,subcell_info}_loop_length
fields in the binary DVBSI format.

Thanks,
Nikolaus

> > Signed-off-by: Nikolaus Schulz <schulz@macnetix.de>
> > ---
> >  lib/libdvbv5/descriptors/desc_t2_delivery.c |   35 ++++++++++++++-------------
> >  1 files changed, 18 insertions(+), 17 deletions(-)
> > 
> > diff --git a/lib/libdvbv5/descriptors/desc_t2_delivery.c b/lib/libdvbv5/descriptors/desc_t2_delivery.c
> > index ab4361d..07a0956 100644
> > --- a/lib/libdvbv5/descriptors/desc_t2_delivery.c
> > +++ b/lib/libdvbv5/descriptors/desc_t2_delivery.c
> > @@ -32,6 +32,7 @@ void dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
> >  	struct dvb_desc_t2_delivery *d = desc;
> >  	unsigned char *p = (unsigned char *) buf;
> >  	size_t desc_len = ext->length - 1, len, len2;
> > +	uint8_t nmemb;
> >  	int i;
> >  
> >  	len = offsetof(struct dvb_desc_t2_delivery, bitfield);
> > @@ -42,7 +43,7 @@ void dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
> >  		return;
> >  	}
> >  	if (desc_len < len2) {
> > -		memcpy(p, buf, len);
> > +		memcpy(d, p, len);
> >  		bswap16(d->system_id);
> >  
> >  		if (desc_len != len)
> > @@ -50,44 +51,41 @@ void dvb_desc_t2_delivery_init(struct dvb_v5_fe_parms *parms,
> >  
> >  		return;
> >  	}
> > -	memcpy(p, buf, len2);
> > +	memcpy(d, p, len2);
> >  	p += len2;
> >  
> > -	len = desc_len - (p - buf);
> > -	memcpy(&d->centre_frequency, p, len);
> > -	p += len;
> > -
> >  	if (d->tfs_flag)
> > -		d->frequency_loop_length = 1;
> > +		d->frequency_loop_length = sizeof(*d->centre_frequency);
> >  	else {
> >  		d->frequency_loop_length = *p;
> >  		p++;
> >  	}
> > +	nmemb = d->frequency_loop_length / sizeof(*d->centre_frequency);
> >  
> > -	d->centre_frequency = calloc(d->frequency_loop_length,
> > -				     sizeof(*d->centre_frequency));
> > +	d->centre_frequency = calloc(nmemb, sizeof(*d->centre_frequency));
> >  	if (!d->centre_frequency) {
> >  		dvb_perror("Out of memory");
> >  		return;
> >  	}
> >  
> > -	memcpy(d->centre_frequency, p, sizeof(*d->centre_frequency) * d->frequency_loop_length);
> > -	p += sizeof(*d->centre_frequency) * d->frequency_loop_length;
> > +	memcpy(d->centre_frequency, p, d->frequency_loop_length);
> > +	p += d->frequency_loop_length;
> >  
> > -	for (i = 0; i < d->frequency_loop_length; i++)
> > +	for (i = 0; i < nmemb; i++)
> >  		bswap32(d->centre_frequency[i]);
> >  
> >  	d->subcel_info_loop_length = *p;
> >  	p++;
> > +	nmemb = d->subcel_info_loop_length / sizeof(*d->subcell);
> >  
> > -	d->subcell = calloc(d->subcel_info_loop_length, sizeof(*d->subcell));
> > +	d->subcell = calloc(nmemb, sizeof(*d->subcell));
> >  	if (!d->subcell) {
> >  		dvb_perror("Out of memory");
> >  		return;
> >  	}
> > -	memcpy(d->subcell, p, sizeof(*d->subcell) * d->subcel_info_loop_length);
> > +	memcpy(d->subcell, p, d->subcel_info_loop_length);
> >  
> > -	for (i = 0; i < d->subcel_info_loop_length; i++)
> > +	for (i = 0; i < nmemb; i++)
> >  		bswap16(d->subcell[i].transposer_frequency);
> >  }
> >  
> > @@ -97,6 +95,7 @@ void dvb_desc_t2_delivery_print(struct dvb_v5_fe_parms *parms,
> >  {
> >  	const struct dvb_desc_t2_delivery *d = desc;
> >  	int i;
> > +	uint8_t nmemb;
> >  
> >  	dvb_log("|       DVB-T2 delivery");
> >  	dvb_log("|           plp_id                    %d", d->plp_id);
> > @@ -113,10 +112,12 @@ void dvb_desc_t2_delivery_print(struct dvb_v5_fe_parms *parms,
> >  	dvb_log("|           bandwidth                 %d", d->bandwidth);
> >  	dvb_log("|           SISO MISO                 %d", d->SISO_MISO);
> >  
> > -	for (i = 0; i < d->frequency_loop_length; i++)
> > +	nmemb = d->frequency_loop_length / sizeof(*d->centre_frequency);
> > +	for (i = 0; i < nmemb; i++)
> >  		dvb_log("|           centre frequency[%d]   %d", i, d->centre_frequency[i]);
> >  
> > -	for (i = 0; i < d->subcel_info_loop_length; i++) {
> > +	nmemb = d->subcel_info_loop_length / sizeof(*d->subcell);
> > +	for (i = 0; i < nmemb; i++) {
> >  		dvb_log("|           cell_id_extension[%d]  %d", i, d->subcell[i].cell_id_extension);
> >  		dvb_log("|           transposer frequency   %d", d->subcell[i].transposer_frequency);
> >  	}
