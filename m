Return-path: <mchehab@pedra>
Received: from claranet-outbound-smtp04.uk.clara.net ([195.8.89.37]:57343 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778Ab1EDJcd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 05:32:33 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [PATCH] cx18: Clean up mmap() support for raw YUV
Date: Wed, 4 May 2011 10:32:23 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>
References: <4DBFDF71.5090705@redhat.com> <1304423860-12785-1-git-send-email-simon.farnsworth@onelan.co.uk> <b418b252-4152-4666-9c83-85e91613b493@email.android.com>
In-Reply-To: <b418b252-4152-4666-9c83-85e91613b493@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105041032.24644.simon.farnsworth@onelan.co.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 3 May 2011, Andy Walls <awalls@md.metrocast.net> wrote:
> Simon,
> 
> If these two changes are going in, please also bump the driver version to
> 1.5.0 in cx18-version.c.  These changes are significant enough
> perturbation.
> 
> End users are going to look to driver version 1.4.1 as the first version
> for proper analog tuner support of the HVR1600 model 74351.
> 
> Mauro,
> 
> Is cx18 v1.4.1 with HVR1600 model 74351 analog tuner support, without these
> mmap() changes going to be visible in kernel version .39 ?
> 

Mauro,

If you're going to accept these two patches, would you mind bumping the 
version in cx18-version.c for me as you apply them, or would you prefer me to 
provide either an incremental patch or a new patch with the bump added?
-- 
Simon Farnsworth
Software Engineer
ONELAN Limited
http://www.onelan.com/
