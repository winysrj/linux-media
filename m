Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:34778 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753535AbcICSDo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Sep 2016 14:03:44 -0400
Received: by mail-lf0-f46.google.com with SMTP id p41so84765951lfi.1
        for <linux-media@vger.kernel.org>; Sat, 03 Sep 2016 11:02:20 -0700 (PDT)
Subject: Re: [PATCHv3 04/10] [media] rcar-vin: rename entity to digital
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
        hverkuil@xs4all.nl
References: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
 <20160815150635.22637-5-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <dbce9ab7-fc11-1a66-cb68-63196562f1d1@cogentembedded.com>
Date: Sat, 3 Sep 2016 21:02:16 +0300
MIME-Version: 1.0
In-Reply-To: <20160815150635.22637-5-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 08/15/2016 06:06 PM, Niklas Söderlund wrote:

> When Gen3 support is added to the driver more then one possible video

    s/then/than/.

> source entity will be possible. Knowing that the name entity is a bad
> one, rename it to digital since it will deal with the digital input
> source.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
[...]

    Other than that, the patch looked OK to me.

MBR, Sergei

