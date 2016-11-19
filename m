Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59652 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752735AbcKSO5H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 09:57:07 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 0/3] Avoid warnings about using unitialized dest_dir
Date: Sat, 19 Nov 2016 12:56:57 -0200
Message-Id: <cover.1479567006.git.mchehab@s-opensource.com>
In-Reply-To: <20161027150848.3623829-1-arnd@arndb.de>
References: <20161027150848.3623829-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As Arnd reported:

	With gcc-5 or higher on x86, we can get a bogus warning in the
	dvb-net code:

	drivers/media/dvb-core/dvb_net.c: In function ‘dvb_net_ule’:
	arch/x86/include/asm/string_32.h:77:14: error: ‘dest_addr’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
	drivers/media/dvb-core/dvb_net.c:633:8: note: ‘dest_addr’ was declared here

Inspecting the code is really hard, as the function Arnd patched is really
complex.

IMHO, the best is to first simplify the logic, by breaking parts of it into
sub-routines, and then apply a proper fix.

This patch series does that.

Arnd,

After splitting the function, I think that the GCC 5 warning is not bogus,
as this code:
		skb_copy_from_linear_data(h->priv->ule_skb, dest_addr,
					  ETH_ALEN);

is called before initializing dest_dir, but, even if I'm wrong, it is not a bad
idea to zero the dest_addr before handing the logic.

PS.: I took a lot of care to avoid breaking something on this series, as I don't
have any means here to test DVB net.  So, I'd appreciate if you could take
a look and see if everything looks fine.

Thanks!
Mauro


Mauro Carvalho Chehab (3):
  [media] dvb_net: prepare to split a very complex function
  [media] dvb-net: split the logic at dvb_net_ule() into other functions
  [media] dvb_net: simplify the logic that fills the ethernet address

 drivers/media/dvb-core/dvb_net.c | 927 ++++++++++++++++++++++-----------------
 1 file changed, 526 insertions(+), 401 deletions(-)

-- 
2.7.4


