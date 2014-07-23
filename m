Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64193 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693AbaGWTYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 15:24:39 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so2738269wib.14
        for <linux-media@vger.kernel.org>; Wed, 23 Jul 2014 12:24:36 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 23 Jul 2014 22:24:36 +0300
Message-ID: <CAAZRmGw8W2sLTqQ7cgpB-1Y+DrkHy9d83VrJ_ciQEY5K3H-EFw@mail.gmail.com>
Subject: cxusb: How to add CI support?
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

I'm in need of advice when it comes to the implementation of the
drivers. I recently added support for TechnoTrend CT2-4400 DVB-T2
tuner into the dvb-usb-cxusb module. Now I have gotten another
TechnoTrend device CT2-4650 and it seems this is more or less the same
device as CT2-4400 but with an added CI slot. The CI is realized using
a CIMaX SP2HF chip.

There seems to be support already for the said CIMaX chip, but only in
combination with cx23885 (drivers/media/pci/cx23885/
cimax2.c). This cannot be reused directly in my case. When I look at
the other dvb-usb devices that have CI slot the support for CI has
been implemented directly in the code of the USB device (for example,
pctv452e or az6027).

Of course, an easy way to do it is to reuse a lot of code from the
existing cimax2 and add it in the cxusb. However, I'm not sure if
that's an ok approach. As I'm relatively new to linux kernel coding,
I'd like to ask your recommendation for implementing the CI support
here before the endeavour. Thanks!

Cheers,
-olli
