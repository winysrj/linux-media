Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:33294 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbaKTT5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 14:57:06 -0500
Received: by mail-la0-f41.google.com with SMTP id gf13so3054300lab.14
        for <linux-media@vger.kernel.org>; Thu, 20 Nov 2014 11:57:04 -0800 (PST)
Date: Thu, 20 Nov 2014 21:57:02 +0200 (EET)
From: Olli Salonen <olli.salonen@iki.fi>
To: Nibble Max <nibble.max@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1] dvb-usb-dvbsky: add T680CI dvb-t2/t/c usb ci box
 support
In-Reply-To: <201411131610389068314@gmail.com>
Message-ID: <alpine.DEB.2.10.1411202154000.1388@dl160.lan>
References: <201411131610389068314@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Max,

I think this is ok. In the nearby future, would be good to move TT 
CT2-4650 CI support to the dvbsky driver as that one is a rebadged T680CI 
anyway. If you will add T330 support as well, we could move CT2-4400 too..

Reviewed-by: Olli Salonen <olli.salonen@iki.fi>

Cheers,
-olli

On Thu, 13 Nov 2014, Nibble Max wrote:

> DVBSky T680CI dvb-t2/t/c usb ci box:
> 1>dvb frontend: SI2158A20(tuner), SI2168A30(demod)
> 2>usb controller: CY7C86013A
> 3>ci controller: CIMAX SP2 or its clone.
>
> Signed-off-by: Nibble Max <nibble.max@gmail.com>
