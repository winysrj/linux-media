Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-2.mail.uk.tiscali.com ([212.74.114.38]:5061
	"EHLO mk-outboundfilter-2.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755984AbZCGVM6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2009 16:12:58 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
Date: Sat, 7 Mar 2009 21:12:52 +0000
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
References: <200903022218.24259.hverkuil@xs4all.nl> <Pine.LNX.4.64.0903052315530.4980@axis700.grange> <Pine.LNX.4.58.0903061532210.24268@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0903061532210.24268@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903072112.53088.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 07 March 2009, Trent Piepho wrote:
> Audio was out of tree.  If they had a better system, like v4l-dvb does,
> they might well still be out of tree.  And aren't there some wireless
> packages that are out of tree?

Wireless development is done in tree and then copied to a compat tree that 
contains just the wireless drivers, stack and compatibility stubs. A year or 
two back there were some drivers developed out of tree so they could be 
tested more easily but it became too much of an overhead to work that way.

Adam
