Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2965 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaJIWDL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Oct 2014 18:03:11 -0400
Message-ID: <54370615.9030107@xs4all.nl>
Date: Fri, 10 Oct 2014 00:03:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Subject: Re: v4l2-compliance revision vs Kernel version
References: <20141009214536.GF973@ti.com>
In-Reply-To: <20141009214536.GF973@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benoit,

On 10/09/2014 11:45 PM, Benoit Parrot wrote:
> Hi,
>
> Can someone point me toward a mapping of v4l2-compliance release vs kernel version?

There isn't any. It's trial and error, I'm afraid. The primary use-case of v4l2-compliance is
testing drivers in the bleeding-edge media_tree.git repo.

>
> I am currently working with a 3.14 kernel and would like to find the matching v4l2-compliance version.
> I am  using git://linuxtv.org/v4l-utils.git commit id:
> 3719cef libdvbv5: reimplement the logic that gets a full section
>
> But on 3.14 running that version against vivi.ko shows a few failures and a bunch of "Not Supported".

"Not Supported" is not an error. It just means that the driver doesn't support that ioctl, so
no compliance tests for that ioctl are done.

Regards,

	Hans
