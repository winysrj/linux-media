Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37733 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752765AbdDLTXf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 15:23:35 -0400
Received: by mail-wm0-f44.google.com with SMTP id u2so31469782wmu.0
        for <linux-media@vger.kernel.org>; Wed, 12 Apr 2017 12:23:34 -0700 (PDT)
Date: Wed, 12 Apr 2017 21:23:27 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: Re: [PATCH v3 00/13] stv0367/ddbridge: support CTv6/FlexCT hardware
Message-ID: <20170412212327.5b75be19@macbox>
In-Reply-To: <20170329164313.14636-1-d.scheller.oss@gmail.com>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Wed, 29 Mar 2017 18:43:00 +0200
schrieb Daniel Scheller <d.scheller.oss@gmail.com>:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> Third iteration of the DD CineCTv6/FlexCT support patches with mostly
> all things cleaned up that popped up so far. Obsoletes V1 and V2
> series.
> 
> These patches enhance the functionality of dvb-frontends/stv0367 to
> work with Digital Devices hardware driven by the ST STV0367
> demodulator chip and adds probe & attach bits to ddbridge to make use
> of them, effectively enabling full support for CineCTv6 PCIe bridges
> and (older) DuoFlex CT addon modules.

Since V1 was sent over five weeks ago: Ping? Anyone? I'd really like to
get this upstreamed.

Regards,
Daniel
