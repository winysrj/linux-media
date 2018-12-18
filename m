Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 028A0C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 15:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B129721871
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 15:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernelci-org.20150623.gappssmtp.com header.i=@kernelci-org.20150623.gappssmtp.com header.b="hxXHeH0H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbeLRPb1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 10:31:27 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46685 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbeLRPb1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 10:31:27 -0500
Received: by mail-wr1-f68.google.com with SMTP id l9so16291023wrt.13
        for <linux-media@vger.kernel.org>; Tue, 18 Dec 2018 07:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Yix0TUlscVIsfme/eG2e5VVyIlrdHO3939Qcbv9pVas=;
        b=hxXHeH0HeszbRxSkGAxMIDsqWBYLztWikLjf8MrK5MZyiUxJDcxKjKbAcjzM45ZwHM
         OQOrGySvnIe/Fl+ZVo1uazcMl3fLFQsYvDdcWjWa1Ky2iU1HFYyBEViN8Cz9CTi+P8ry
         0NAUYaX2JLdJ/iFxVawEqh09DWwuc3ilHtwWowraUpG0kKZPuVbzSRpS8utv6Erk+qf5
         CCFF9sSGxi5RlrUd2IsQLyCvq3VdnhmBu5qWxrmmGkapLSkcAqB7Izob3RkFkJ0dJ3ap
         g+G0pw8K7Ja8m2kEd9KKHolwXaJJAorVlhmMXXp1hAxSmy/gIAtcu5SDN7wAU8nr8xLp
         +xRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Yix0TUlscVIsfme/eG2e5VVyIlrdHO3939Qcbv9pVas=;
        b=lwYrbjD7LcwP3x2EA5jj0KVicDjsWgkWhuoLb4pznbuWtO6hUJd0h2rb9OCt44YmGt
         FCLdokyqJpYiX/o7+Us+FnT4V2Oylx+Wa9KeSOIO0bI00p1HYNRzKMSoDLy8uqgv2ADp
         LWDncGoTyzGLeZHpKeMYqUAbspW2HmeFik1GSYfnYbuZAgv/KUtUffe4P7z0ejOPYOxz
         zYo1YXpxO90s4Ssy4PrJ/yW32UImBOet6qytkH5jMmx4SMNDBvm3P9mBJuVOKNKdi6CC
         G3s12I/mq5pXGiHiQnJoUlcPhGLikhLEIvPxEQG9qf9u+BprejPUcff8lnnrSgrHA5qy
         G0yA==
X-Gm-Message-State: AA+aEWZAqXRG9k9s/K7SxlJUJzYgcR4bbLu0a4WTnbGQed3PbIyUgZa6
        PnlfCgcLXElEapTKeAbkWxzIxdqGMMRx3w==
X-Google-Smtp-Source: AFSGD/VmIztlRjd7MqFJ+Au95TJSG6TcpiDdeZDb3vIKVmd/7tGKGcWGoDTcmsOpSfeu7HQ8IHVnow==
X-Received: by 2002:adf:94e4:: with SMTP id 91mr16048667wrr.322.1545147084229;
        Tue, 18 Dec 2018 07:31:24 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m4sm3214450wmi.3.2018.12.18.07.31.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Dec 2018 07:31:23 -0800 (PST)
Message-ID: <5c1912cb.1c69fb81.6be62.391b@mx.google.com>
Date:   Tue, 18 Dec 2018 07:31:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: media
X-Kernelci-Kernel: v4.20-rc5-281-gd2b4387f3bdf
X-Kernelci-Report-Type: test
X-Kernelci-Branch: master
Subject: Test results (v4l2) for media/master - v4.20-rc5-281-gd2b4387f3bdf
To:     linux-media@vger.kernel.org, ezequiel@collabora.com,
        guillaume.tucker@collabora.com, ana.guerrero@collabora.com
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Test results for:
  Tree:    media
  Branch:  master
  Kernel:  v4.20-rc5-281-gd2b4387f3bdf
  URL:     https://git.linuxtv.org/media_tree.git
  Commit:  d2b4387f3bdf016e266d23cf657465f557721488
  Test plans: v4l2

Summary
-------
4 test groups results

1  | v4l2       | rk3399-gru-kevin       | arm64 |  49 total:  17 PASS   6 =
FAIL  26 SKIP
2  | v4l2       | rk3288-veyron-jaq      | arm   |  49 total:  17 PASS   6 =
FAIL  26 SKIP
3  | v4l2       | qemu                   | arm64 | 115 total:  77 PASS   7 =
FAIL  31 SKIP
4  | v4l2       | qemu                   | arm   | 115 total:  77 PASS   7 =
FAIL  31 SKIP

