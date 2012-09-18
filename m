Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:34973 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab2IRAGO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 20:06:14 -0400
Received: by oago6 with SMTP id o6so5409465oag.19
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 17:06:14 -0700 (PDT)
MIME-Version: 1.0
From: Javier Marcet <jmarcet@gmail.com>
Date: Tue, 18 Sep 2012 02:05:53 +0200
Message-ID: <CAAnFQG_SrXyr8MtPDujciE2=QRQK8dAK_SPBE3rC_c-XNSC00w@mail.gmail.com>
Subject: Terratec Cinergy T PCIe Dual doesn;t work nder the Xen hypervisor
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I recently began to investigate the Xen hypervisor. One key piece of
the server I'm
using is its DVB tuners. I'm using a Terratec Cinergy T PCIe Dual.

When running on bare metal it works relatively well (it has other bugs
I'll report later),
but when running on a dom0 under the Xen hypervisor I get no data from
the tuners,
or very damaged data like if there was more noise than signal.

Initially I thought Xen would be the cause of the problem, but after
having written on
the Xen development mailing list and talked about it with a couple
developers, it isn't
very clear where the problem is. So far I haven't been able to get the
smallest warning
or error.

I thought someone more involved with the DVB drivers could give us a
hand. You can
see the thread on the Xen development ml here:

http://www.gossamer-threads.com/lists/xen/devel/256197#256197

Neither raising the loglevel nor enabling the cx23885, cx25840, drxk
and mt2063 debug
options I get anything wrong. Just scrambled data from the tuners.

I'd appreciate any help.


-- 
Javier Marcet <jmarcet@gmail.com>
