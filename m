Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:58303 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbeKIVvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Nov 2018 16:51:00 -0500
Date: Fri, 9 Nov 2018 12:10:38 +0000
From: Sean Young <sean@mess.org>
To: Peter Seiderer <ps.report@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v4l-utils] Add missing linux/bpf_common.h
Message-ID: <20181109121038.al23ts654c6vwwbl@gofer.mess.org>
References: <20181105203047.15258-1-ps.report@gmx.net>
 <20181106103856.66uhadykgsw2dqs3@gofer.mess.org>
 <20181106224358.2a1ea449@gmx.net>
 <20181107120544.zxfbbgibp5ubexn7@gofer.mess.org>
 <20181108221338.7e91416d@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108221338.7e91416d@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

On Thu, Nov 08, 2018 at 10:13:38PM +0100, Peter Seiderer wrote:
> Thanks, works for the buildroot use case (disabling
> bpf support unconditionally)...
> 
> The reason to provide copies of the linux kernel headers in  v4l-utils
> is to be independent of old(-er) headers provided by toolchains?
> 
> If so a copy of bpf_common.h is still needed (and the fallback, for
> out of linux kernel usage, define for __NR_bpf in bpf.h enhanced for
> all supported archs)?

I have seen this problem on debian 7. Why do we care about compiling
on something that ancient?


Sean