---
1  | v4l2       | rk3399-gru-kevin       | arm64 |  49 total:  17 PASS   6 =
FAIL  26 SKIP

  Config:      defconfig
  Lab Name:    lab-collabora
  Date:        2018-12-14 19:51:24.841000
  TXT log:     https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2=
b4387f3bdf/arm64/defconfig/lab-collabora/v4l2-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2=
b4387f3bdf/arm64/defconfig/lab-collabora/v4l2-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/debian/stretch-v4l=
2/20181207.0/arm64/rootfs.cpio.gz
  Test Git:    git://linuxtv.org/v4l-utils.git
  Test Commit: 7a118f166609c0d05c6447cc79484af37875d6fc


    Output-ioctls - 5 tests: 0  PASS, 0 FAIL, 5 SKIP
  =

    Buffer-ioctls-Input-0 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
      * Requests: FAIL
  =

    Required-ioctls - 2 tests: 2  PASS, 0 FAIL, 0 SKIP
  =

    Input/Output-configuration-ioctls - 4 tests: 0  PASS, 0 FAIL, 4 SKIP
  =

    Control-ioctls-Input-0 - 6 tests: 3  PASS, 2 FAIL, 1 SKIP
      * VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
      * VIDIOC_QUERY_EXT_CTRL/QUERYMENU: FAIL
  =

    Codec-ioctls-Input-0 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
  =

    Debug-ioctls - 2 tests: 0  PASS, 0 FAIL, 2 SKIP
  =

    Format-ioctls-Input-0 - 10 tests: 4  PASS, 1 FAIL, 5 SKIP
      * VIDIOC_G/S_PARM: FAIL
  =

    Streaming-ioctls_Test-input-0 - 4 tests: 1  PASS, 2 FAIL, 1 SKIP
      * USERPTR: FAIL
      * MMAP: FAIL
  =

    Input-ioctls - 6 tests: 1  PASS, 0 FAIL, 5 SKIP
  =

    Allow-for-multiple-opens - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
  =

2  | v4l2       | rk3288-veyron-jaq      | arm   |  49 total:  17 PASS   6 =
FAIL  26 SKIP

  Config:      multi_v7_defconfig
  Lab Name:    lab-collabora
  Date:        2018-12-14 19:51:35.774000
  TXT log:     https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2=
b4387f3bdf/arm/multi_v7_defconfig/lab-collabora/v4l2-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2=
b4387f3bdf/arm/multi_v7_defconfig/lab-collabora/v4l2-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/debian/stretch-v4l=
2/20181207.0/armhf/rootfs.cpio.gz
  Test Git:    git://linuxtv.org/v4l-utils.git
  Test Commit: 7a118f166609c0d05c6447cc79484af37875d6fc


    Output-ioctls - 5 tests: 0  PASS, 0 FAIL, 5 SKIP
  =

    Buffer-ioctls-Input-0 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
      * Requests: FAIL
  =

    Required-ioctls - 2 tests: 2  PASS, 0 FAIL, 0 SKIP
  =

    Input/Output-configuration-ioctls - 4 tests: 0  PASS, 0 FAIL, 4 SKIP
  =

    Control-ioctls-Input-0 - 6 tests: 3  PASS, 2 FAIL, 1 SKIP
      * VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
      * VIDIOC_QUERY_EXT_CTRL/QUERYMENU: FAIL
  =

    Codec-ioctls-Input-0 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
  =

    Debug-ioctls - 2 tests: 0  PASS, 0 FAIL, 2 SKIP
  =

    Format-ioctls-Input-0 - 10 tests: 4  PASS, 1 FAIL, 5 SKIP
      * VIDIOC_G/S_PARM: FAIL
  =

    Streaming-ioctls_Test-input-0 - 4 tests: 1  PASS, 2 FAIL, 1 SKIP
      * USERPTR: FAIL
      * MMAP: FAIL
  =

    Input-ioctls - 6 tests: 1  PASS, 0 FAIL, 5 SKIP
  =

    Allow-for-multiple-opens - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
  =

3  | v4l2       | qemu                   | arm64 | 115 total:  77 PASS   7 =
FAIL  31 SKIP

  Config:      defconfig+virtualvideo
  Lab Name:    lab-collabora
  Date:        2018-12-14 20:04:54.451000
  TXT log:     https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2=
b4387f3bdf/arm64/defconfig+virtualvideo/lab-collabora/v4l2-qemu.txt
  HTML log:    https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2=
