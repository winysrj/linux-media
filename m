Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:45798 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2GSNmX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 09:42:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [PATCH] cx25821: Remove bad strcpy to read-only char*
Date: Thu, 19 Jul 2012 15:41:56 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1342633271-5731-1-git-send-email-elezegarcia@gmail.com> <201207191317.56907.hverkuil@xs4all.nl> <CALF0-+Vsp=OkgyMEZ0Uyca03GZzH5hU4UtZ_-kfDkrKGQx=8CA@mail.gmail.com>
In-Reply-To: <CALF0-+Vsp=OkgyMEZ0Uyca03GZzH5hU4UtZ_-kfDkrKGQx=8CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207191541.56237.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 19 July 2012 15:32:21 Ezequiel Garcia wrote:
> On Thu, Jul 19, 2012 at 8:17 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Ezequiel,
> >
> > Can you post this patch again, but this time to Linus Torvalds as well?
> >
> > See e.g. http://www.spinics.net/lists/linux-media/msg50407.html how I did that.
> >
> > It would be good to have this fixed in 3.5. I'm afraid that by the time
> > Mauro is back 3.5 will be released and this is a nasty bug.
> >
> 
> Okey, I'll do that. Shouldn't this go to stable also?

Definitely, but it have to be upstreamed first before it can go to stable.

Regards,

	Hans
