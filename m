Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:59400 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754996AbdEKICr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 04:02:47 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: "zhaoxuegang" <zhaoxuegang@suntec.net>
Cc: "Ezequiel Garcia" <ezequiel@vanguardiasur.com.ar>,
        "linux-media" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] TW686x: Fix OOPS on buffer alloc failure
References: <590ADAB1.1040501@suntec.net> <m3h90thwjt.fsf@t19.piap.pl>
        <m3d1bhhwf3.fsf_-_@t19.piap.pl>
        <CAAEAJfBVOKBcZBg91EKHBXKMOkM6eRafe8=XnW8E=6vtn2dBmQ@mail.gmail.com>
        <5913C1BB.8000103@suntec.net>
Date: Thu, 11 May 2017 10:02:45 +0200
In-Reply-To: <5913C1BB.8000103@suntec.net> (zhaoxuegang@suntec.net's message
        of "Thu, 11 May 2017 09:43:26 +0800")
Message-ID: <m34lwrizx6.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"zhaoxuegang" <zhaoxuegang@suntec.net> writes:

> In my opinion, the oops occur to tw686x_free_dma(struct tw686x_video_channel *vc, unsigned int pb).
> In function tw686x_video_init, if coherent-DMA is not enough, tw686x_alloc_dma will failed.
> Then tw686x_video_free will be called. but some channel's dev is null（in other words, vc->dev is null）

Exactly.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
