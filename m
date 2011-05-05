Return-path: <mchehab@pedra>
Received: from claranet-outbound-smtp06.uk.clara.net ([195.8.89.39]:47627 "EHLO
	claranet-outbound-smtp06.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753931Ab1EEMpI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 08:45:08 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] cx18: Clean up mmap() support for raw YUV
Date: Thu, 5 May 2011 13:44:59 +0100
Cc: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>
References: <4DBFDF71.5090705@redhat.com> <201105041032.24644.simon.farnsworth@onelan.co.uk> <4DC28CEE.1080304@redhat.com>
In-Reply-To: <4DC28CEE.1080304@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105051344.59759.simon.farnsworth@onelan.co.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 5 May 2011, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> There are a few new warnings with your code:
> 
> drivers/media/video/cx18/cx18-mailbox.c: In function
> ‘cx18_mdl_send_to_videobuf’: drivers/media/video/cx18/cx18-mailbox.c:206:
> warning: passing argument 1 of ‘ktime_get_ts’ from incompatible pointer
> type include/linux/ktime.h:331: note: expected ‘struct timespec *’ but
> argument is of type ‘struct timeval *’
> drivers/media/video/cx18/cx18-mailbox.c:170: warning: unused variable ‘i’
> drivers/media/video/cx18/cx18-mailbox.c:167: warning: unused variable ‘u’
> 
> Could you please fix them?
> 
I'm not doing well on the driving git front today, and I've managed to send 
the fix patch with a wrong "In-reply-to"; it's message ID is 
<1304599356-21951-1-git-send-email-simon.farnsworth@onelan.co.uk>, and it's 
elsewhere in this thread (in reply to <4DC138F7.5050400@infradead.org>)
-- 
Simon Farnsworth
Software Engineer
ONELAN Limited
http://www.onelan.com/
