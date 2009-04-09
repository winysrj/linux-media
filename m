Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:58822 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbZDIHRX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 03:17:23 -0400
Message-ID: <49DDA100.1030205@e-tobi.net>
Date: Thu, 09 Apr 2009 09:17:20 +0200
From: Tobi <listaccount@e-tobi.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Userspace issue with DVB driver includes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

I think it was the change from asm/types.h to linux/types.h:

-#include <asm/types.h>
+#include <linux/types.h>

...which somehow broke the VDR build with recent DVB driver releases (see
snippet A below).

The common workaround/solution to this seems to be to add a
"-D__KERNEL_STRICT_NAMES".

But this feels wrong to me.

Reordering the includes and making sure <sys/*> is included before
<linux/*> solves this issue too.

But ideally the include order shouldn't matter at all.

So my question is: How to deal with this? What's the recommended way for
userspace applications to include linux/dvb headers?

Here's a small example, that fails to compile with 2.6.29:

// #include <sys/types.h>
// #define __KERNEL_STRICT_NAMES

#include <linux/dvb/frontend.h>
#include <linux/dvb/video.h>

int main()
{
    return 0;
}

Two workarounds to this problem are to define __KERNEL_STRICT_NAMES or
including <sys/*> before the linux/dvb includes.

Any comments, suggestions?

Please see also:

http://www.linuxtv.org/pipermail/linux-dvb/2009-March/031934.html

bye,

Tobias

--- snippet A ---

In file included from /usr/include/netinet/in.h:24,
                 from /usr/include/arpa/inet.h:23,
                 from config.h:13,
                 from channels.h:13,
                 from device.h:13,
                 from dvbdevice.h:15,
                 from dvbdevice.c:10:
/usr/include/stdint.h:41: error: conflicting declaration 'typedef long int
int64_t'
/usr/include/linux/types.h:98: error: 'int64_t' has a previous declaration
as 'typedef __s64 int64_t'
/usr/include/stdint.h:56: error: conflicting declaration 'typedef long
unsigned int uint64_t'
/usr/include/linux/types.h:96: error: 'uint64_t' has a previous
declaration as 'typedef __u64 uint64_t'
