Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:34275 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750871AbdE2Ilz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 04:41:55 -0400
Received: by mail-lf0-f50.google.com with SMTP id 99so31054002lfu.1
        for <linux-media@vger.kernel.org>; Mon, 29 May 2017 01:41:54 -0700 (PDT)
Subject: Re: [PATCH 6/7] [media] soc_camera: rcar_vin: use proper name for the
 R-Car SoC
To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-renesas-soc@vger.kernel.org
References: <20170528093051.11816-1-wsa+renesas@sang-engineering.com>
 <20170528093051.11816-7-wsa+renesas@sang-engineering.com>
Cc: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <a133a7f7-e887-5043-83d3-cccbec581487@cogentembedded.com>
Date: Mon, 29 May 2017 11:41:53 +0300
MIME-Version: 1.0
In-Reply-To: <20170528093051.11816-7-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

    Why "soc_camera:" in the subject?
    The 'soc_camera" driver has been removed (replaced by a "normal" V4L2 driver).

MBR, Sergei
