Return-path: <linux-media-owner@vger.kernel.org>
Received: from ks358065.kimsufi.com ([91.121.151.38]:40021 "EHLO
	ks358065.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782Ab2KNJgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 04:36:14 -0500
From: =?iso-8859-15?q?Fr=E9d=E9ric?= <fma@gbiloba.org>
To: Patrice Chotard <patrice.chotard@sfr.fr>
Subject: Re: Support for Terratec Cinergy 2400i DT in kernel 3.x
Date: Wed, 14 Nov 2012 10:36:06 +0100
References: <201211131040.22114.fma@gbiloba.org> <50A2C0C4.9040607@sfr.fr> <201211140948.00913.fma@gbiloba.org>
In-Reply-To: <201211140948.00913.fma@gbiloba.org>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201211141036.06971.fma@gbiloba.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mercredi 14 novembre 2012, Frédéric a écrit :

> I had a look at your patches. I don't see the '.fw_version' param anymore
> in the 'ngene_info' structure... Is it normal?

I also noticed some differences in the PLL presets:

In your patch:

    .entries = {
            {  305000000, 166667, 0xb4, 0x12 },
            {  405000000, 166667, 0xbc, 0x12 },
            {  445000000, 166667, 0xbc, 0x12 },
            {  465000000, 166667, 0xf4, 0x18 },
            {  735000000, 166667, 0xfc, 0x18 },
            {  835000000, 166667, 0xbc, 0x18 },
            {  999999999, 166667, 0xfc, 0x18 },
    },

In original patch:

    if (freq<177000000 || freq>858000000)
        return -EINVAL;
    else if (freq<305000000) { c1=0xb4; c2=0x12; }
    else if (freq<405000000) { c1=0xbc; c2=0x12; }
    else if (freq<445000000) { c1=0xf4; c2=0x12; }
    else if (freq<465000000) { c1=0xfc; c2=0x12; }
    else if (freq<735000000) { c1=0xbc; c2=0x18; }
    else if (freq<835000000) { c1=0xf4; c2=0x18; }
    else { c1=0xfc; c2=0x18; }

-- 
   Frédéric
