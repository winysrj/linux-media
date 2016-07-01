Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:63886 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbcGAKxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 06:53:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] cec: fix Kconfig dependency problems
Date: Fri, 01 Jul 2016 12:55:55 +0200
Message-ID: <8175255.KZ9CmBnTPL@wuerfel>
In-Reply-To: <619887af-e879-d4ec-5697-50ee101eaf51@xs4all.nl>
References: <619887af-e879-d4ec-5697-50ee101eaf51@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, July 1, 2016 12:37:06 PM CEST Hans Verkuil wrote:
> - Use IS_REACHABLE(RC_CORE) instead of IS_ENABLED: if cec is built-in and
>   RC_CORE is a module, then CEC can't reach the RC symbols.
> - Both cec and cec-edid should be bool and use the same build 'mode' as
>   MEDIA_SUPPORT (just as is done for the media controller code).
> - Add a note to staging that this should be changed once the cec framework
>   is moved out of staging.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Arnd Bergmann <arnd@arndb.de>

This looks ok, but I'll give it some more randconfig build testing and will
try to report back later today. If you don't hear from me, it's probably
ok.

There is still another issue with the header, I'll send a patch for it
since I've already done one.

	Arnd
