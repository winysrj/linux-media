Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44626 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3EVJ2y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 May 2013 05:28:54 -0400
Date: Wed, 22 May 2013 10:28:49 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: stable@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH stable < v3.7] media mantis: fix silly crash case
Message-ID: <20130522092849.GA3161@hercules>
References: <87ehd0lbwo.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ehd0lbwo.fsf@nemi.mork.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 21, 2013 at 03:07:03PM +0200, Bjørn Mork wrote:
> Hello,
> 
> Please apply mainline commit e1d45ae to any maintained stable kernel
> prior to v3.7.  I just hit this bug on a Debian 3.2.41-2+deb7u2 kernel:

Thanks, I'll queue it for the 3.5 kernel.

Cheers,
--
Luis
