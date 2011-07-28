Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f52.google.com ([209.85.212.52]:62757 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1G1LT5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 07:19:57 -0400
Received: by vws16 with SMTP id 16so2805624vws.11
        for <linux-media@vger.kernel.org>; Thu, 28 Jul 2011 04:19:56 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 28 Jul 2011 13:19:56 +0200
Message-ID: <CAAQuRetFnK-5Nb2cZApbpBjb5sJTcYWgxHwGdqWmomAOzX6K9w@mail.gmail.com>
Subject: AVerMedia a867r bkl removal
From: Romain Aviolat <r.aviolat@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I bought an AVerMedia a867r two weeks ago (<- my uninteresting life).
It's a DVB-T HD usb tuner, with infra-red built-in and a remote
control.
Avermedia provides Linux drivers for this products, that's why I've
chosen it first but...

The driver seems to use some depreciated code (lock_kernel();,
unlock_kernel();) and doesn't compile under >=2.6.38 kernels.

I made a patch that removes the use of BLK, please be indulgent I'm
not a C developer...

http://www.aviolat-chauffage.ch/~xens/files/a867_drv_v1.0.28_BKL_removal.patch

Works under: 2.6.35 / 2.6.38 / 3.0 kernels

I made a how-to:
http://www.aviolat-chauffage.ch/~xens/wordpress/?p=229 (in French
sorry)

now my questions, what should I do next ?

- I mailed the constructor, I don't know if they are interested in
supporting newer kernels...
- Their code is released under GPLv2, could it be merged to the V4L project ?
- Should I create an entry for this product in the V4L-DVB wiki ?

I'm new here, be patient...

Thanks

Romain
