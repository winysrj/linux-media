Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28506C43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 02:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA8CE217F9
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 02:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="arBrZrFt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbeL2CKz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 28 Dec 2018 21:10:55 -0500
Received: from mail-lf1-f41.google.com ([209.85.167.41]:37361 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbeL2CKz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Dec 2018 21:10:55 -0500
Received: by mail-lf1-f41.google.com with SMTP id y11so15512056lfj.4
        for <linux-media@vger.kernel.org>; Fri, 28 Dec 2018 18:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=8Tr0BfKL8OGWJaQEiw2AW30lLqpKq/ZWhi02/Myq1vY=;
        b=arBrZrFt7C3pjNIdnplolDEFW89Ob+si5Bn+CSwQ5ZwW/ljlJxmwPWFSoWyN9G5vqQ
         xtDkrJW1mafPukiupjdm8t8Jlsi+k+ftGnO1mmotezo/wn+BNXRzqZU5SAV4Os9wg56k
         BL2gicpIK/kHPN3aeoYwJ64j8f/notMX9Wsbvr12it1eB9Y/XqFRRDAy8QCdBwnsALw1
         nTWYk2Jnu2sBQAtRt3ZJV5kAdGuEiZwR4tu+8vnELJMPrY5iZSddSYRwHtLTJe3twbP6
         QXeQqk0+ZmaxjzMPPFtyf+HSJySzXp+3SgixjqNXVjYr12t+OdHa7UV2jDTotact9Thy
         ex5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=8Tr0BfKL8OGWJaQEiw2AW30lLqpKq/ZWhi02/Myq1vY=;
        b=RMLsJi+njXreHNCnezhxyQZGs0j1tazxaPdhOzz9McpKS3SBp/RheUv19sXx6pp0oe
         iEqad/C8VnZYBtAhyrNd3NWGQB6qJLburyRxJjOE5TGSrTUiIGQak06aUQepqeJlGabJ
         ypNKME9+xqZrZavfZvmmZ8+d/8AotqqEkG5D/FIVZU+o8P/1uNFWmECttu6dPLXIJAzJ
         +bGpTtxu9z/LjDki11HjscZFaRaSlM9rLmKxghoO7SdsW+Gui7gDhaiBVsthncDe8JoG
         ZhYuRjK5ScdE3NcOXmYDivtZBNM7SIezpM3OIk7WTn4S64BDzQKZsVtC1dMXD/hnpRXY
         NE4Q==
X-Gm-Message-State: AA+aEWaO7wWSkNgbjf52haoV/u7gnNT+pwISzUXnignpkIQNEz/r+jpp
        /vNxWgoFlNpmrjMFqO4YzOVTz6c+tcwmTOr03t483nxhxw==
X-Google-Smtp-Source: AFSGD/U3msAoTB5xRHR2QTzcpjhHtLTXKZfE12luPkuUAA3mzQRqkpR26qII82qEv0TJ0V9GqZ9l1b/J7AtpCygrRWc=
X-Received: by 2002:a19:7352:: with SMTP id o79mr16153404lfc.104.1546049452688;
 Fri, 28 Dec 2018 18:10:52 -0800 (PST)
MIME-Version: 1.0
From:   Yi Qingliang <niqingliang2003@gmail.com>
Date:   Sat, 29 Dec 2018 10:10:41 +0800
Message-ID: <CADwFkYdCXY5my5DW=qGJcJBDpjtZpRHXN6h4H2geneekiOzCgg@mail.gmail.com>
Subject: epoll and vb2_poll: can't wake_up
To:     linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello, I encountered a "can't wake_up" problem when use camera on imx6.

if delay some time after 'streamon' the /dev/video0, then add fd
through epoll_ctl, then the process can't be waken_up after some time.

I checked both the epoll / vb2_poll(videobuf2_core.c) code.

epoll will pass 'poll_table' structure to vb2_poll, but it only
contain valid function pointer when inserting fd.

in vb2_poll, if found new data in done list, it will not call 'poll_wait'.
after that, every call to vb2_poll will not contain valid poll_table,
which will result in all calling to poll_wait will not work.

so if app can process frames quickly, and found frame data when
inserting fd (i.e. poll_wait will not be called or not contain valid
function pointer), it will not found valid frame in 'vb2_poll' finally
at some time, then call 'poll_wait' to expect be waken up at following
vb2_buffer_done, but no good luck.

I also checked the 'videobuf-core.c', there is no this problem.

of course, both epoll and vb2_poll are right by itself side, but the
result is we can't get new frames.

I think by epoll's implementation, the user should always call poll_wait.

and it's better to split the two actions: 'wait' and 'poll' both for
epoll framework and all epoll users, for example, v4l2.

am I right?

Yi Qingliang
