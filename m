Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19920 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaFBVdU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jun 2014 17:33:20 -0400
Date: Tue, 3 Jun 2014 00:33:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ovidiu Toader <ovi@phas.ubc.ca>
Cc: devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] staging/media/rtl2832u_sdr: fix coding style problems by
 adding blank lines
Message-ID: <20140602200316.GB15585@mwanda>
References: <538B8651.6020801@phas.ubc.ca>
 <20140602102158.GX15585@mwanda>
 <538CD58B.4030603@phas.ubc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538CD58B.4030603@phas.ubc.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 02, 2014 at 12:50:35PM -0700, Ovidiu Toader wrote:
> On 06/02/14 03:21, Dan Carpenter wrote:
> > Send the patch inline, not as an attachment.
> > 
> > Read the first paragraph.
> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Documentation/email-clients.txt
> > 
> > The subject should say something about adding blank lines.
> Thanks for the feedback and sorry for the inconvenience.
> Take 2:
> 
> This minor patch fixes all WARNING:SPACING style warnings in rtl2832_sdr.c
> 
> The new version of the file pleases checkpatch.pl when run with "--ignore LONG_LINE".
> 

Better but not quite right.  You understand that the email *is* the
changelog?  So now it has our conversation saved in the changelog for
all time.

https://www.google.com/search?q=how+to+send+a+v2+patch

regards,
dan carpenter

