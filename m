Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38998 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753801AbcGHUya (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2016 16:54:30 -0400
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: doc-rst: too much space around ``foo`` text
Message-ID: <cc77239c-7e8f-7c03-bcdd-e19d87998aee@xs4all.nl>
Date: Fri, 8 Jul 2016 22:52:54 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

First of all a big 'Thank you!' for working on this, very much appreciated.

And I also am very grateful that you could convert the CEC docs so quickly for me.

That said, can you take a look at this:

https://mchehab.fedorapeople.org/media_API_book/linux_tv/media/v4l/vidioc-enum-fmt.html

As you can see, every text written as ``foo`` in the rst file has a bit too much space
around it. It's especially clear in the description of the 'type' field: the commas
after each V4L2_BUF_TYPE_ constant should be right after the last character, and now
it looks as if there is a space in front.

It's jarring when you read it, but it is probably easy to fix for someone who knows
this stuff.

Thanks!

	Hans
