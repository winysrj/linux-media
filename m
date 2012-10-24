Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:45383 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2JXQst (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 12:48:49 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so444359lag.19
        for <linux-media@vger.kernel.org>; Wed, 24 Oct 2012 09:48:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351080856-20469-1-git-send-email-festevam@gmail.com>
References: <1351080856-20469-1-git-send-email-festevam@gmail.com>
Date: Wed, 24 Oct 2012 12:48:48 -0400
Message-ID: <CAOS58YO+4VtHyB9rgPcZ52-ka3usoVDM7OM-+hrcj=89WQoj-w@mail.gmail.com>
Subject: Re: [PATCH] [media] ivtv: ivtv-driver: Replace 'flush_work_sync()'
From: Tejun Heo <tj@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: awalls@md.metrocast.net, mchehab@infradead.org,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 24, 2012 at 8:14 AM, Fabio Estevam <festevam@gmail.com> wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> Since commit 43829731d (workqueue: deprecate flush[_delayed]_work_sync()),
> flush_work() should be used instead of flush_work_sync().
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
