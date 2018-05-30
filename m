Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:44056 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750821AbeE3LIc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 07:08:32 -0400
Received: by mail-lf0-f68.google.com with SMTP id 36-v6so1695604lfr.11
        for <linux-media@vger.kernel.org>; Wed, 30 May 2018 04:08:31 -0700 (PDT)
Subject: Re: [PATCH] media: arch: sh: migor: Fix TW9910 PDN gpio
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        ysato@users.sourceforge.jp, dalias@libc.org,
        laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com
Cc: linux-sh@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <1527671604-18768-1-git-send-email-jacopo+renesas@jmondi.org>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <4e636f8b-ba38-754a-4763-022eab578934@cogentembedded.com>
Date: Wed, 30 May 2018 14:08:28 +0300
MIME-Version: 1.0
In-Reply-To: <1527671604-18768-1-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 05/30/2018 12:13 PM, Jacopo Mondi wrote:

> The TW9910 PDN gpio (power down) is listed as active high in the chip

   GPIO.

> manual. It turns out it is actually active low as when set to physical
> level 0 it actually turns the video decoder power off.
> 
> Without this patch applied:
> tw9910 0-0045: Product ID error 1f:2
> 
> With this patch applied:
> tw9910 0-0045: tw9910 Product ID b:0
> 
> Fixes: commit "186c446f4b840bd77b79d3dc951ca436cb8abe79"

   That's not how you specify the "Fixes:" tag, please see
Documentation/process/submitting-patches.rst.

> 

   There shouldn't be an emoty line here.

> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
[...]

MBR, Sergei
