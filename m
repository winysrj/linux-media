Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43745 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750892AbZIMPzG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 11:55:06 -0400
Message-ID: <4AAD15A3.5080001@gmx.de>
Date: Sun, 13 Sep 2009 17:54:11 +0200
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: Media controller: sysfs vs ioctl
References: <200909120021.48353.hverkuil@xs4all.nl>
In-Reply-To: <200909120021.48353.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil schrieb:
> Hi all,
>
> I've started this as a new thread to prevent polluting the discussions of the
> media controller as a concept.
>
> First of all, I have no doubt that everything that you can do with an ioctl,
> you can also do with sysfs and vice versa. That's not the problem here.
>
> The problem is deciding which approach is the best.
>
>   

Is it really a good idea to create a dependency to some virtual file 
system which may go away in future?
 From time to time some of those seem to go away, for example devfs.

Is it really unavoidable to have something in sysfs, something which is 
really not possible with ioctls?
And do you really want to depend on sysfs developers?

--Winfried


