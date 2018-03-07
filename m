Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:46841 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbeCGJrP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 04:47:15 -0500
Received: by mail-qk0-f169.google.com with SMTP id 130so1842127qkd.13
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2018 01:47:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1980bfa67f19d628df30b9b5b76bca37c2a76dde.1520414065.git.mchehab@s-opensource.com>
References: <1980bfa67f19d628df30b9b5b76bca37c2a76dde.1520414065.git.mchehab@s-opensource.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 7 Mar 2018 06:47:14 -0300
Message-ID: <CAOMZO5C5jSxwKMV0hZpA1emFW9ha8GN4XsTsdTfgPU4eJ44Ctw@mail.gmail.com>
Subject: Re: [PATCH] media: dvbdev: fix building on ia64
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Mar 7, 2018 at 6:14 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Not sure why, but, on ia64, with Linaro's gcc 7.3 compiler,
> using #ifdef (CONFIG_I2C) is not OK.

Looking at the kbuild report the failure happens when CONFIG_I2C=m.

IS_ENABLED() macro takes care of both built-in and module as it will expand to:

#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)

and that's the reason why IS_ENABLE() fixes the build problem.

Regards,

Fabio Estevam
