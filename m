Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f174.google.com ([209.85.215.174]:46294 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732000AbeG0DUG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 23:20:06 -0400
Subject: Re: media: dvb-usb-v2/gl861: ensure USB message buffers DMA'able
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Colin Ian King <colin.king@canonical.com>,
        linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mika.batsman@gmail.com
References: <8308d9f0-2257-101c-69e3-8fe165de9348@canonical.com>
 <d2465376-4b3e-7d3d-86d2-0cd8d7543520@gmail.com>
 <20180725105701.4f3b429b@coco.lan>
From: Akihiro TSUKADA <tskd08@gmail.com>
Message-ID: <75be710b-3eda-e077-7c90-beec059d83b2@gmail.com>
Date: Fri, 27 Jul 2018 11:00:25 +0900
MIME-Version: 1.0
In-Reply-To: <20180725105701.4f3b429b@coco.lan>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 2018年07月25日 22:57, Mauro Carvalho Chehab wrote:
...
> There was another patch proposed to fix this issue with does the
> right thing when rlen == 0. I rebased it on the top of the current
> tree:
> 	https://git.linuxtv.org/media_tree.git/commit/?id=0b666e1c8120c0b17a8a68aaed58e22011f06ab3
> 
> That should cover both cases.

When wlen is checked to be <= 2 and
wbuf[0],wbuf[1] are already used in 'index','value',
why this patch copys wbuf and passes it again in usb_control_msg when wo==1 ?
(just to silence static analiyzers?)

Furthermore, 
I am afraid that a static analyzer might warn on a possible
buffer overrun in usb_control_msg in the case of rbuf == NULL && rlen > 2,
since buf's length is passed as rlen but is actually wlen.

regards,
Akihiro 
