Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab0BANCW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 08:02:22 -0500
Message-ID: <4B66D0D1.5000207@redhat.com>
Date: Mon, 01 Feb 2010 11:02:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chicken Shack <chicken.shack@gmx.de>
CC: linux-media@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, Andreas Oberritter <obi@linuxtv.org>
Subject: Re: Videotext application crashes the kernel due to DVB-demux patch
References: <1265018173.2449.19.camel@brian.bconsult.de>
In-Reply-To: <1265018173.2449.19.camel@brian.bconsult.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Chicken Shack wrote:
> Hi,
> 
> here is a link to a patch which breaks backwards compatibility for a
> teletext software called alevt-dvb.
> 
> http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg04638.html
> 
> The kernel patch was introduced with kernel 2.6.32-rc1.
> It was Signed-off-by Brandon Philips, Mauro Carvalho Chehab and its
> author, Andreas Oberritter.
> 
> Previous help calls, not only on this list, have been ignored for
> reasons that I do not know.
> Even distro maintainers have given up and removed the DVB implementation
> of alevt from their distro list.
> 
> Is that really what things are up to?
> To pull through an API update by kernel patch, but simply dive off with
> the usual "Sorry, but I don't have no time" when objections or problems
> arise?
> 
> What the hell is going on in those peoples' minds?
> 
> It seems to me that the following disclaimer is worth nothing:
> 
> "If anyone has any objections, please let us know by sending a message
> to: Linux Media Mailing List <linux-me...@vger.kernel.org>"
> 
> Volunteers welcome! Who please consacres some time and DVB competence to
> give the appropriate hints please?

This is the first time I've seen an email about this subject from you
at the linux-media ML. Also, I didn't noticed any report or patches from distro 
packagers about a driver issue related to videotext. Also, there were no reply 
to the announcement that the patch would be sent upstream (the email you're 
pointing). Maybe I missed something.

If you found a bug on a patch that were already applied upstream, the
better procedure is to fill a bug report at kernel.bugzilla.org. Please
enclose there the full dmesg output and any other descriptions that may
help the developers to know what card/driver/application you're using, and
how to reproduce the bug. The application logs may also be useful, but please
don't mix it together with the dmesg.

Before reporting the bug, please test the latest stable kernel version (currently 
2.6.32.7) first, to be sure that this regression weren't correct yet, or, even
better, the latest development kernel, since the bug may already be solved.

The latest development kernel is found at the -git tree:
	http://git.linuxtv.org/v4l-dvb.git

-- 

Cheers,
Mauro
