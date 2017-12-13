Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33242 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753345AbdLMTgn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 14:36:43 -0500
Date: Wed, 13 Dec 2017 17:36:33 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: <Yasunari.Takiguchi@sony.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        <Masayuki.Yamamoto@sony.com>, <Hideki.Nozawa@sony.com>,
        <Kota.Yonezawa@sony.com>, <Toshihiko.Matsumoto@sony.com>,
        <Satoshi.C.Watanabe@sony.com>, "Bird, Timothy" <Tim.Bird@sony.com>
Subject: Re: [PATCH v4 00/12] [dt-bindings] [media] Add document file and
 driver for Sony CXD2880 DVB-T2/T tuner + demodulator
Message-ID: <20171213173633.57edca85@vento.lan>
In-Reply-To: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
References: <20171013054635.20946-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Oct 2017 14:46:35 +0900
<Yasunari.Takiguchi@sony.com> escreveu:

> From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
> 
> Hi,
> 
> This is the patch series (version 4) of Sony CXD2880 DVB-T2/T tuner + 
> demodulator driver.The driver supports DVB-API and interfaces through 
> SPI.
> 
> We have tested the driver on Raspberry Pi 3 and got picture and sound 
> from a media player.
> 
> The change history of this patch series is as below.

Finally had time to review this patch series. Sorry for taking so long.
4Q is usually very busy.

I answered each patch with comments. There ones I didn't comment
(patches 1, 4 and 8-12) is because I didn't see anything wrong,
except for the notes I did on other patches, mainly:
	- they lack SPDX license text;
	- the error codes need to review.

Additionally, on patches 8-11, I found weird to not found any
64 bits division, but I noticed some code there that it seemed
to actually be doing such division using some algorithm to make
them work on 32 bits machine. If so, please replace them by
do_div64(), as it makes clearer about what's been doing, and it
provides better performance when compiled on 64 bit Kernels (as
they become just a DIV asm operation).

Regards,
Mauro

Thanks,
Mauro
