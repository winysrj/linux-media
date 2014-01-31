Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailsafe.webbplatsen.se ([94.247.172.109]:61382 "EHLO
	mailsafe.webbplatsen.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaAaKUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 05:20:24 -0500
Date: Fri, 31 Jan 2014 11:20:18 +0100
From: Joakim Hernberg <jbh@alchemy.lu>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH TEST] ts2020.c : correct divider settings
Message-ID: <20140131112018.76fdb93b@tor.valhalla.alchemy.lu>
In-Reply-To: <1390596853.3346.38.camel@canaries32-MCP7A>
References: <20140122200408.3d0fc1cf@tor.valhalla.alchemy.lu>
	<20140124164309.778dcfbd@tor.valhalla.alchemy.lu>
	<1390596853.3346.38.camel@canaries32-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 24 Jan 2014 20:54:13 +0000
Malcolm Priestley <tvboxspy@gmail.com> wrote:

> Here is alternative ndiv code, it is based on vendors code.
> 
> It uses the ndiv value not frequency to change the divider.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/media/dvb-frontends/ts2020.c | 24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/ts2020.c
> b/drivers/media/dvb-frontends/ts2020.c index 9aba044..9e051efb 100644

The problem was fixed by the other patch (and I suspect that it's
specific to the TeVii hardware affected), but if I find some time I'll
certainly have a play around with this patch too.

Thanks,

-- 

   Joakim
