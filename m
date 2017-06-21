Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35974 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdFUTyH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 15:54:07 -0400
Received: by mail-wr0-f196.google.com with SMTP id 77so29347723wrb.3
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 12:54:06 -0700 (PDT)
Date: Wed, 21 Jun 2017 21:54:03 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, rjkm@metzlerbros.de
Subject: Re: [PATCH] [media] ddbridge: use dev_* macros in favor of printk
Message-ID: <20170621215403.5035db43@audiostation.wuest.de>
In-Reply-To: <740f66fc-d256-489d-82e5-d8602dfaeaa2@iki.fi>
References: <20170621165347.19409-1-d.scheller.oss@gmail.com>
        <20170621140808.7d5ad295@vento.lan>
        <20170621191440.2f38616a@audiostation.wuest.de>
        <20170621142031.641cfd29@vento.lan>
        <740f66fc-d256-489d-82e5-d8602dfaeaa2@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Wed, 21 Jun 2017 22:20:35 +0300
schrieb Antti Palosaari <crope@iki.fi>:

> On 06/21/2017 08:20 PM, Mauro Carvalho Chehab wrote:
> > Em Wed, 21 Jun 2017 19:14:40 +0200
> > Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> >   
> >> I intentionally left this in for the pr_info used in module_init_ddbridge(). If you prefer, we can ofc probably also leave this as printk like
> >>
> >> printk(KERN_INFO KBUILD_MODNAME ": Digital...");  
> > 
> > Ah, OK!  
> 
> But why you even need it? Probe should be first place you need to print 
> something and there is always proper device pointer.

This will be printed whenever the module is loaded. When in ddb_probe, you won't notice ever if the module is loaded for whatever reason if no DD card is there, or a card is present which isn't supported, and printed multiple times if you have more than one supported card (imagine a CTv6 plus module, and a CI Bridge, which gets common these days).

Let's keep it as it is, please.

Regards,
Daniel Scheller
-- 
https://github.com/herrnst
