Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4113 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab1ECQYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 12:24:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Subject: Re: [PATCH] cx18: Clean up mmap() support for raw YUV
Date: Tue, 3 May 2011 18:24:21 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>
References: <4DBFDF71.5090705@redhat.com> <1304423860-12785-1-git-send-email-simon.farnsworth@onelan.co.uk>
In-Reply-To: <1304423860-12785-1-git-send-email-simon.farnsworth@onelan.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031824.21586.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Simon,

On Tuesday, May 03, 2011 13:57:40 Simon Farnsworth wrote:
> The initial version of this patch (commit
> d5976931639176bb6777755d96b9f8d959f79e9e) had some issues:
> 
>  * It didn't correctly calculate the size of the YUV buffer for 4:2:2,
>    resulting in capture sometimes being offset by 1/3rd of a picture.
> 
>  * There were a lot of variables duplicating information the driver
>    already knew, which have been removed.
> 
>  * There was an in-kernel format conversion - libv4l can do this one,
>    and is the right place to do format conversions anyway.
> 
>  * Some magic numbers weren't properly explained.
> 
> Fix all these issues, leaving just the move from videobuf to videobuf2
> to do.
> 
> Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>

I just wanted to thank you for your work. I hope I never gave the impression
that the whole discussion had anything to do with you. You were just unlucky
enough to trigger a 'to merge or not to merge' and a 'to vb2 or not to vb2'
discussion through no fault of your own.

Just thought I should mention that. I would definitely like to see cx18
working with tvtime and it is valuable work you are doing.

Regards,

	Hans
