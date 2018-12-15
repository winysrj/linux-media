Return-Path: <SRS0=dU+R=OY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5377AC43444
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 14:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 233902171F
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 14:57:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RIj0WZ80"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbeLOO5r (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 15 Dec 2018 09:57:47 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44853 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729966AbeLOO5q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Dec 2018 09:57:46 -0500
Received: by mail-pf1-f196.google.com with SMTP id u6so4232462pfh.11;
        Sat, 15 Dec 2018 06:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+oZ8yQFI+tBK9p+3AmPM+g1VsW4TbnbAmenwuop//G4=;
        b=RIj0WZ80o7T2oHJfoXbW9K4AtxUB63cORHEymtuAvPEAZyvmHU1AiqS+D/AOG/OpgA
         /qaj5KgYoCk0lANaiuRgovG580UsEkQLNhpLtPPGlY7yomrn6RTPmiSzgQq6ojrw8E+I
         hmdIcyTnZyTYtX8UDxxM/L/uPOTdV83REEfN9AxruIQSn9dfDIVeYBAmyAFAtfwZtJ+p
         JRJLJ4Aizqf+li42qP3OJiqUFZyytKB03+JFwtN17H3umAV2ca1fp/ACWQBNWoVMVvox
         ZC/t2aDW9t595Byanw8sCCuwX9QzkIvWTuKZ2YSSk7pfpDE40oZVW2iIPQIEO4BKUHwM
         Bmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+oZ8yQFI+tBK9p+3AmPM+g1VsW4TbnbAmenwuop//G4=;
        b=nNiEyeJl7O8SV/nkyukWX/AUsvRefWSzt/gfrWjRAFGNtr+/D/zPfiQ1q6Eyp/4Rdy
         rNrWuUFQrH5ZIsDi59AF19vfca5PtbP1F/iz+eubouY0fkTOIWt/hihJiZysfXjde8xi
         5yjEFpTcnrY0CZnPmvKc+TrcXYonshM4+Bh6wmacyPuCGaycSsyE7Zw4e6F4GZl22hUA
         mUd5bsANUP2dvQSqM56dylEyek1KtQ4phF5vsTWO5Jjm0gpzuJmBCk1MLeqqwAupUxkM
         qsXbobwxUkdHV+pDDjvuhv4l57ia/X9pfk16vjLx6elWVkou8updNJh39m06IDdakFEQ
         btMw==
X-Gm-Message-State: AA+aEWa0Ppdl7mDOTshIs8hP/csxlNbplN64/9vPBzQbeoxl9EZshgKI
        +s49KNg+mecs67USiB9WvloHb7h6
X-Google-Smtp-Source: AFSGD/USDnpzPISPYb8ceeqq0IFsuHp/zdAef1v0Hz7qxMBl11J60Ik5z/YP0tmNfqnQuNuiAm3znA==
X-Received: by 2002:a63:9041:: with SMTP id a62mr3012889pge.163.1544885865326;
        Sat, 15 Dec 2018 06:57:45 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z191sm9077804pgd.74.2018.12.15.06.57.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Dec 2018 06:57:44 -0800 (PST)
Subject: Re: [PATCH 3/6] sparc: remove the sparc32_dma_ops indirection
To:     Christoph Hellwig <hch@lst.de>
Cc:     iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-snps-arc@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, sparclinux@vger.kernel.org,
        openrisc@lists.librecores.org, linux-parisc@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20181208174115.16237-1-hch@lst.de>
 <20181208174115.16237-4-hch@lst.de> <20181215063018.GA11415@roeck-us.net>
 <20181215104720.GA1575@lst.de>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <53761fd8-06f1-6443-1997-f518e725925e@roeck-us.net>
Date:   Sat, 15 Dec 2018 06:57:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181215104720.GA1575@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/15/18 2:47 AM, Christoph Hellwig wrote:
> On Fri, Dec 14, 2018 at 10:30:18PM -0800, Guenter Roeck wrote:
>> and so on, until qemu is terminated. This is seen with all sparc32
>> qemu emulations. Reverting the patch fixes the problem.
> 
> Hi Guenter,
> 
> can you check which of the three new ops is used in this case?  Or
> provide the qemu config and rootfs?
> 

sparc32 defconfig+CONFIG_SQUASHFS=y+CONFIG_DEVTMPFS=y, and:

qemu-system-sparc -M SPARCClassic -kernel arch/sparc/boot/image \
	-no-reboot -snapshot -drive file=/var/cache/buildbot/sparc/hda.sqf,if=scsi,format=raw \
	-append 'root=/dev/sda rw init=/sbin/init.sh panic=1 console=ttyS0' \
	-nographic

qemu version doesn't seem to matter. I used gcc-7.3.0 using the toolchain from kernel.org
to build the image.

Root file system is at https://github.com/groeck/linux-build-test/tree/master/rootfs/sparc/.

Guenter
