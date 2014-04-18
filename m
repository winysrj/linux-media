Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:54888 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaDRO2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Apr 2014 10:28:37 -0400
Received: by mail-qc0-f170.google.com with SMTP id x13so1765167qcv.29
        for <linux-media@vger.kernel.org>; Fri, 18 Apr 2014 07:28:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53513297.5040409@xs4all.nl>
References: <1394454049-12879-1-git-send-email-hverkuil@xs4all.nl>
	<1394454049-12879-4-git-send-email-hverkuil@xs4all.nl>
	<20140416192343.30a5a8fc@samsung.com>
	<534F0553.2000808@xs4all.nl>
	<20140416231730.6252aae7@samsung.com>
	<534FA3BF.2010308@xs4all.nl>
	<20140417101310.0111d236@samsung.com>
	<5351106E.4080700@xs4all.nl>
	<CAGoCfix1j8kLQQe3yMDj+bqi=Pyj_K+en31a-h32+HMzVU1arQ@mail.gmail.com>
	<53513297.5040409@xs4all.nl>
Date: Fri, 18 Apr 2014 10:28:35 -0400
Message-ID: <CAGoCfix3X6KQycpvt=7nxGbUgYEYzZPrxpKheGzRsSaZ56=VOw@mail.gmail.com>
Subject: Re: [REVIEW PATCH 3/3] saa7134: convert to vb2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> This makes no sense. The vivi driver uses vb2-vmalloc as well, and that works
> perfectly fine in userptr mode. Applying this patch breaks vivi userptr mode,
> so this is a NACK for this patch.

Don't misunderstand, I acknowledge the very real possibility that I
don't fully understand the underlying problem.  And to be clear I
wasn't intending to send the patch to this mailing list expecting it
to be merged.  That said, I reproduced it on the ti81xx platform on
both em28xx and uvcvideo, so I was comfortable it wasn't an issue with
my em28xx VB2 conversion.

> I wonder though if this is related to this thread:
>
> http://www.spinics.net/lists/linux-media/msg75815.html
>
> I suspect that in your case the vb2_get_contig_userptr() function is called
> which as far as I can tell is the wrong function to call for the vmalloc case
> since there is absolutely no requirement that user pointers should be
> physically contiguous for vmalloc drivers.

Entirely possible.  I hadn't followed that thread previously but will
take a look.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
