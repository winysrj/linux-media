Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46231 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab1A0JdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 04:33:11 -0500
MIME-Version: 1.0
In-Reply-To: <20110125150430.GF13051@sirena.org.uk>
References: <AANLkTinAYrGV1k357Bn8trtxafZDoYozG7LDcm3KNBSt@mail.gmail.com> <20110125150430.GF13051@sirena.org.uk>
From: halli manjunatha <manjunatha_halli@ti.com>
Date: Thu, 27 Jan 2011 15:02:43 +0530
Message-ID: <AANLkTi=J6mC7yWL9DF91Tp4+67QpAVK8vTMVVmsfJNyw@mail.gmail.com>
Subject: Re: [GIT PULL] TI WL 128x FM V4L2 driver
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mark,

This is completely independent of WL 127X driver, instead this driver
works on top of the shared transport line discipline driver (which is
at driver/misc/ti-st in mainline).


On Tue, Jan 25, 2011 at 8:34 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Jan 25, 2011 at 11:18:18AM +0530, halli manjunatha wrote:
>
>> This is TI WL128x FM V4L2 driver and it introduces ?wl128x? folder
>> under the ?drivers/media/radio?. This driver enables support for FM RX
>> and TX for Texas Instrument's WL128x (also compatible with WL127x)
>
> How does this all interact with the existing wl1273 driver that's now in
> mainline?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards
Manjunatha Halli
