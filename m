Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54244 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab0FUQMY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 12:12:24 -0400
Received: by vws3 with SMTP id 3so1207172vws.19
        for <linux-media@vger.kernel.org>; Mon, 21 Jun 2010 09:12:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277110376-6993-1-git-send-email-bjorn@mork.no>
References: <1277110376-6993-1-git-send-email-bjorn@mork.no>
Date: Mon, 21 Jun 2010 09:12:23 -0700
Message-ID: <AANLkTilghfY5tsC0V4m6IQ1VIFE-j-rB4i6Xi2mYevwV@mail.gmail.com>
Subject: Re: [PATCH] Mantis, hopper: use MODULE_DEVICE_TABLE use the macro to
	make modules auto-loadable
From: VDR User <user.vdr@gmail.com>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>,
	"Ozan ?a?layan" <ozan@pardus.org.tr>,
	Manu Abraham <manu@linuxtv.org>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/6/21 Bjørn Mork <bjorn@mork.no>:
> Thanks to Ozan ?a?layan <ozan@pardus.org.tr> for pointing it out
>
> From: Manu Abraham <abraham.manu@gmail.com>
>
> Signed-off-by: Manu Abraham <manu@linuxtv.org>
> [bjorn@mork.no: imported from http://jusst.de/hg/mantis-v4l-dvb/raw-rev/3731f71ed6bf]
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> Cc: stable@kernel.org
> ---
> This patch is so obviously correct that I do not know how to write it differently.
>
> It is copied from the mercurial repostory at http://jusst.de/hg/mantis-v4l-dvb/
> where it has been resting for more than 4 months. I certainly hope everyone is
> OK with me just forwarding it like this...  My only agenda is a fully functional
> mantis driver in the kernel.

Instead of copy&paste patches from Manu's tree, maybe it's better to
just wait for him to push all the changes into v4l.  There have been
many bug fixes & improvements Manu has done that haven't been pushed
into v4l yet and I think it's better to sync the entire driver instead
of cherry picking patches here & there.

-Derek
