Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B901EC43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 17:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EDC420815
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 17:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545155558;
	bh=WgyGtM3qIgZMrsA9TeBT0BI2XxN04CsKTL9DzZ3npUE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=roE1TTc7FXK+azWYNPgbrqV2lgy8K+4KUL3ojhJV6w7yR9zhzQ3+Vg4qYVMVQ3g0Z
	 g2zxCq6yvL4yMqkFIm+6SlYPKVj1Gh1EyZRHosSdztomBOSlLR37uBtJTeHi64poGn
	 Qdm/9v83An7QPafp/OknXmm7dKVXhoA5EXtZdAp4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbeLRRwi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 12:52:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:41446 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbeLRRwh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 12:52:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C3cdNsUPcVfCZnpfqgV2sN8ltps9eFIEjRTumQJaZ3M=; b=csMQpQLL84qyIxcR55w4QSCw4J
        08QiHSaPhNOf32bYiJSxlB2+8xl7+Xlgp+rQhLio60UsoWfZXIQGyVEGt60YO3XJ7iLSP4dNmvhSZ
        zsNw5UZ7KQKzd6Eah7sEtNEZerfL4cOfoSWme0Qja084ab++6lOz5OQD8R3YK42/Nr8HDVt/+IZ8i
        L7uhM98bxGH4/bAQ/wz62RcsDQXj4HBjMLlVnZgmFrd1CtANn/irJNChfT/8VzLwhYiUkJJZTX5h4
        yS4lpNwYpjdaYvSQ5kExR/QtiLWdcdaOZA6/GprqhbzPOsLC0o/ISWGX3FFB+Y1gvAJ2EXDNlXz3H
        ghFbGJ5A==;
