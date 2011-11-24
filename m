Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab1KXAcy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 19:32:54 -0500
Message-ID: <4ECD90AD.1020803@redhat.com>
Date: Wed, 23 Nov 2011 22:32:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Lawrence Rust <lawrence@softsystem.co.uk>
CC: Andy Walls <awalls@md.metrocast.net>,
	Jarod Wilson <jarod@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] ir-rc6-decoder: Support RC6-6A variable length data
References: <1320064772.1669.13.camel@gagarin>
In-Reply-To: <1320064772.1669.13.camel@gagarin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 31-10-2011 10:39, Lawrence Rust escreveu:
> Hi,
> 
> Thanks for the comments and feedback that you gave concerning this
> patch.  In the light of these I have made some small changes.
> 
> In particular I would like to address Mauro's comments regarding
> changing the size of a scancode to accommodate 128 bits.  I've given
> this some thought and believe that leaving it at 32 bits is the best
> solution.  Changing it risks breaking all sorts of code with no tangible
> benefit since I've not found a RC that uses more than 32 bits.
> 
> The code now tracks frames with > 32 data bits, in order to cleanly
> detect the end of frame, but now reports an error and discards the data.
> 
> Hope this meets with your approval.  The following patch is against 3.0
> 

It seems Jarod didn't have time to test it. I took a long time here testing
every single IR I had, in order to see if I could have, by any chance, any
RC-6 IR lost... The net result is that I have dozens of NEC and RC-5 IR's, 
a few JVC, SONY and SANYO ones, but just one RC-6 IR. 

The one I have is RC6(0) 16 bits. So, I can only testify that this IR didn't
break by this patch.

Anyway, I won't hold this patch anymore. Let's put it at the devel tree and
see if people complain, or otherwise test it with different RC-6 lengths.

Regards,
Mauro
