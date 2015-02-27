Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:33418 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbbB0QBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2015 11:01:51 -0500
Received: by ykr79 with SMTP id 79so7561798ykr.0
        for <linux-media@vger.kernel.org>; Fri, 27 Feb 2015 08:01:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54EFAC4B.6080002@redmandi.dyndns.org>
References: <54EE90BF.2030602@redmandi.dyndns.org>
	<CALzAhNX=KCnLmcv3iNtCwH2OLSTErytvK1kZpGCbAyQtmt6How@mail.gmail.com>
	<54EFAC4B.6080002@redmandi.dyndns.org>
Date: Fri, 27 Feb 2015 11:01:50 -0500
Message-ID: <CALzAhNU8TYNQPP7Vi85=nU2SG+YybwqrMFDh2Dd-HnPi90Y6Bg@mail.gmail.com>
Subject: Re: [PATCHv2] [media] saa7164: use an MSI interrupt when available
From: Steven Toth <stoth@kernellabs.com>
To: Brendan McGrath <redmcg@redmandi.dyndns.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 26, 2015 at 6:29 PM, Brendan McGrath
<redmcg@redmandi.dyndns.org> wrote:
> From: Brendan McGrath <redmcg@redmandi.dyndns.org>
> [media] saa7164: use an MSI interrupt when available
>
> Enhances driver to use an MSI interrupt when available.
>
> Adds the module option 'enable_msi' (type bool) which by default is enabled.
> Can be set to 'N' to disable.
>
> Fixes (or can reduce the occurrence of) a crash which is most commonly
> reported when multiple saa7164 chips are in use.
>
> Signed-off-by: Brendan McGrath <redmcg@redmandi.dyndns.org>

Thank you Brendan.

Reviewed-by: Steven Toth <stoth@kernellabs.com>

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
