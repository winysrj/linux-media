Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:42073 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759699AbeD1JgL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 05:36:11 -0400
Received: by mail-lf0-f50.google.com with SMTP id u21-v6so5996458lfu.9
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2018 02:36:11 -0700 (PDT)
Subject: Re: [PATCH] v4l: vsp1: Fix vsp1_regs.h license header
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
References: <20180427214647.892-1-laurent.pinchart+renesas@ideasonboard.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <5a84b774-581c-77fe-085b-7e4d841daa97@cogentembedded.com>
Date: Sat, 28 Apr 2018 12:36:09 +0300
MIME-Version: 1.0
In-Reply-To: <20180427214647.892-1-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 4/28/2018 12:46 AM, Laurent Pinchart wrote:

> All source files of the vsp1 driver are licensed under the GPLv2+ except
> for vsp1_regs.h which is licensed under GPLv2. This is caused by a bad
> copy&paste that dates back from the initial version of the driver. Fix
> it.
> 
> Cc: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
> Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
[...]

Acked-by: Sergei Shtylyov<sergei.shtylyov@cogentembedded.com>

MBR, Sergei
