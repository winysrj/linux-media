Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:59702 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3LRKJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 05:09:13 -0500
Received: by mail-oa0-f43.google.com with SMTP id i7so7990305oag.16
        for <linux-media@vger.kernel.org>; Wed, 18 Dec 2013 02:09:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52B04D70.8060201@epfl.ch>
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>
	<52A1A76A.6070301@epfl.ch>
	<CA+2YH7vDjCuTPwO9hDv-sM6ALAS_q-ZW2V=uq4MKG=75KD3xKg@mail.gmail.com>
	<52B04D70.8060201@epfl.ch>
Date: Wed, 18 Dec 2013 11:09:12 +0100
Message-ID: <CA+2YH7srzQcabeQyPd5TCuKcYaSmPd3THGh3uJE9eLjqKSJHKw@mail.gmail.com>
Subject: Re: omap3isp device tree support
From: Enrico <ebutera@users.berlios.de>
To: florian.vaussard@epfl.ch
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 17, 2013 at 2:11 PM, Florian Vaussard
<florian.vaussard@epfl.ch> wrote:
> So I converted the iommu to DT (patches just sent), used pdata quirks
> for the isp / mtv9032 data, added a few patches from other people
> (mainly clk to fix a crash when deferring the omap3isp probe), and a few
> small hacks. I get a 3.13-rc3 (+ board-removal part from Tony Lindgren)
> to boot on DT with a working MT9V032 camera. The missing part is the DT
> binding for the omap3isp, but I guess that we will have to wait a bit
> more for this.
>
> If you want to test, I have a development tree here [1]. Any feedback is
> welcome.
>
> Cheers,
>
> Florian
>
> [1] https://github.com/vaussard/linux/commits/overo-for-3.14/iommu/dt

Thanks Florian,

i will report what i get with my setup.

Enrico
