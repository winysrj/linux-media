Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4056 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1EWPdH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 11:33:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [git:v4l-utils/master] Add an install target to libv4l2util
Date: Mon, 23 May 2011 17:33:02 +0200
Cc: linux-media@vger.kernel.org
References: <E1QORwH-0003gY-GA@www.linuxtv.org> <4DDA73A5.1080803@redhat.com>
In-Reply-To: <4DDA73A5.1080803@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105231733.02807.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, May 23, 2011 16:48:05 Hans de Goede wrote:
> Hi,
> 
> On 05/23/2011 12:00 PM, Mauro Carvalho Chehab wrote:
> > This is an automatic generated email to let you know that the following patch were queued at the
> > http://git.linuxtv.org/v4l-utils.git tree:
> >
> > Subject: Add an install target to libv4l2util
> > Author:  Mauro Carvalho Chehab<mchehab@redhat.com>
> > Date:    Mon May 23 07:00:00 2011 -0300
> >
> > Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
> >
> 
> Erm,
> 
> This is a static lib, installing static libs globally is considered
> bad practice. Either we need to make this a properly versioned .so
> and all the API+ABI promises which some with that, or we should just
> keep it as a private utility function lib, which gets linked into
> a few utils, but not installed system wide.

To be honest, I don't think this library should be installed at all. It is
undocumented and frankly, I never liked it. As soon as we install this, then
we are stuck with respect to the API/ABI, and if we do that, then it has to
be reviewed first.

> I think this may have something to do with the new get_media_devices

That code looks awfully like a poor-mans media controller when it comes to
discovering media nodes. No really the way I want to go.

> code, but the commit message is rather undescriptive...

Just for the record: I think a libv4l2util library is a nice idea. But if we
do that, then we need something better than this.

Regards,

	Hans

> 
> Regards,
> 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
