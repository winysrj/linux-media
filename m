Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36226 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbcCJPiD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 10:38:03 -0500
Received: by mail-ig0-f180.google.com with SMTP id vs8so19842815igb.1
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2016 07:38:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <EFEC860B-B1FC-499D-911C-61DC3C0A9517@darmarit.de>
References: <19129703-C076-47F7-BEFF-8A57D172132D@darmarit.de>
	<EFEC860B-B1FC-499D-911C-61DC3C0A9517@darmarit.de>
Date: Thu, 10 Mar 2016 07:38:01 -0800
Message-ID: <CAA7C2qhER5Yzm3R5ReeAOc7u2JydN4FhankzspYqZ-P1wgUV6g@mail.gmail.com>
Subject: Re: DVBv5 Tools: VDR support seems to be broken (recommended patch)
From: VDR User <user.vdr@gmail.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> There is only one point I have a doubt: I have no ATSC
> experience (I'am in Europe/germ), so I simply added
> an "A" at the field "satellite pos.". This is what
> the w_scan tool does and this tool works fine with
> the vdr (please correct me if I'am wrong).

Instead of guessing about ATSC, why not look at the VDR source code
and get a definitive answer? I believe you'll find what you're looking
for in: dvbdevice.c
