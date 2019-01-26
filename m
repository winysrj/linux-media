Return-Path: <SRS0=XDLN=QC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB6EC282C7
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 13:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C884121872
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 13:48:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iNwf8K4l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfAZNs1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 26 Jan 2019 08:48:27 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55131 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfAZNs0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Jan 2019 08:48:26 -0500
Received: by mail-wm1-f68.google.com with SMTP id a62so9309213wmh.4
        for <linux-media@vger.kernel.org>; Sat, 26 Jan 2019 05:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zqjhuf8tLJnScZ6oU2bwGNQJvI5FzCHfYdTY+vAB7PU=;
        b=iNwf8K4ll9eALqH9pNd5JKSA39tNFV6B9jQBt6aZeizpYfqkQEZ39JoWjf5tnsSMKr
         rEtLIq+8XHOy6g44G8uEw2kFJxNBZS9mLB2d5hy1kSS0AtQHLx5gLudyj0mA4vMYTH4x
         QGb4jcHtag9NoGIh4mzw9+NUYIKuEhUieuEdSJLNYP+9jev3WVD/L1FBhGkQvZ3FTVKK
         /ZZiDkEyI2XcW1gA3RVMW1htMkIVLHM3DAfj2MxYAVU54hWUm/nBSVQP0JmqwQcktJFn
         PpaPcJsNrd05DnFNHOUFG5lMMdB/7LitGd7zvJJa18cgPPATbrnSBN3BLociU7y864Qv
         NrXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zqjhuf8tLJnScZ6oU2bwGNQJvI5FzCHfYdTY+vAB7PU=;
        b=mBRlH//scUMPGJFoU15vnC5mO2VGMvW887UUQBvPllFoI34OA33FWYYbdUZvFCTkQc
         /2mNnm83uXn0l6tMHXi2YeulD4/w5dNErLDt7Neh7R+zIPgMkbD7HW/sr3XDlkN3krZf
         dPWaq8o9b8vDLD3uKfqiDH18/bSfskE0koihqB9AUkgUtBytH+v5X4JTLyFzXaxyNHvh
         txC/sNtXJ0AzC5M+dagQJ/8NT+lcFcCCulz2+CyE/etGcgiGgpSq+UfruB/JdWnMEngK
         8Tzah69ET4SppZff0gKAbto1CQB68eeaOFyS9hbjIpPDzPNwzSxGMTytS35ZsHgGarpl
         4+aw==
X-Gm-Message-State: AJcUukdK9cgGl53NsBM0hNYBOT1HphAumbT5Prkrn+SzBJgZ3kJRYmhi
        ZiBfqWv5PHeXa/nf0yO4wBczFGHmuLk=
X-Google-Smtp-Source: ALg8bN4XmkDtaEFtwc0CsFeuBsXQPp2o44rX5cQ9t1BZqpmWbkn1bIQ+WOjWEhFv/fVyQOiSCXSPsw==
X-Received: by 2002:a1c:9855:: with SMTP id a82mr9983681wme.20.1548510504797;
        Sat, 26 Jan 2019 05:48:24 -0800 (PST)
Received: from ubuntu.home ([77.124.106.231])
        by smtp.gmail.com with ESMTPSA id v6sm101552298wrd.88.2019.01.26.05.48.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Jan 2019 05:48:24 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 0/3] Prepare for statless decoder for fwht
Date:   Sat, 26 Jan 2019 05:47:56 -0800
Message-Id: <20190126134759.97680-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Patches to prepare for the implementation of the statless
decoder api in vicodec

Dafna Hirschfeld (3):
  media: vicodec: add struct for encoder/decoder instance
  media: vicodec: Introducing stateless fwht defs and structs
  media: vicodec: Register another node for stateless decoder

 drivers/media/platform/vicodec/vicodec-core.c | 231 +++++++++++-------
 drivers/media/v4l2-core/v4l2-ctrls.c          |   6 +
 include/uapi/linux/v4l2-controls.h            |  10 +
 include/uapi/linux/videodev2.h                |   1 +
 4 files changed, 163 insertions(+), 85 deletions(-)

-- 
2.17.1

