Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17470 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbaFBKWb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jun 2014 06:22:31 -0400
Date: Mon, 2 Jun 2014 13:21:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ovidiu Toader <ovi@phas.ubc.ca>
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] staging/media/rtl2832u_sdr: fix coding style problems
Message-ID: <20140602102158.GX15585@mwanda>
References: <538B8651.6020801@phas.ubc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538B8651.6020801@phas.ubc.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 01, 2014 at 01:00:17PM -0700, Ovidiu Toader wrote:
> motivation: eudyptula challenge
> 
> This minor patch fixes all WARNING:SPACING style warnings in rtl2832_sdr.c
> 
> The new version of the file pleases checkpatch.pl when run with
> "--ignore LONG_LINE".
> 

> Signed-off-by: Ovidiu Toader <ovi@phas.ubc.ca>

Send the patch inline, not as an attachment.

Read the first paragraph.
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Documentation/email-clients.txt

The subject should say something about adding blank lines.

regards,
dan carpenter

