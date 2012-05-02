Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47185 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab2EBUEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 16:04:05 -0400
Received: by vcqp1 with SMTP id p1so759636vcq.19
        for <linux-media@vger.kernel.org>; Wed, 02 May 2012 13:04:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <25369268.1335986594418.JavaMail.root@mswamui-thinleaf.atl.sa.earthlink.net>
References: <25369268.1335986594418.JavaMail.root@mswamui-thinleaf.atl.sa.earthlink.net>
Date: Wed, 2 May 2012 16:04:04 -0400
Message-ID: <CAGoCfix5iDqkUnVSgRxk7GDKGDKEvhWnH--6fyO_106Jg+E15Q@mail.gmail.com>
Subject: Re: HVR-1800 Analog Driver: MPEG video broken
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: sitten74490@mypacks.net
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 2, 2012 at 3:23 PM,  <sitten74490@mypacks.net> wrote:
> I just tried again with a live CD running kernel 3.2 and got clean video with cat /dev/video1 > /tmp/foo.mpg.  So there is a definitely a regression here.  Please let me know what I can do to help track it down.

I'm already about 95% certain this was something introduced in
Steven's last batch of cx23885 changes for the HVR-1850.  I just need
to do a register dump for both the working and failing case, see which
register got screwed up on the 1800, then look at the code figure out
how it got into that state.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
