Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.cooptel.qc.ca ([216.144.115.12]:59857 "EHLO
	amy.cooptel.qc.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755794Ab0BMNkd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2010 08:40:33 -0500
Message-ID: <4B76ABD0.8050002@cooptel.qc.ca>
Date: Sat, 13 Feb 2010 08:40:32 -0500
From: Richard Lemieux <rlemieu@cooptel.qc.ca>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Driver crash on kernel 2.6.32.7. Interaction between cx8800 (DVB-S)
 and USB HVR Hauppauge 950q
References: <4B70E7DB.7060101@cooptel.qc.ca>	 <1265768091.3064.109.camel@palomino.walls.org>	 <4B722266.4070805@cooptel.qc.ca>	 <829197381002091912h5391129dpbf075485ab011936@mail.gmail.com>	 <1265816096.4019.65.camel@palomino.walls.org>	 <20100212041131.GA29697@suse.de> <1266023937.3062.17.camel@palomino.walls.org>
In-Reply-To: <1266023937.3062.17.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I was in the process of setting up my machine so I can run any of
the tests you might ask for.  First I needed a fully tested backup partition,
and then I needed to bring udev up to date.  But I see that the problem
is pretty much resolved right now.  As Devin said earlier I doubt I can ever
reproduce this event.  Thanks very much for everything you do for the Linux 
community.

Richard

Andy Walls wrote:
> Yes.  But it will take me a while.  I don't have a git tree, because I
> don't have high bandwidth internet yet.  (The cable company's been
> delayed in laying cable to my home due to repeated snowstorms.)
> 
> I just didn't want the problem to fall through the cracks.  I'll submit
> something to bugzilla for now.  If a user complains of this rare Ooops
> when loading firmware, the current workaround is to lengthen the timeout
> via sysfs.
> 
> Regards,
> Andy

