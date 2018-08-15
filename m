Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:51324 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729128AbeHOQ04 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 12:26:56 -0400
Received: by mail-wm0-f53.google.com with SMTP id y2-v6so1418563wma.1
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2018 06:34:44 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] media: soc_camera: ov9640: move ov9640 out of
 soc_camera
To: jacopo@jmondi.org, marek.vasut@gmail.com
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, robert.jarzmik@free.fr,
        slapin@ossfans.org, philipp.zabel@gmail.com
References: <cover.1534339750.git.petrcvekcz@gmail.com>
 <dc99bd37408f42a342b1b878d01c16f8c25b758b.1534339750.git.petrcvekcz@gmail.com>
From: Petr Cvek <petrcvekcz@gmail.com>
Message-ID: <de297d12-e5eb-9e68-978c-3417cdfc0c05@gmail.com>
Date: Wed, 15 Aug 2018 15:35:39 +0200
MIME-Version: 1.0
In-Reply-To: <dc99bd37408f42a342b1b878d01c16f8c25b758b.1534339750.git.petrcvekcz@gmail.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

BTW from the v1 discussion:

Dne 10.8.2018 v 09:32 jacopo mondi napsal(a):
> When I've been recently doing the same for ov772x and other sensor
> driver I've been suggested to first copy the driver into
> drivers/media/i2c/ and leave the original soc_camera one there, so
> they can be bulk removed or moved to staging. I'll let Hans confirm
> this, as he's about to take care of this process.

I would rather used git mv for preserve the git history, but if a simple
copy is fine then I'm fine too ;-).

Petr
