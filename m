Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:35991 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab0BCQQL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 11:16:11 -0500
From: Oliver Neukum <oliver@neukum.org>
To: roel kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] dvb: return -ENOMEM if kzalloc failed in dvb_usb_device_init()
Date: Wed, 3 Feb 2010 17:16:03 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <4B6836DA.8030907@gmail.com> <201002021529.36727.oliver@neukum.org> <25e057c01002030802x5ae68ed9od9004565731ebd6f@mail.gmail.com>
In-Reply-To: <25e057c01002030802x5ae68ed9od9004565731ebd6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002031716.03782.oliver@neukum.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, 3. Februar 2010 17:02:49 schrieb roel kluin:
> > The bug is caused by this:
> >
> >        if (cold) {
> >                info("found a '%s' in cold state, will try to load a firmware",desc->name);
> >                ret = dvb_usb_download_firmware(udev,props);
> >                if (!props->no_reconnect || ret != 0)
> >                        return ret;
> >        }
> >
> > which overwrites ret
> 
> Is that an ack or do you want me to add an int (e.g. rc) that
> handles the dvb_usb_download_firmware() return value?

This is an ack with an additional comment that this function is in need of
a cleanup due to unnecessary subtlety.

	Regards
		Oliver
