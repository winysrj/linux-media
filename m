Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C9FC282C2
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 02:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F612184B
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 02:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ohmlinxelectronics-com.20150623.gappssmtp.com header.i=@ohmlinxelectronics-com.20150623.gappssmtp.com header.b="sc/QcFSf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfAXCxn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 21:53:43 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44746 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbfAXCxn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 21:53:43 -0500
Received: by mail-lj1-f196.google.com with SMTP id k19-v6so3840814lji.11
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 18:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ohmlinxelectronics-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:cc;
        bh=n6RtpWHA8V03ECowmNKLCRPul4C13va65Kvspu1U98s=;
        b=sc/QcFSfgqJcCJepc6ZnfMzlKPlay3k7gx+JiAT+muAy+eSBAzjTpKL183EWVbdHID
         eM6/itBQDj5qTl/aE0HkIFKfCQUQEov6uByXHtcmsGLFoUYlfcDH4uCd32Orhzy8LTrm
         oQzDT7Y+QntQTGRqkzZOAdlT885HJ2Lt97SoqSk38W1NYcljUMhM7EB2d3Pk+n5VtYf7
         C0v7Pk4RI2HbdRK09UHdLU+UoWtVCuc7VtASbFNddrl5Dl99DK4dTxaZrXTjpuIV3NMd
         582wwmtT9U3uK2upzCf9Zx1ffNh9znHkZsi0OnXKHeRVHuOOzeVyY45FDyV7Jrqr+MMw
         FZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:cc;
        bh=n6RtpWHA8V03ECowmNKLCRPul4C13va65Kvspu1U98s=;
        b=QukdyL5qWJWOg8PWIkqiwHbJScRVmLP2Qv+y4Y3zsMSRKPhD3RInFNLfD/QxUUnFu4
         QLlRQ09SrTamYpDWkx1AKgJqDbMcCydBNdPFg9/Y6slreP+9olUY+Kx126izDzfQi1Kz
         2vD4vpgXrqWfhZHDTauBYEJllwYnPao1xm6oJ7fpSToaeprgH7DNqzPsAxETTHRNqPKr
         78OtXwC6YQnob28kcJ8Qdd6wKCS1kFr+86WzRpX4QhG3jLvV0kLLKFfePJJXeLTVdTKy
         kvuF7q8f3j6eiHgWUFa0hQBTOu4UVC39r5XB3mdQnQKklUJvpjXEsVpPxzHTY+MVmDsO
         A9ZA==
X-Gm-Message-State: AJcUukcnFoWGAwgaf1Rlob1nCKBKfqd2jS9o8SqNysRuV8HJEwIzWgnd
        aa0wUUxEQdBOl8tGnPK5Xc66kKHYsGwwmynsEkqgnHY0
X-Received: by 2002:a2e:6595:: with SMTP id e21-v6mt2825533ljf.123.1548298421079;
 Wed, 23 Jan 2019 18:53:41 -0800 (PST)
MIME-Version: 1.0
From:   Ken Sloat <ken.sloat@ohmlinxelectronics.com>
Date:   Wed, 23 Jan 2019 21:53:30 -0500
Message-ID: <CAPo_4QDW0r22ZTqtS_NDFWB3NFLBx9YEGgWKb-P9A3t_TBAFMQ@mail.gmail.com>
Subject: devicetree: media: Documentation of Bt.656 Bus DT bindings
Cc:     Ken Sloat <Ken.sloat@ohmlinxelectronics.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, yong.deng@magewell.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@bootlin.com, wens@csie.org,
        kieran.bingham@ideasonboard.com, laurent.pinchart@ideasonboard.com,
        jean-michel.hautbois@vodalys.com,
        Nate Drude <nate.drude@ohmlinxelectronics.com>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There are a number of v4l2 subdevices in the kernel that support a
Bt.656 bus also known as "embedded sync." Previously in older versions
of the kernel (and in the current 4.14 LTS kernel), the standard way
to enable this in device tree on a parallel bus was to simply omit all
hysync and vsync flags.

During some other kernel development I was doing, it was brought to my
attention that there is now a standard defined binding in
"video-interfaces.txt" called "bus-type" that should be used in order
to enable Bt.656 mode. While omitting the flags still appears to work
because of other assumptions made in v4l2-fwnode driver, this method
is now outdated and improper.

However, I have noticed that several dt binding docs have not been
updated to reflect this change and still reference the old method:

Documentation/devicetree/bindings/media/sun6i-csi.txt
/* If hsync-active/vsync-active are missing,
   embedded BT.656 sync is used */

Documentation/devicetree/bindings/media/i2c/tvp5150.txt
"If none of hsync-active, vsync-active and field-even-active is specified,
the endpoint is assumed to use embedded BT.656 synchronization."

Documentation/devicetree/bindings/media/i2c/adv7604.txt
"If none of hsync-active, vsync-active and pclk-sample is specified the
  endpoint will use embedded BT.656 synchronization."

and amazingly even
Documentation/devicetree/bindings/media/video-interfaces.txt in one of
the code snippets
/* If hsync-active/vsync-active are missing,
   embedded BT.656 sync is used */

In order to avoid future confusion in the matter and ensure that the
proper bindings are used, I am proposing submitting patches to update
these docs to at minimum remove these statements and maybe even adding
additional comments specifying the optional property and value for
Bt.656 where missing. I wanted to open a discussion here first before
doing this though. Thoughts?

Thanks,
Ken Sloat
