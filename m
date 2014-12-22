Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:60300 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754135AbaLVNMb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 08:12:31 -0500
Date: Mon, 22 Dec 2014 14:12:28 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: nicolas.ferre@atmel.com, voice.shen@atmel.com,
	plagnioj@jcrosoft.com, boris.brezillon@free-electrons.com,
	devicetree@vger.kernel.org, robh+dt@kernel.org,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 6/7] ARM: at91: dts: sama5d3: add ov2640 camera sensor
 support
Message-ID: <20141222131228.GB4194@piout.net>
References: <1418892667-27428-1-git-send-email-josh.wu@atmel.com>
 <1418892667-27428-7-git-send-email-josh.wu@atmel.com>
 <20141219210509.GC4885@piout.net>
 <5497C2DF.2040202@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5497C2DF.2040202@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On 22/12/2014 at 15:06:07 +0800, Josh Wu wrote :
> >I've acked your previous patch but maybe it should be named
> >pinctrl_isi_pck1_as_mck to be clearer (you used the handle to pck1
> >below).
> It's a good idea. Maybe I prefer to use the name: pinctrl_pck1_as_isi_mck ?
> If you are ok with this name, in next version, I will add one more patch in
> the series to do this.
> And I will keep your acked-by in my previous patch.
> 

Sounds good to me!

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
