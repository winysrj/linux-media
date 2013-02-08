Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1851 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946100Ab3BHJVA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2013 04:21:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Arvydas Sidorenko <asido4@gmail.com>
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
Date: Fri, 8 Feb 2013 10:20:49 +0100
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl> <201302060832.46736.hverkuil@xs4all.nl> <CA+6av4nWfjBh4jzWRoz9Hvj=QhL5V1CzDb=kKRiANtGCp0Ff1Q@mail.gmail.com>
In-Reply-To: <CA+6av4nWfjBh4jzWRoz9Hvj=QhL5V1CzDb=kKRiANtGCp0Ff1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302081020.49754.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu February 7 2013 23:39:58 Arvydas Sidorenko wrote:
> On Wed, Feb 6, 2013 at 8:32 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > I've improved v4l2-compliance a bit, but I've also pushed a fix (I hope) to
> > my git branch.
> >
> > It's great if you can test this!
> >

Thanks for the testing! I've pushed some more improvements to my git branch.
Hopefully the compliance tests are now running OK. Please check the dmesg
output as well.

In addition I've added an 'upside down' message to the kernel log that tells
me whether the driver is aware that your sensor is upside down or not.

Which laptop do you have? Asus G1?

Regards,

	Hans
