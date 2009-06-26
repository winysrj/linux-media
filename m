Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2752 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZFZRur (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 13:50:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PARTIALLY SOLVED] Can't use my Pinnacle PCTV HD Pro stick - what  am I doing wrong?
Date: Fri, 26 Jun 2009 19:50:26 +0200
Cc: George Adams <g_adams27@hotmail.com>, linux-media@vger.kernel.org,
	video4linux-list@redhat.com,
	Michael Krufky <mkrufky@kernellabs.com>
References: <36839.62.70.2.252.1245937439.squirrel@webmail.xs4all.nl> <829197380906251125t56fe49ccqee97eab659be9974@mail.gmail.com>
In-Reply-To: <829197380906251125t56fe49ccqee97eab659be9974@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906261950.27065.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 25 June 2009 20:25:31 Devin Heitmueller wrote:
> Hans,
> 
> I just spoke with mkrufky, and he confirmed the issue does occur with
> the HVR-950.  However, the em28xx driver does not do a printk() when
> the subdev registration fails (I will submit a patch to fix that).
> 
> Please let me know if you have any further question.
> 
> Thanks for your assistance,
> 
> Devin
> 

Fixed in my http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-misc tree.

A pull request for this has already been posted, so it should be merged soon
I hope.

It was a trivial change: originally the new i2c API would be used for kernels
2.6.22 and up, until it was discovered that there was a serious bug in the i2c
core that wasn't fixed until 2.6.26. So I changed it to kernel 2.6.26.

Unfortunately, the em28xx driver was still using 2.6.22 as the cut-off point,
preventing i2c drivers from being initialized. So em28xx was broken for
kernels 2.6.22-2.6.25.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