b4387f3bdf/arm64/defconfig+virtualvideo/lab-collabora/v4l2-qemu.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/debian/stretch-v4l=
2/20181207.0/arm64/rootfs.cpio.gz
  Test Git:    git://linuxtv.org/v4l-utils.git
  Test Commit: 7a118f166609c0d05c6447cc79484af37875d6fc


    Buffer-ioctls-Input-3 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
      * Requests: FAIL
  =

    Buffer-ioctls-Input-2 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
      * Requests: FAIL
  =

    Buffer-ioctls-Input-1 - 3 tests: 1  PASS, 2 FAIL, 0 SKIP
      * Requests: FAIL
      * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
  =

    Buffer-ioctls-Input-0 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
      * Requests: FAIL
  =

    Control-ioctls-Input-3 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
  =

    Control-ioctls-Input-2 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
  =

    Control-ioctls-Input-1 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
  =

    Control-ioctls-Input-0 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
  =

    Debug-ioctls - 2 tests: 1  PASS, 0 FAIL, 1 SKIP
  =

    Format-ioctls-Input-2 - 10 tests: 9  PASS, 0 FAIL, 1 SKIP
  =

    Format-ioctls-Input-3 - 10 tests: 9  PASS, 0 FAIL, 1 SKIP
  =

    Format-ioctls-Input-0 - 10 tests: 6  PASS, 0 FAIL, 4 SKIP
  =

    Format-ioctls-Input-1 - 10 tests: 5  PASS, 2 FAIL, 3 SKIP
      * Scaling: FAIL
      * VIDIOC_S_FMT: FAIL
  =

    Required-ioctls - 2 tests: 2  PASS, 0 FAIL, 0 SKIP
  =

    Input/Output-configuration-ioctls - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
  =

    Codec-ioctls-Input-2 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
  =

    Codec-ioctls-Input-3 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
  =

    Codec-ioctls-Input-0 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
  =

    Codec-ioctls-Input-1 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
  =

    Output-ioctls - 5 tests: 1  PASS, 0 FAIL, 4 SKIP
  =

    Streaming-ioctls_Test-input-0 - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
  =

    Input-ioctls - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
  =

    Allow-for-multiple-opens - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
  =

4  | v4l2       | qemu                   | arm   | 115 total:  77 PASS   7 =
FAIL  31 SKIP

  Config:      multi_v7_defconfig+virtualvideo
  Lab Name:    lab-collabora
  Date:        2018-12-14 20:10:05.962000
  TXT log:     https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2=
b4387f3bdf/arm/multi_v7_defconfig+virtualvideo/lab-collabora/v4l2-qemu.txt
  HTML log:    https://storage.kernelci.org//media/master/v4.20-rc5-281-gd2=
b4387f3bdf/arm/multi_v7_defconfig+virtualvideo/lab-collabora/v4l2-qemu.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/debian/stretch-v4l=
2/20181207.0/armhf/rootfs.cpio.gz
  Test Git:    git://linuxtv.org/v4l-utils.git
  Test Commit: 7a118f166609c0d05c6447cc79484af37875d6fc


    Buffer-ioctls-Input-3 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
      * Requests: FAIL
  =

    Buffer-ioctls-Input-2 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
      * Requests: FAIL
  =

    Buffer-ioctls-Input-1 - 3 tests: 1  PASS, 2 FAIL, 0 SKIP
      * Requests: FAIL
      * VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
  =

    Buffer-ioctls-Input-0 - 3 tests: 2  PASS, 1 FAIL, 0 SKIP
      * Requests: FAIL
  =

    Control-ioctls-Input-3 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
  =

    Control-ioctls-Input-2 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
  =

    Control-ioctls-Input-1 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
  =

    Control-ioctls-Input-0 - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
  =

    Debug-ioctls - 2 tests: 1  PASS, 0 FAIL, 1 SKIP
  =

    Format-ioctls-Input-2 - 10 tests: 9  PASS, 0 FAIL, 1 SKIP
  =

    Format-ioctls-Input-3 - 10 tests: 9  PASS, 0 FAIL, 1 SKIP
  =

    Format-ioctls-Input-0 - 10 tests: 6  PASS, 0 FAIL, 4 SKIP
  =

    Format-ioctls-Input-1 - 10 tests: 5  PASS, 2 FAIL, 3 SKIP
      * Scaling: FAIL
      * VIDIOC_S_FMT: FAIL
  =

    Required-ioctls - 2 tests: 2  PASS, 0 FAIL, 0 SKIP
  =

    Input/Output-configuration-ioctls - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
  =

    Codec-ioctls-Input-2 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
  =

    Codec-ioctls-Input-3 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
  =

    Codec-ioctls-Input-0 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
  =

    Codec-ioctls-Input-1 - 3 tests: 0  PASS, 0 FAIL, 3 SKIP
  =

    Output-ioctls - 5 tests: 1  PASS, 0 FAIL, 4 SKIP
  =

    Streaming-ioctls_Test-input-0 - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
  =

    Input-ioctls - 6 tests: 5  PASS, 0 FAIL, 1 SKIP
  =

    Allow-for-multiple-opens - 4 tests: 4  PASS, 0 FAIL, 0 SKIP
 =20
