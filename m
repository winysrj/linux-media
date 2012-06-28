Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2736 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab2F1GtT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:49:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [RFCv3 PATCH 00/33] Core and vb2 enhancements
Date: Thu, 28 Jun 2012 08:47:54 +0200
Message-Id: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the third version of this patch series.

The first version is here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg47558.html

Changes since RFCv2:

- Rebased to staging/for_v3.6.

- Incorporated Laurent's review comments in patch 22: vb2-core: refactor reqbufs/create_bufs.

Changes since RFCv1:

- Incorporated all review comments from Hans de Goede and Laurent Pinchart (Thanks!)
  except for splitting off the vb2 helper functions into a separate source. I decided
  to keep it together with the vb2-core code.

- Improved commit messages, added more comments to the code.

- The owner filehandle and the queue lock are both moved to struct vb2_queue since
  these are a property of the queue.

- The debug function has a new 'write_only' boolean: some debug functions can only
  print a subset of the arguments if it is called by an _IOW ioctl. The previous
  patch series split this up into two functions. Handling the debug function for
  a write-only ioctl is annoying at the moment: you have to print the arguments
  before calling the ioctl since the ioctl can overwrite arguments. I am considering
  changing the op argument to const for such ioctls and see if any driver is
  actually messing around with the contents of such structs. If we can guarantee
  that drivers do not change the argument struct, then we can simplify the debug
  code.

- All debugging is now KERN_DEBUG instead of KERN_INFO.

I still have one outstanding question: should anyone be able to call mmap() or
only the owner of the vb2 queue? Right now anyone can call mmap().

Comments are welcome, but if I don't see any in the next 2-3 days, then I'll make
a pull request for this on Sunday.

Regards,

        Hans

