Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.netline.ch ([148.251.143.178]:46478 "EHLO
        netline-mail3.netline.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbeJWWJf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Oct 2018 18:09:35 -0400
Subject: Re: [PATCH 1/8] dma-buf: remove shared fence staging in reservation
 object
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Cc: amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
References: <20181004131250.2373-1-christian.koenig@amd.com>
 <30ba1fc8-58d5-1c75-406e-d10e68ec4b18@gmail.com>
 <42ee3d74-9dac-6573-448c-c70ea28cb9ff@gmail.com>
From: =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Message-ID: <d6cb3f2b-4b6b-933a-d0e5-2a6099659cce@daenzer.net>
Date: Tue, 23 Oct 2018 15:40:48 +0200
MIME-Version: 1.0
In-Reply-To: <42ee3d74-9dac-6573-448c-c70ea28cb9ff@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-10-23 2:20 p.m., Christian König wrote:
> Ping once more! Adding a few more AMD people.
> 
> Any comments on this?

Patches 1 & 3 are a bit over my head I'm afraid.


Patches 2, 4, 6-8 are

Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>


-- 
Earthling Michel Dänzer               |               http://www.amd.com
Libre software enthusiast             |             Mesa and X developer
