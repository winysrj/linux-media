Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:43904 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbZFEIzb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2009 04:55:31 -0400
Date: Fri, 5 Jun 2009 10:55:25 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Jan Nikitenko <jan.nikitenko@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: AVerTV Volar Black HD: i2c oops in warm state on mips
In-Reply-To: <4A28CEAD.9000000@gmail.com>
Message-ID: <alpine.LRH.1.10.0906051053230.23189@pub2.ifh.de>
References: <4A28CEAD.9000000@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan,

On Fri, 5 Jun 2009, Jan Nikitenko wrote:
> The used dvb-t sources work ok on intel x86 platform (used kernel 2.6.24), 
> but
> on mips, there seems to be some problem with i2c after switch of the tuner 
> into
> the warm state via firmware load (tested with 2.6.25.17 and 2.6.29-rc7 mips
> kernels, with the same result) - it seems to me, that adap pointer (or the
> structure) is not valid (adap->algo is NULL):
>
> [..]
>
> Tried two mips32 little endian platforms: Broadcom BCM3302 /asus wl500gp 
> router/
> and alchemy au1550 with the same result.
>
> Any ideas why this happens?

At some point in time, someone said, that using stack-allocated buffers 
for USB transfers is not cross-platform-save. IIRC, it was on 
MIPS-platforms where this became obvious.

I haven't looked into the af-driver, but I guess that's the problem here.

regards,
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
