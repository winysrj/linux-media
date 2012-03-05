Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51395 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab2CEKAN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 05:00:13 -0500
Date: Mon, 5 Mar 2012 04:00:10 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Skippy le Grand Gourou <lecotegougdelaforce@free.fr>,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [bug?] ov519 fails to handle Hercules Deluxe webcam
Message-ID: <20120305100010.GB15431@burratino>
References: <20120304223239.22117.54556.reportbug@deepthought>
 <20120305003801.GB27427@burratino>
 <20120305102101.652b46e7@tele>
 <20120305093430.GA14386@burratino>
 <20120305105541.2fef6b0d@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305105541.2fef6b0d@tele>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> Jonathan Nieder <jrnieder@gmail.com> wrote:

>>> To be sure, try the gspca test version from my web site.
>>
>> Skippy, assuming that works (and I expect it would), could you try the
>> attached patch against 2.6.32.y?  It works like this:
[...]
>>  1. Get the kernel, if you don't already have it:
>> 	git clone \
>> 	 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>	[snip]
>
> This asks for a lot of job.

Do you mean bandwidth?

>                             With the gspca tarball (423Kb), you just
> need the linux-headers. And it permits further debugging...

I expect that this is fixed in 3.x.y already, so I wanted to confirm
that that is the only fix needed to get it fixed in 2.6.32.y-longterm
as well.

Kind regards,
Jonathan
