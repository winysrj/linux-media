Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:32852 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdCOJHZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 05:07:25 -0400
Received: by mail-lf0-f53.google.com with SMTP id a6so4122575lfa.0
        for <linux-media@vger.kernel.org>; Wed, 15 Mar 2017 02:07:24 -0700 (PDT)
Subject: Re: [PATCH 01/16] rcar-vin: reset bytesperline and sizeimage when
 resetting format
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
 <20170314185957.25253-2-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <7c9b1762-91af-93f0-862d-148ec3a7cd56@cogentembedded.com>
Date: Wed, 15 Mar 2017 12:07:20 +0300
MIME-Version: 1.0
In-Reply-To: <20170314185957.25253-2-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 3/14/2017 9:59 PM, Niklas Söderlund wrote:

> These two where forgotten when refactoring the format reset code. If

    s/where/were/?

> they are not also reset at the same time as width and height the format
> returned from G_FMT will not match reality.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
[...]

MBR, Sergei
