Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:52710 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934564AbZHEOxs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Aug 2009 10:53:48 -0400
Date: Wed, 5 Aug 2009 16:53:42 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Pete Hildebrandt <send2ph@googlemail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [patch] Added Support for STK7700D (DVB)
In-Reply-To: <200908042138.11938.send2ph@googlemail.com>
Message-ID: <alpine.LRH.1.10.0908051650360.6890@pub1.ifh.de>
References: <200908042138.11938.send2ph@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pete,

On Tue, 4 Aug 2009, Pete Hildebrandt wrote:

> Hello,
>
> To this mail I attached two patch-files to add support for the STK7700D
> USB-DVB-Device.
>
> lsusb identifies it as:
> idVendor           0x1164 YUAN High-Tech Development Co., Ltd
> idProduct          0x1efc
> iProduct                2 STK7700D
>
> My two patches mainly just add the new product-ID.
>
> I have tested the modification with the 2.6.28 and the 2.6.30 kernel. The
> patches are for the 2.6.30 kernel.
>
> The device is build into my laptop (Samsung R55-T5500) and works great after
> applying the patches.

OK, I applied the patch and send the pull request to Mauro.

Can you please check whether everything went well (I needed to merge 
manually)?

In the future please use the v4l-dvb repository to apply your changes. 
This has several advantages: e.g. it is much easier to merge the patches 
for me, and it is simpler for you to try things as you don't need to use 
the kernel-build-environment to test the stuff etc.

thanks,
--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
