Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:34323 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3CRUFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 16:05:13 -0400
Received: by mail-vb0-f50.google.com with SMTP id ft2so3691540vbb.9
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2013 13:05:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363634737-22550-2-git-send-email-mchehab@redhat.com>
References: <1363634737-22550-1-git-send-email-mchehab@redhat.com>
	<1363634737-22550-2-git-send-email-mchehab@redhat.com>
Date: Mon, 18 Mar 2013 17:05:12 -0300
Message-ID: <CAOMZO5DD-J3Uf9mSxvyLNz2X5-G3nkamfZ6+Zo0uYqgineHfEg@mail.gmail.com>
Subject: Re: [PATCH 2/2] dvb_frontend: Simplify the emulation logic
From: Fabio Estevam <festevam@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Mar 18, 2013 at 4:25 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:

> -static int emulate_delivery_system(struct dvb_frontend *fe,
> -                                  enum dvbv3_emulation_type type,
> -                                  u32 delsys, u32 desired_system)
> +/**
> + * emulate_delivery_system - emulate a DVBv5 delivery system with a DVBv3 type
> + * @fe:                        struct frontend;
> + * @desired_system:    DVBv5 type that will be used for emulation

'desired_system' parameter has been removed in this patch. 'delsys'
should be put in the description instead.

> + * Provides emulation for delivery systems that are compatible with the old
> + * DVBv3 call. Among its usages, it provices support for ISDB-T, and allows
> + * using a DVB-S2 only frontend just like it were a DVB-S, if the frontent
> + * parameters are compatible with DVB-S spec.
> + */
> +static int emulate_delivery_system(struct dvb_frontend *fe, u32 delsys)

Regards,

Fabio Estevam
