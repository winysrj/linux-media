Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC64C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 17:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C70A206DD
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 17:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VH+jskWE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfCDRtB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 12:49:01 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:37565 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfCDRtB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 12:49:01 -0500
Received: by mail-lj1-f181.google.com with SMTP id a17so5087674ljd.4
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2019 09:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=O2iR5B/ctFHaI9/23neKFPyv6yFeqzybQ5I/mjeHf3w=;
        b=VH+jskWE6K06WvIDmQAG5h0q+uEizGOG1wtEW9mgCq6xNoa/bK/J64CdRLKN2j9vTl
         zY6sTcFrL5wdfblV0vsxLJJUQHg6GywgiB5hjKcWMmWE6nnsqmS1r+s7PbbttP9h6oNn
         UCjIA8WybZsGmD1FBllyRCDFnMpN7XhJaQ3EmAlNyADAWb0Juidapqo8dToldZxaS/Eh
         SDj9J98NXr78yCR5g+rH5VtCWZhWZm3J0Bgj8lrXN4bxkC07NXS4OPmq63MmRKgsDNjt
         vo15xufMdCHJc+6Atdwp1QcRl21tY2WkIKCsImGQZDwEYIn14+Zg6oT7HVXux/iyyXnn
         WU/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=O2iR5B/ctFHaI9/23neKFPyv6yFeqzybQ5I/mjeHf3w=;
        b=oASIg1OEs0YQpBBJDmegQH0cSc34bOO29wkgsNRMgwxmIC6xz9ePobZZmL21y1e1NG
         AyXP5hR0/bfbSe/RzCgsptjd4EOwDbpHtArp3pE4jfaSLh4/X9nAZC43ERxbirvLyJAX
         mNgxI0HYFS+hlc9yqX+kbpdh1KzzZAkiXgvcI5o5d1kSip8fCs6NBJyTCBUEc1mwMCad
         F5Q3uFMbZPso/cjEjdJJ3dBRGQj0nhheoLDlONVOTsOlg61cVTDBXiaP9aiwbkrMkTjJ
         CMCJosrxhMCCr2NXqKfYEgkADOuMMpD0B6aLyNHH0IJLanZQCL88P/V7T0Uc0EjkL1AK
         MDpA==
X-Gm-Message-State: APjAAAVS5hcy9/XNoeKLYPTnq8ma6IzaHwzrCaqZCngChgsO6spq0ZUs
        5p0NoUjKyxAZ1gm60Y611sbKQKAdqBr5AtoR051CXMAc
X-Google-Smtp-Source: APXvYqwccZn6ISBXJ/dljgntIHmqAASHGjHGp+NPx6l1/+bMMnNlk7BGrcASBcuZ+XHj5eRtjSKQRpBHXJaljnqYYmE=
X-Received: by 2002:a2e:9d85:: with SMTP id c5mr12273379ljj.70.1551721738606;
 Mon, 04 Mar 2019 09:48:58 -0800 (PST)
MIME-Version: 1.0
From:   Ranran <ranshalit@gmail.com>
Date:   Mon, 4 Mar 2019 19:48:49 +0200
Message-ID: <CAJ2oMhJZgPv+PTJ3CF8v=_PZYnG9_ejxj6R2a-ddZZAHugyCVw@mail.gmail.com>
Subject: Finding where in kernel a frame is captured
To:     linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

I try to find the exact place where frame are captured in kernel.
I rather find the first place, but if that is a problem, I will use
another method you are familiar with.
I use tegra tx1 with mipi camera of a development kit, so I tried to
add some printing in kernel in vi2_fops.c in
tegra_channel_capture_done() and tegra_channel_capture_frame(), but
nothing is printed while the userspace application capture frames
(using gstreamer).
Although there are no print during frame captured, yet, there are
printed logs in vi2_channel_stop_streaming,
vi2_channel_start_streaming.

Is there any reason why I can't see any logs ? Is the rate is too high ?
Should I try to find where it is captured in v4l2 framework in kernel instead ?

Thanks,
ranran
