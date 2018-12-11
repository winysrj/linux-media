Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EAAC6783B
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 22:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC4BF20851
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 22:15:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mihBuv1z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC4BF20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbeLKWPq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 17:15:46 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52781 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbeLKWPk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 17:15:40 -0500
Received: by mail-wm1-f68.google.com with SMTP id m1so3204221wml.2;
        Tue, 11 Dec 2018 14:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D6xoD625oZNi4kT/b12vQt1b3p5+/KEL218mj96sS9w=;
        b=mihBuv1zNj9n9r+fyXxH/1F8DQq+Ejmk8vh++xY+HOGJ3Q3sqEelfN5bFooyTJVcCu
         QY7JGQgZP7ZE0WetWjD/GSFyYVJ/UCQ/w0lzirh0r/JTkGJ2aDZBQTXqnKjbJWtyoFMv
         7Bq8XH+rNQEvix5DC5+Nojgu02rIkj+RMCSA5FsAN3cAEx+IwNGsraXlWGApMSBpyul1
         ljdB4O/juIH/hCLRdez5gq3Wffp9GMN27z55ZN7qY6Yw5DrOJm9RTZJC+aUw9rO4/5tX
         hydSfXSyBPaUBhUubjCxr+Y2PemlsvAdKRfN2ncD2pWKYXn8vOxOanTIB3ExiICdPWD2
         DSjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D6xoD625oZNi4kT/b12vQt1b3p5+/KEL218mj96sS9w=;
        b=ugbk/Eu24v+VxDVOpWwliLZ3AhSlD2huZ8B0fZDkxSDmdZYtr9+eN93FJSSFQnzECn
         3l9CaluyIqbA3csYFavVK1lJ7w4TbrgJcgUs9IkyGGgj4t9oJNzM3qbj5r90eovMEwF4
         zv0NJf6LE+okk0JRwwqz2Lyf4FpECOkbSfnaBoxZtZl7J78Juiq+3jM3S7j6HtPIAuA6
         Y9DEY2XHefI0mR+Y7gmf02QKa7g5FzXhJefSIakdgY3F+pWiCJ0y9//bM8/aSd3cTKP5
         7LxRfy3UVwkD9WiRL9r7iZiPWBjkqWfwxi57zsgtCI6+GPn33MMCgI3c5i2HfT3bhlN2
         obvQ==
X-Gm-Message-State: AA+aEWZoIrkL/EcTJRHX9+Mgttt+fIwe53fyDvXmCTluRaQ7Xr3SDL/B
        9SpaoY4ggKpobvAs8tdyvkE=
X-Google-Smtp-Source: AFSGD/W99q4hL3XgXGWh7Ii1ngZDqHUJdj6vzGZjVkSqVHM4tHIHAa6katv/P8BByxPdcZAGn+k1+w==
X-Received: by 2002:a1c:7f0c:: with SMTP id a12mr3879047wmd.89.1544566537713;
        Tue, 11 Dec 2018 14:15:37 -0800 (PST)
Received: from flashbox ([2a01:4f8:10b:24a5::2])
        by smtp.gmail.com with ESMTPSA id x20sm1937176wme.6.2018.12.11.14.15.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Dec 2018 14:15:37 -0800 (PST)
Date:   Tue, 11 Dec 2018 15:15:35 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Daniel Scheller <d.scheller@gmx.net>,
        kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, linux-next@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-media@vger.kernel.org
Subject: Re: next-20181211 build: 1 failures 32 warnings (next-20181211)
Message-ID: <20181211221535.GA20165@flashbox>
References: <E1gWnrV-00086U-3m@optimist>
 <20181211220620.GS6686@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211220620.GS6686@sirena.org.uk>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Dec 11, 2018 at 10:06:20PM +0000, Mark Brown wrote:
> On Tue, Dec 11, 2018 at 07:38:33PM +0000, Build bot for Mark Brown wrote:
> 
> Today's -next fails to build an arm allmodconfig due to:
> 
> > 	arm-allmodconfig
> > ../arch/arm/include/asm/irq.h:35:50: error: unknown type name 'cpumask_t'
> > ../arch/arm/include/asm/irq.h:36:9: error: unknown type name 'bool'
> > ../arch/arm/include/asm/irq.h:35:50: error: unknown type name 'cpumask_t'
> > ../arch/arm/include/asm/irq.h:36:9: error: unknown type name 'bool'
> > ../arch/arm/include/asm/irq.h:35:50: error: unknown type name 'cpumask_t'
> > ../arch/arm/include/asm/irq.h:36:9: error: unknown type name 'bool'
> > ../arch/arm/include/asm/irq.h:35:50: error: unknown type name 'cpumask_t'
> > ../arch/arm/include/asm/irq.h:36:9: error: unknown type name 'bool'
> 
> in ddbridge-ci.c and some other media files.  This is because
> ddbridge.h includes asm/irq.h but that does not directly include headers
> which define the above types and it appears some header changes have
> removed an implicit inclusion of those.  Moving the asm includes after
> the linux ones in ddbridge.h fixes this though this appears to be
> against the coding style for media.

Hi Mark,

I sent a patch for this yesterday, I think moving the asm includes after
the linux ones is the correct fix according to the rest of the kernel:
https://lore.kernel.org/linux-media/20181210233514.3069-1-natechancellor@gmail.com/

Hopefully it can be picked up quickly.

Thanks,
Nathan
