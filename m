Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC85EC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 00:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DCA9213F2
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 00:19:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pNlQnuJE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfCSATq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 20:19:46 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:46007 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfCSATp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 20:19:45 -0400
Received: by mail-qt1-f170.google.com with SMTP id v20so20201897qtv.12
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2019 17:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:user-agent:mime-version;
        bh=gh4So58fShuIDrKKYWxRpz4vMe3+fIYhgvX6qKAttUA=;
        b=pNlQnuJEHExsTAaTfdmY9wmrBO2HrMh5NVuX4ZXLEbIcMMcyoTG6Ds9UPOU7g3gvjX
         V7Bt/86+da4mlMo8n09dzyOQeTFMLgDfmLdzZMwHToeVE8I5Gy2ud2rGL+DDebw6cs5I
         8ykWlTE/w7QWc1Xw3wl47oqhXeQX6BZb/X97Tby3fjAuIrAAAhaAX9FyCCOGHEhkPWe9
         Yv5N+ZUMeCd/892UI+0lfg67dMFmK4NpW0i50+lKNxI+QBnUfXNssyRZYjtNOByhvd5I
         ahK29hb1Jc/9FLgkiQCoDtQinMn4hAk26rz29n0x7n4VPvM4Sl0JB7s20F53BPrwI4Ua
         wpdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:user-agent
         :mime-version;
        bh=gh4So58fShuIDrKKYWxRpz4vMe3+fIYhgvX6qKAttUA=;
        b=pneRpno1QedgRh3aiFQ9MSZ1A+0C5cpaK57XMwxbP4gAwQCKNbQAQ85yFYrP9zrPqn
         b79f/XG8qGdbzxaByzxVJ5yUs4KMnEE1goq/juUg1NuGg6wsTEQAfFHINCaEGOyrTIlC
         68mC7jDFwfC95WM+GMMEZ/iFBQyumvW3Ji10owtc/08Vx2B0iNhynksfUDCyhbJ9uD8P
         3XPh2HQKQMFBlVF67oKjSJ520P2+EYkhDVONrDM/IBf2DhBs8LxDEjJyU7Cx60yqzCMw
         M6MW9fCy3CfuXOQII8cxfkevYMZ1EZfafnFi0WaaRn1+dT6wzIlpx0lYpwXfqtpRec52
         0YDg==
X-Gm-Message-State: APjAAAWNoLAYlJthE8YWw2tehCOMMkx6ncU+qysiyecKe/88a4oYOG2Q
        257g+DiE/9PceAS6TmbX74igKKNf
X-Google-Smtp-Source: APXvYqwaIrAiIy/vp8+HCNvgkcdir1SxdJfaekzUJtJ5tRUuwFGII9/EnXAYP4Cab+5kyA2DDKL8hQ==
X-Received: by 2002:ac8:1738:: with SMTP id w53mr16214613qtj.201.1552954784394;
        Mon, 18 Mar 2019 17:19:44 -0700 (PDT)
Received: from adicarlo.nyc ([2604:2000:efc0:107:4818:196b:81d3:da7e])
        by smtp.gmail.com with ESMTPSA id u187sm6300511qkf.59.2019.03.18.17.19.43
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 Mar 2019 17:19:43 -0700 (PDT)
Received: from gw.coo (localhost [127.0.0.1])
        by adicarlo.nyc (Postfix) with ESMTP id CF611A980A1
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2019 20:19:42 -0400 (EDT)
From:   Adam Di Carlo <a.p.dicarlo@gmail.com>
To:     linux-media@vger.kernel.org
Subject: ir-keytable known bug -- fails to work when device specified
Date:   Mon, 18 Mar 2019 20:19:42 -0400
Message-ID: <8736njzpep.fsf@gw.coo>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


There seems to be known issue with ir-keytable such that while

  ./ir-keytable -p rc5

works, this one won't:

  ./ir-keytable -d /dev/input/event24 -p rc5

Reading the source, it looks like the internal 'rc_dev' struct is really
only filled out (get_attribs()) in the case where the device isn't
passed in.


Rather than document all this, isn't better to clean it up in the
source?  I can probably come up with a patch for this issue in fairly
short order, if that's welcome.

-- 
...Adam Di Carlo...<a.p.dicarlo@gmail.com>............................
