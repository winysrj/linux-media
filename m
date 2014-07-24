Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:49294 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934045AbaGXHPf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 03:15:35 -0400
Received: by mail-vc0-f179.google.com with SMTP id hq11so4074177vcb.24
        for <linux-media@vger.kernel.org>; Thu, 24 Jul 2014 00:15:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1406109436-23922-2-git-send-email-sonic.adi@gmail.com>
References: <1406109436-23922-1-git-send-email-sonic.adi@gmail.com>
	<1406109436-23922-2-git-send-email-sonic.adi@gmail.com>
Date: Thu, 24 Jul 2014 15:15:34 +0800
Message-ID: <CAHG8p1CAADwAL0VwRXu4pYGePR_Mf96WMbCKHVZ5MKyW6+W23w@mail.gmail.com>
Subject: Re: [PATCH 2/3] v4l2: bfin: Ensure delete and reinit list entry on
 NOMMU architecture
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	LMML <linux-media@vger.kernel.org>,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-07-23 17:57 GMT+08:00 Sonic Zhang <sonic.adi@gmail.com>:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> On NOMMU architecture page fault is not triggered if a deleted list entry is
> accessed without reinit.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
