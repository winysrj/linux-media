Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:35809 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3GWQDI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 12:03:08 -0400
Received: by mail-oa0-f43.google.com with SMTP id i7so11555427oag.2
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 09:03:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA7C2qi1ZMGwB7C6bacU6W-jHRO_taKtng1ugb9DLzvTT3zHrQ@mail.gmail.com>
References: <1374594649-6061-1-git-send-email-updatelee@gmail.com>
	<CAA7C2qi1ZMGwB7C6bacU6W-jHRO_taKtng1ugb9DLzvTT3zHrQ@mail.gmail.com>
Date: Tue, 23 Jul 2013 10:03:07 -0600
Message-ID: <CAA9z4LZ0jAWFfi=OpqD0iNGOFC-N_vBr6U4e_-85Yv4EK60arg@mail.gmail.com>
Subject: Re: [PATCH] gp8psk: add systems supported by genpix devices to .delsys
From: Chris Lee <updatelee@gmail.com>
To: VDR User <user.vdr@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct, but many older userland applications used SYS_DVBS2 to tune
before SYS_TURBO was added. I have no problem removing it but others
might.

from gp8psk-fe.c

switch (c->delivery_system) {
case SYS_DVBS:
if (c->modulation != QPSK) {
deb_fe("%s: unsupported modulation selected (%d)\n",
__func__, c->modulation);
return -EOPNOTSUPP;
}
c->fec_inner = FEC_AUTO;
break;
case SYS_DVBS2: /* kept for backwards compatibility */
deb_fe("%s: DVB-S2 delivery system selected\n", __func__);
break;
case SYS_TURBO:
deb_fe("%s: Turbo-FEC delivery system selected\n", __func__);
break;

Chris

On Tue, Jul 23, 2013 at 9:53 AM, VDR User <user.vdr@gmail.com> wrote:
> Genpix Skywalker and 8psk-to-usb devices do not support dvb-s2.
