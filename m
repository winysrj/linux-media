Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60120 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2GTJzn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 05:55:43 -0400
Date: Fri, 20 Jul 2012 11:55:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFCv3 PATCH 00/33] Core and vb2 enhancements
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1207201149010.27906@axis700.grange>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Thu, 28 Jun 2012, Hans Verkuil wrote:

> Hi all,
> 
> This is the third version of this patch series.
> 
> The first version is here:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg47558.html

Nice to see an owner concept added to the vb2. In soc-camera we're also 
using a concept of a "streamer" user. This is the user, that first calls 
one of data-flow related ioctl()s, like s_fmt(), streamon(), streamoff() 
and all buffer queue-related operations. I realise that this your 
patch-set only deals with the buffer queue, but in principle, do you think 
it would make sense to use such a concept globally? We probably don't want 
to let other processes mess with any of the above calls as long as one 
process is actively managing the streaming.

Thanks
Guennadi

> Changes since RFCv2:
> 
> - Rebased to staging/for_v3.6.
> 
> - Incorporated Laurent's review comments in patch 22: vb2-core: refactor reqbufs/create_bufs.
> 
> Changes since RFCv1:
> 
> - Incorporated all review comments from Hans de Goede and Laurent Pinchart (Thanks!)
>   except for splitting off the vb2 helper functions into a separate source. I decided
>   to keep it together with the vb2-core code.
> 
> - Improved commit messages, added more comments to the code.
> 
> - The owner filehandle and the queue lock are both moved to struct vb2_queue since
>   these are a property of the queue.
> 
> - The debug function has a new 'write_only' boolean: some debug functions can only
>   print a subset of the arguments if it is called by an _IOW ioctl. The previous
>   patch series split this up into two functions. Handling the debug function for
>   a write-only ioctl is annoying at the moment: you have to print the arguments
>   before calling the ioctl since the ioctl can overwrite arguments. I am considering
>   changing the op argument to const for such ioctls and see if any driver is
>   actually messing around with the contents of such structs. If we can guarantee
>   that drivers do not change the argument struct, then we can simplify the debug
>   code.
> 
> - All debugging is now KERN_DEBUG instead of KERN_INFO.
> 
> I still have one outstanding question: should anyone be able to call mmap() or
> only the owner of the vb2 queue? Right now anyone can call mmap().
> 
> Comments are welcome, but if I don't see any in the next 2-3 days, then I'll make
> a pull request for this on Sunday.
> 
> Regards,
> 
>         Hans
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
