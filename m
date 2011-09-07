Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49073 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab1IGSEn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 14:04:43 -0400
Received: by yxj19 with SMTP id 19so4134857yxj.19
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2011 11:04:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbzDNXw8j6seVuM1ZkYzV5WRV0nv6Np620hKq5sHe0Bk=g@mail.gmail.com>
References: <4E2E0788.3010507@iki.fi>
	<4E3061CF.2080009@redhat.com>
	<4E306BAE.1020302@iki.fi>
	<4E35F773.3060807@redhat.com>
	<4E35FFBF.9010408@iki.fi>
	<4E360E53.80107@redhat.com>
	<4E67A12B.8020908@iki.fi>
	<CAOcJUbz-hTf+xi=9JfJVGYsPSs7Cay6uwuwRdK7aiJeQrCtrGQ@mail.gmail.com>
	<CAOcJUbzDNXw8j6seVuM1ZkYzV5WRV0nv6Np620hKq5sHe0Bk=g@mail.gmail.com>
Date: Wed, 7 Sep 2011 14:04:42 -0400
Message-ID: <CAOcJUbwVgAo-OpruY44ZC0VP07-4Gmq=4s+zdSsH9biJgg-zRg@mail.gmail.com>
Subject: Re: [PATCH 2/3] dvb-usb: multi-frontend support (MFE)
From: Michael Krufky <mkrufky@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Jose Alberto Reguero <jareguero@telefonica.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> On Wed, Sep 7, 2011 at 12:51 PM, Antti Palosaari <crope@iki.fi> wrote:
>>> Also .num_frontends can be removed after that, since DVB USB will just loop
>>> through 0 to MAX FEs and register all FEs found (fe pointer !NULL).

We need to keep .num_frontends and .num_adapters both, because my next
change to dvb-usb is to convert the hard-sized array of struct
dvb_usb_adapter[MAX_NO_OF_ADAPTER_PER_DEVICE] and struct
dvb_usb_fe_adapter[MAX_NO_OF_FE_PER_ADAP] to a dynamic-allocated array
of pointers, to reduce the size of *all* dvb-usb drivers.

I didn't push all changes yet because I thought we should test each
change for a few days before merging too much all at once.  I wanted
to prevent the introduction of instability by making this a gradual
change so we can test things one by one.

Should I wait a bit before making the conversion of the hardcoded
sized-arrays to dynamic sized property pointers?

Regards,

Mike
