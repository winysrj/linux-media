Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:54182 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab0CFWqk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 17:46:40 -0500
Received: by fg-out-1718.google.com with SMTP id l26so689464fgb.1
        for <linux-media@vger.kernel.org>; Sat, 06 Mar 2010 14:46:38 -0800 (PST)
Date: Sun, 7 Mar 2010 00:46:33 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/master] af_key: fix netns ops ordering on module
 load/unload
Message-ID: <20100306224633.GA4005@x200>
References: <E1NnuyA-0001Am-Cv@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NnuyA-0001Am-Cv@www.linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 06, 2010 at 03:27:06PM +0100, Patch from Alexey Dobriyan wrote:
> From: Alexey Dobriyan <adobriyan@gmail.com>
> 
> 1. After sock_register() returns, it's possible to create sockets,
>    even if module still not initialized fully (blame generic module code
>    for that!)
> 2. Consequently, pfkey_create() can be called with pfkey_net_id still not
>    initialized which will BUG_ON in net_generic():
> 	kernel BUG at include/net/netns/generic.h:43!
> 3. During netns shutdown, netns ops should be unregistered after
>    key manager unregistered because key manager calls can be triggered
>    from xfrm_user module:
> 
>    	general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> 	pfkey_broadcast+0x111/0x210 [af_key]
> 	pfkey_send_notify+0x16a/0x300 [af_key]
> 	km_state_notify+0x41/0x70
> 	xfrm_flush_sa+0x75/0x90 [xfrm_user]
> 4. Unregister netns ops after socket ops just in case and for symmetry.
> 
> Reported by Luca Tettamanti.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Tested-by: Luca Tettamanti <kronos.it@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>

What this has to do with DVB?
