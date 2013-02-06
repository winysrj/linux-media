Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1342 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3BFHdB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 02:33:01 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Arvydas Sidorenko <asido4@gmail.com>
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
Date: Wed, 6 Feb 2013 08:32:46 +0100
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl> <CA+6av4nj+Gvt2ivVm6YdaMtqF44n7JA3ZSK55CeefonFuaMjTQ@mail.gmail.com> <201302051941.31207.hverkuil@xs4all.nl>
In-Reply-To: <201302051941.31207.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302060832.46736.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue February 5 2013 19:41:31 Hans Verkuil wrote:
> > Buffer ioctls:
> > 		fail: v4l2-test-buffers.cpp(132): ret != -1
> 
> I need to look into this a bit more. I probably need to improve v4l2-compliance
> itself so I get better feedback as to which error is actually returned here.

I've improved v4l2-compliance a bit, but I've also pushed a fix (I hope) to
my git branch.

It's great if you can test this!

Regards,

	Hans

> 
> Thank you very much for testing!
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
