Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:36399 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886AbcCTJyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Mar 2016 05:54:19 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 551DF182E9A
	for <linux-media@vger.kernel.org>; Sun, 20 Mar 2016 10:54:09 +0100 (CET)
Subject: Re: cron job: media_tree daily build: ABI WARNING
To: linux-media@vger.kernel.org
References: <20160320040141.4F8CB182E7D@tschai.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56EE7341.1080302@xs4all.nl>
Date: Sun, 20 Mar 2016 10:54:09 +0100
MIME-Version: 1.0
In-Reply-To: <20160320040141.4F8CB182E7D@tschai.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/20/2016 05:01 AM, Hans Verkuil wrote:
> ABI WARNING: change for arm-at91
> ABI WARNING: change for arm-davinci
> ABI WARNING: change for arm-exynos
> ABI WARNING: change for arm-mx
> ABI WARNING: change for arm-omap
> ABI WARNING: change for arm-omap1
> ABI WARNING: change for arm-pxa
> ABI WARNING: change for blackfin-bf561
> ABI WARNING: change for i686
> ABI WARNING: change for m32r
> ABI WARNING: change for mips
> ABI WARNING: change for powerpc64
> ABI WARNING: change for sh
> ABI WARNING: change for x86_64

Ignore the ABI warning: it's my fault caused by different 'sort' results
due to a different LC_ALL setting.

Should now be fixed.

Regards,

	Hans
