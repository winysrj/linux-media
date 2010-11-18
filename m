Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4601 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758374Ab0KROq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 09:46:57 -0500
Message-ID: <e29b49a76577b6eb777d1aa0dba7bd95.squirrel@webmail.xs4all.nl>
In-Reply-To: <AANLkTikH0+hhWwTUAkYS1Z_WpwQvyZrw1sCt1vkjghN3@mail.gmail.com>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
    <659fdfa774acb1e359cb0c3c3b48b5e26bb3fcc9.1289944160.git.hverkuil@xs4all.nl>
    <AANLkTikH0+hhWwTUAkYS1Z_WpwQvyZrw1sCt1vkjghN3@mail.gmail.com>
Date: Thu, 18 Nov 2010 15:46:52 +0100
Subject: Re: [RFCv2 PATCH 07/15] dsbr100: convert to unlocked_ioctl.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "David Ellingsworth" <david@identd.dyndns.org>
Cc: linux-media@vger.kernel.org, "Arnd Bergmann" <arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> This driver has quite a few locking issues that would only be made
> worse by your patch. A much better patch for this can be found here:
>
> http://desource.dyndns.org/~atog/gitweb?p=linux-media.git;a=commitdiff;h=9c5d8ebb602e9af46902c5f3d4d4cc80227d3f7c

Much too big for 2.6.37. I'll just drop this patch from my patch series.
Instead it will rely on the new lock in v4l2_device (BKL replacement) that
serializes all ioctls. For 2.6.38 we can convert it to core assisted
locking which is much easier.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

