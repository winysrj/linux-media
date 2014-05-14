Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50747 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaENMT2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 08:19:28 -0400
Message-ID: <53735F4D.6090008@iki.fi>
Date: Wed, 14 May 2014 15:19:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Vincent McIntyre <vincent.mcintyre@gmail.com>
Subject: Re: regression: firmware loading for dvico dual digital 4
References: <CAEsFdVN5MJQnb9+ZoagMOLpLYTJVYjjqQid9NrhU_Q8HfrtjAg@mail.gmail.com>
In-Reply-To: <CAEsFdVN5MJQnb9+ZoagMOLpLYTJVYjjqQid9NrhU_Q8HfrtjAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Bug is that:
kernel: [ 37.360226] cxusb: i2c wr: len=64 is too big!

I suspect that this is coming from your dynamic stack allocation patch 
set - as there has been very many similar looking bug reports earlier. 
Didn't analyzed it any deeply.

regards
Antti


On 05/14/2014 02:30 PM, Vincent McIntyre wrote:
> Hi,
>
> Antti asked me to report this.
>
> I built the latest media_build git on Ubuntu 12.04, with 3.8.0 kernel,
> using './build --main-git'.
> The attached tarball has the relvant info.
>
> Without the media_build modules, firmware loads fine (file dmesg.1)
> Once I build and install the media_build modules, the firmware no
> longer loads. (dmesg.2)
>
> The firmware loading issue appears to have been reported to ubuntu (a
> later kernel, 3.11)  with a possible fix proposed, see
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1291459
>
> I can post lspci etc details if people want.
>
> Kind regards
> VInce
>


-- 
http://palosaari.fi/
