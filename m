Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:36699 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755516AbcKBQnb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 12:43:31 -0400
Received: by mail-lf0-f47.google.com with SMTP id t196so17877282lff.3
        for <linux-media@vger.kernel.org>; Wed, 02 Nov 2016 09:43:30 -0700 (PDT)
Subject: Re: [PATCH 03/32] media: rcar-vin: reset bytesperline and sizeimage
 when resetting format
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
 <20161102132329.436-4-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <2f6c92a8-6d07-d355-41c9-ce7bc73093da@cogentembedded.com>
Date: Wed, 2 Nov 2016 19:43:27 +0300
MIME-Version: 1.0
In-Reply-To: <20161102132329.436-4-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 11/02/2016 04:23 PM, Niklas Söderlund wrote:

> These two fields where forgotten when refactoring the format reset code
> path. If they are not also reset at the same time as width and hight the
> format read using G_FMT will not match realty.

    Reality?

> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
[...]

MBR, Sergei

