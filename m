Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:51528 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1JLIRL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Oct 2011 04:17:11 -0400
Date: Wed, 12 Oct 2011 11:14:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	"Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, devel@driverdev.osuosl.org,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] Staging: cx25821: off by on in cx25821_vidioc_s_input()
Message-ID: <20111012081412.GE18470@longonot.mountain>
References: <20111007132643.GB31424@elgon.mountain>
 <4E94AE2D.4050408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E94AE2D.4050408@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 11, 2011 at 05:59:25PM -0300, Mauro Carvalho Chehab wrote:
> > -	if (i > 2) {
> > +	if (i >= 2) {
> 
> It would be better to add a NUM_INPUT macro (or something like that, defined together
> with the INPUT macro) that would do an ARRAY_SIZE(cx25821_boards) and use it here, 
> instead of a "2" magic number.

You're right.  The hard coded 2 is not helpful...  Why not just an:

	if (i >= ARRAY_SIZE(cx25821_boards)) {...

I'll send a patch to do that.

regards,
dan carpenter