Received: from 177.205.112.95.dynamic.adsl.gvt.net.br ([177.205.112.95] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gZJXn-0004Cm-8P; Tue, 18 Dec 2018 17:52:35 +0000
Date:   Tue, 18 Dec 2018 15:52:31 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     ezequiel@collabora.com
Cc:     linux-media@vger.kernel.org, guillaume.tucker@collabora.com,
        ana.guerrero@collabora.com
Subject: Re: Test results (v4l2) for media/master -
 v4.20-rc5-281-gd2b4387f3bdf
Message-ID: <20181218155231.3b3b6d8b@coco.lan>
In-Reply-To: <5c1912cb.1c69fb81.6be62.391b@mx.google.com>
References: <5c1912cb.1c69fb81.6be62.391b@mx.google.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue, 18 Dec 2018 07:31:23 -0800 (PST)
"kernelci.org bot" <bot@kernelci.org> escreveu:

> Test results for:
>   Tree:    media
>   Branch:  master
>   Kernel:  v4.20-rc5-281-gd2b4387f3bdf
>   URL:     https://git.linuxtv.org/media_tree.git
>   Commit:  d2b4387f3bdf016e266d23cf657465f557721488
>   Test plans: v4l2
> 
> Summary
> -------
> 4 test groups results
> 
> 1  | v4l2       | rk3399-gru-kevin       | arm64 |  49 total:  17 PASS   6 FAIL  26 SKIP
> 2  | v4l2       | rk3288-veyron-jaq      | arm   |  49 total:  17 PASS   6 FAIL  26 SKIP
> 3  | v4l2       | qemu                   | arm64 | 115 total:  77 PASS   7 FAIL  31 SKIP
> 4  | v4l2       | qemu                   | arm   | 115 total:  77 PASS   7 FAIL  31 SKIP

Please add, at linuxtv.org's wiki page, what each test actually means...

> 
> ---
> 1  | v4l2       | rk3399-gru-kevin       | arm64 |  49 total:  17 PASS   6 FAIL  26 SKIP
> 
>   Config:      defconfig
>   Lab Name:    lab-collabora
>   Date:        2018-12-14 19:51:24.841000
>   TXT log:     https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2b4387f3bdf/arm64/defconfig/lab-collabora/v4l2-rk3399-gru-kevin.txt
>   HTML log:    https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2b4387f3bdf/arm64/defconfig/lab-collabora/v4l2-rk3399-gru-kevin.html
>   Rootfs:      http://storage.kernelci.org/images/rootfs/debian/stretch-v4l2/20181207.0/arm64/rootfs.cpio.gz
>   Test Git:    git://linuxtv.org/v4l-utils.git
>   Test Commit: 7a118f166609c0d05c6447cc79484af37875d6fc
> 
> 
>     Output-ioctls - 5 tests: 0  PASS, 0 FAIL, 5 SKIP
>   
>     Buffer-ioctls-Input-0 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
>       * Requests: FAIL
>   
>     Required-ioctls - 2 tests: 2  PASS, 0 FAIL, 0 SKIP
>   
>     Input/Output-configuration-ioctls - 4 tests: 0  PASS, 0 FAIL, 4 SKIP
>   
>     Control-ioctls-Input-0 - 6 tests: 3  PASS, 2 FAIL, 1 SKIP
>       * VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
>       * VIDIOC_QUERY_EXT_CTRL/QUERYMENU: FAIL

... for example, in this specific case, I have no idea what driver 
failed. Ok, one could open the log txt file, look on it and
discover that this specific test was against the uvcvideo driver,
but it is doubtful to expect that everybody would do that.

The best would be to also c/c the developer of the specific
driver, if listed at MAINTAINERS, as he is the one that should
come up with a fix.

I also think that the patch subject should be changed to reflect the
actual problems that was got, e. g., something like:

[KernelCI] v4l2-compliance: uvcvideo: 6 failures, driver_foo: 8 failures

>   
>     Codec-ioctls-Input-0 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
>   
>     Debug-ioctls - 2 tests: 0  PASS, 0 FAIL, 2 SKIP
>   
>     Format-ioctls-Input-0 - 10 tests: 4  PASS, 1 FAIL, 5 SKIP
>       * VIDIOC_G/S_PARM: FAIL
>   
>     Streaming-ioctls_Test-input-0 - 4 tests: 1  PASS, 2 FAIL, 1 SKIP
>       * USERPTR: FAIL
>       * MMAP: FAIL
>   
>     Input-ioctls - 6 tests: 1  PASS, 0 FAIL, 5 SKIP
>   
>     Allow-for-multiple-opens - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
>   
> 2  | v4l2       | rk3288-veyron-jaq      | arm   |  49 total:  17 PASS   6 FAIL  26 SKIP
> 
>   Config:      multi_v7_defconfig
>   Lab Name:    lab-collabora
>   Date:        2018-12-14 19:51:35.774000
>   TXT log:     https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2b4387f3bdf/arm/multi_v7_defconfig/lab-collabora/v4l2-rk3288-veyron-jaq.txt
>   HTML log:    https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2b4387f3bdf/arm/multi_v7_defconfig/lab-collabora/v4l2-rk3288-veyron-jaq.html
>   Rootfs:      http://storage.kernelci.org/images/rootfs/debian/stretch-v4l2/20181207.0/armhf/rootfs.cpio.gz
>   Test Git:    git://linuxtv.org/v4l-utils.git
>   Test Commit: 7a118f166609c0d05c6447cc79484af37875d6fc
> 
> 
>     Output-ioctls - 5 tests: 0  PASS, 0 FAIL, 5 SKIP
>   
>     Buffer-ioctls-Input-0 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
>       * Requests: FAIL
>   
>     Required-ioctls - 2 tests: 2  PASS, 0 FAIL, 0 SKIP
>   
>     Input/Output-configuration-ioctls - 4 tests: 0  PASS, 0 FAIL, 4 SKIP
>   
>     Control-ioctls-Input-0 - 6 tests: 3  PASS, 2 FAIL, 1 SKIP
>       * VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
>       * VIDIOC_QUERY_EXT_CTRL/QUERYMENU: FAIL
>   
>     Codec-ioctls-Input-0 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
>   
>     Debug-ioctls - 2 tests: 0  PASS, 0 FAIL, 2 SKIP
>   
>     Format-ioctls-Input-0 - 10 tests: 4  PASS, 1 FAIL, 5 SKIP
>       * VIDIOC_G/S_PARM: FAIL
>   
>     Streaming-ioctls_Test-input-0 - 4 tests: 1  PASS, 2 FAIL, 1 SKIP
>       * USERPTR: FAIL
>       * MMAP: FAIL
>   
>     Input-ioctls - 6 tests: 1  PASS, 0 FAIL, 5 SKIP
>   
>     Allow-for-multiple-opens - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
>   
> 3  | v4l2       | qemu                   | arm64 | 115 total:  77 PASS   7 FAIL  31 SKIP
> 
>   Config:      defconfig+virtualvideo
>   Lab Name:    lab-collabora
>   Date:        2018-12-14 20:04:54.451000
>   TXT log:     https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2b4387f3bdf/arm64/defconfig+virtualvideo/lab-collabora/v4l2-qemu.txt
>   HTML log:    https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2b4387f3bdf/arm64/defconfig+virtualvideo/lab-collabora/v4l2-qemu.html
>   Rootfs:      http://storage.kernelci.org/images/rootfs/debian/stretch-v4l2/20181207.0/arm64/rootfs.cpio.gz
>   Test Git:    git://linuxtv.org/v4l-utils.git
>   Test Commit: 7a118f166609c0d05c6447cc79484af37875d6fc
> 
> 
>     Buffer-ioctls-Input-3 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
>       * Requests: FAIL
>   
>     Buffer-ioctls-Input-2 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
>       * Requests: FAIL
>   
>     Buffer-ioctls-Input-1 - 3 tests: 1  PASS, 2 FAIL, 0 SKIP
>       * Requests: FAIL
>       * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
>   
>     Buffer-ioctls-Input-0 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
>       * Requests: FAIL
>   
>     Control-ioctls-Input-3 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
>   
>     Control-ioctls-Input-2 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
>   
>     Control-ioctls-Input-1 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
>   
>     Control-ioctls-Input-0 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
>   
>     Debug-ioctls - 2 tests: 1  PASS, 0 FAIL, 1 SKIP
>   
>     Format-ioctls-Input-2 - 10 tests: 9  PASS, 0 FAIL, 1 SKIP
>   
>     Format-ioctls-Input-3 - 10 tests: 9  PASS, 0 FAIL, 1 SKIP
>   
>     Format-ioctls-Input-0 - 10 tests: 6  PASS, 0 FAIL, 4 SKIP
>   
>     Format-ioctls-Input-1 - 10 tests: 5  PASS, 2 FAIL, 3 SKIP
>       * Scaling: FAIL
>       * VIDIOC_S_FMT: FAIL
>   
>     Required-ioctls - 2 tests: 2  PASS, 0 FAIL, 0 SKIP
>   
>     Input/Output-configuration-ioctls - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
>   
>     Codec-ioctls-Input-2 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
>   
>     Codec-ioctls-Input-3 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
>   
>     Codec-ioctls-Input-0 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
>   
>     Codec-ioctls-Input-1 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
>   
>     Output-ioctls - 5 tests: 1  PASS, 0 FAIL, 4 SKIP
>   
>     Streaming-ioctls_Test-input-0 - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
>   
>     Input-ioctls - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
>   
>     Allow-for-multiple-opens - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
>   
> 4  | v4l2       | qemu                   | arm   | 115 total:  77 PASS   7 FAIL  31 SKIP
> 
>   Config:      multi_v7_defconfig+virtualvideo
>   Lab Name:    lab-collabora
>   Date:        2018-12-14 20:10:05.962000
>   TXT log:     https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2b4387f3bdf/arm/multi_v7_defconfig+virtualvideo/lab-collabora/v4l2-qemu.txt
>   HTML log:    https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2b4387f3bdf/arm/multi_v7_defconfig+virtualvideo/lab-collabora/v4l2-qemu.html
>   Rootfs:      http://storage.kernelci.org/images/rootfs/debian/stretch-v4l2/20181207.0/armhf/rootfs.cpio.gz
>   Test Git:    git://linuxtv.org/v4l-utils.git
>   Test Commit: 7a118f166609c0d05c6447cc79484af37875d6fc
> 
> 
>     Buffer-ioctls-Input-3 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
>       * Requests: FAIL
>   
>     Buffer-ioctls-Input-2 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
>       * Requests: FAIL
>   
>     Buffer-ioctls-Input-1 - 3 tests: 1  PASS, 2 FAIL, 0 SKIP
>       * Requests: FAIL
>       * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
>   
>     Buffer-ioctls-Input-0 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
>       * Requests: FAIL
>   
>     Control-ioctls-Input-3 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
>   
>     Control-ioctls-Input-2 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
>   
>     Control-ioctls-Input-1 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
>   
>     Control-ioctls-Input-0 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
>   
>     Debug-ioctls - 2 tests: 1  PASS, 0 FAIL, 1 SKIP
>   
>     Format-ioctls-Input-2 - 10 tests: 9  PASS, 0 FAIL, 1 SKIP
>   
>     Format-ioctls-Input-3 - 10 tests: 9  PASS, 0 FAIL, 1 SKIP
>   
>     Format-ioctls-Input-0 - 10 tests: 6  PASS, 0 FAIL, 4 SKIP
>   
>     Format-ioctls-Input-1 - 10 tests: 5  PASS, 2 FAIL, 3 SKIP
>       * Scaling: FAIL
>       * VIDIOC_S_FMT: FAIL
>   
>     Required-ioctls - 2 tests: 2  PASS, 0 FAIL, 0 SKIP
>   
>     Input/Output-configuration-ioctls - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
>   
>     Codec-ioctls-Input-2 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
>   
>     Codec-ioctls-Input-3 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
>   
>     Codec-ioctls-Input-0 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
>   
>     Codec-ioctls-Input-1 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
>   
>     Output-ioctls - 5 tests: 1  PASS, 0 FAIL, 4 SKIP
>   
>     Streaming-ioctls_Test-input-0 - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
>   
>     Input-ioctls - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
>   
>     Allow-for-multiple-opens - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
>   

Again, I would simplify the report, printing only a summary of the
failures. You can store a less summarized report at the KernelCI
storage server.

Thanks,
Mauro
