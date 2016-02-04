Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42839 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbcBDEvi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2016 23:51:38 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A02DF2034C
	for <linux-media@vger.kernel.org>; Thu,  4 Feb 2016 04:51:37 +0000 (UTC)
Received: from mail-ob0-f172.google.com (mail-ob0-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 3103920375
	for <linux-media@vger.kernel.org>; Thu,  4 Feb 2016 04:51:36 +0000 (UTC)
Received: by mail-ob0-f172.google.com with SMTP id wb13so56130261obb.1
        for <linux-media@vger.kernel.org>; Wed, 03 Feb 2016 20:51:36 -0800 (PST)
MIME-Version: 1.0
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 3 Feb 2016 20:51:16 -0800
Message-ID: <CALCETrUNxPhcKiT+aswO5rr+ZpPPCkT30+Exd0iWwQnMN921Qg@mail.gmail.com>
Subject: linux-api scope (Re: [PATCH v2 11/22] media: dvb-frontend invoke
 enable/disable_source handlers)
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org, Linux API <linux-api@vger.kernel.org>,
	ALSA development <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[cc list heavily trimmed]

On Wed, Feb 3, 2016 at 8:03 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> Change dvb frontend to check if tuner is free when
> device opened in RW mode. Call to enable_source
> handler either returns with an active pipeline to
> tuner or error if tuner is busy. Tuner is released
> when frontend is released calling the disable_source
> handler.

As an actual subscriber to linux-api, I prefer for the linux-api list
to be lowish-volume and mostly limited to API-related things.  Is this
API related?  Do people think that these series should be sent to
linux-api?

Thanks,
Andy
