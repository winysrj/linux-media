Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.4 required=3.0 tests=BODY_SINGLE_WORD,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849A0C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 05:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D8BD218A1
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 05:26:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="etqlgQJ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfBFF0i (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 00:26:38 -0500
Received: from mail-it1-f170.google.com ([209.85.166.170]:36870 "EHLO
        mail-it1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfBFF0i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 00:26:38 -0500
Received: by mail-it1-f170.google.com with SMTP id b5so3540546iti.2
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 21:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ruW4UFXxVsMKbdPMnmxDaTv+16pA7U93ISteQk0ZEwg=;
        b=etqlgQJ0FbxUx7Zt1asnzJBYqxJTLHdsJWamrsIYEXPataj95/GvtqFsPqLsPDjWAa
         BBnoR2OqZBIr82eCxLERZGmmB/5evOS6YZEL5k3UQhKGdEmvLllUJx4VSVa+z+0nlcYA
         IKG9tdpC/jJeInHP1+mgehRRysS0rGKit/Fi/L517F8y2Y7k0KiHOQBVeR+cvgLcT8B1
         Yqisk6KoYMGi8YuDXNGf2hIGGYL/jX6NP09NhgmMbdsjHzj5A1c1A+DgFjhh0KFV1ZPl
         NmQPjj7ROdOrgRo9N697/aGAnfotHJJhrPistWSUMsGtwiMAvqhZ72kM5O+aM5hWQmgP
         WdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ruW4UFXxVsMKbdPMnmxDaTv+16pA7U93ISteQk0ZEwg=;
        b=glUUHJwa3nTY/0VdDLJ3whTg8H6G9JYX5r1UUE6gbyhJIJv16ZyaBXy/GwWIKm/BkL
         HZ68bDKF4Xn+V7IprP3wd3gHZ8WQ/7ryo7c4dpnNH3PMMQH00cJK6eVVKzenlm+ckVXe
         tYkropK5JiIAR1fNLGcyuYutI9+rPhh6wMMa7zI2XUQUdn5apQcNTWWY4+t5Pd30AzXL
         j3YNxD/r9IbDu52gsSYMF2nZRfB/qdxVMvgRKe21wtdLg8Aoeyx/+gSBYmlYBG1ZqkAS
         zOVIqyA9ZexI1RmrtbIQPJ/PclyVY2FrlbJ2ZLXF2SxzszYHhOjuJ6BPPr334FiMP2g/
         /EvA==
X-Gm-Message-State: AHQUAuaLaPFfAGP9hPYpVdWSpP0o+vEpZXh8f3qHsQcY4OyPJw3WIN8g
        8625IZe3bGsw6XB00yZ+JhcMguLQo1MuWynoun5tDg==
X-Google-Smtp-Source: AHgI3Ib1X/Jq1bPKizjOWbV589NOhalSyUd487x7HK/lfl/vWta1q62BRd3Y3kjzL2nVeXQSkXVigDhoFzcgmgmcyDE=
X-Received: by 2002:a5e:d808:: with SMTP id l8mr4451891iok.299.1549430797435;
 Tue, 05 Feb 2019 21:26:37 -0800 (PST)
MIME-Version: 1.0
From:   John Klug <ski.brimson@gmail.com>
Date:   Tue, 5 Feb 2019 23:26:26 -0600
Message-ID: <CADU0VqzLYQ__zFrhtANE780yRr5=i8kCTF089_FWjkxz3HBYqQ@mail.gmail.com>
Subject: help
To:     linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

help
