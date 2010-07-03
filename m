Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46352 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab0GCD1K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jul 2010 23:27:10 -0400
Received: by vws5 with SMTP id 5so4459899vws.19
        for <linux-media@vger.kernel.org>; Fri, 02 Jul 2010 20:27:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C09482B.8030404@redhat.com>
References: <BQCH7Bq3jFB@christoph>
	<4C09482B.8030404@redhat.com>
Date: Fri, 2 Jul 2010 23:27:09 -0400
Message-ID: <AANLkTinVcxMFu7hCT3pO_S6JCKr-d3uMOOBnKSNYqjX9@mail.gmail.com>
Subject: Re: [PATCH 1/3] IR: add core lirc device interface
From: Jarod Wilson <jarod@wilsonet.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, jarod@redhat.com,
	linux-media@vger.kernel.org, Jon Smirl <jonsmirl@gmail.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Andy Walls <awalls@md.metrocast.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 4, 2010 at 2:38 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
...
> From my side, as I said before, I'd like to see a documentation of the defined API bits,
> and the removal of the currently unused ioctls (they can be added later, together
> with the patches that will introduce the code that handles them) to give my final ack.

Thanks to Christoph and me spending an exciting Friday night doing
docbook formatting for the first time ever, I've finally got a start
of a LIRC device interface API docbook doc together, along with all
the lirc_dev bits and ir-lirc-codec bridge, all me-tested-and-approved
w/four different mceusb devices, both send and receive. I'm about to
head out of town for the weekend, but hope to get patches in flight
either before then, or from the road. In the interim, the interested
can take a look here:

http://git.wilsonet.com/linux-2.6-ir-wip.git/?a=shortlog;h=refs/heads/patches

Nb: this branch has been non-fast-forward-ably updated against latest
linuxtv staging/rc. The prior variant there left too much
lirc-specific tx bits in mceusb, which have now all been moved into
ir-lirc-codec.

-- 
Jarod Wilson
jarod@wilsonet.com
