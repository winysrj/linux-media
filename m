Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:37409 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbaAHLJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 06:09:11 -0500
Received: by mail-ea0-f173.google.com with SMTP id o10so740678eaj.4
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 03:09:10 -0800 (PST)
Date: Wed, 8 Jan 2014 12:09:05 +0100
From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 09/18] libdvbv5: implement ATSC EIT
Message-ID: <20140108120905.2a0cf9ca@neutrino.exnihilo>
In-Reply-To: <20140107151259.5da71381@samsung.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
	<1388407731-24369-9-git-send-email-neolynx@gmail.com>
	<20140107151259.5da71381@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> > +void atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
> > +{
> > +	const uint8_t *p = buf;
> > +	struct atsc_table_eit *eit = (struct atsc_table_eit *) table;
> > +	struct atsc_table_eit_event **head;
> > +
> > +	if (*table_length > 0) {
> > +		memcpy(eit, p, sizeof(struct atsc_table_eit) - sizeof(eit->event));
> 
> Hmm... on some patches, when the table already exists, nothing is copied.
> 
> Just the pointer 'p' is incremented.
> 
> We should standardize this. Not sure what's the better.

agree. the first implementations were ok not copying already existing
table bodies. but tables like the EIT need info from the table body in
every section, so we need to parse that...

I will fix this for all tables in a later patch.

Regards,
 andré
