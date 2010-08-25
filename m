Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39734 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab0HYUBU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 16:01:20 -0400
Received: by gyd8 with SMTP id 8so347694gyd.19
        for <linux-media@vger.kernel.org>; Wed, 25 Aug 2010 13:01:19 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Aug 2010 17:01:06 -0300
Message-ID: <AANLkTimzPXc=xGXL8ZS1tOAfa1W=qD-DPZeqtxkmiC5s@mail.gmail.com>
Subject: [ANOUNCE] removal of backport for versions older than 2.6.26
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello folks,

I would like to share that I will just keep the maintain of
compatibility of hg  from 2.6.26 until lastest upstream kernel.
I am writing this because we have errors from IR to lowest kernels
from a lot of time and just
1 person pinged me about it which also claims that he is moving to new
versions. So, if you are looking for a backport until 2.6.26 I can
help.
Otherwise, I will work on keeping hg synced with git, backporting and
continuing helping on drivers at upstream.

I have selected 2.6.26 because between all free distros available out
there the lowest kernel used is 2.6.26.

Finally, the next cut for backport version can happen probably based
on 2.6.32 since most of free distros will be using
kernel >= 2.6.32.

If someone, would like to maintain a backport tree to < 2.6.26 fell
free to contact me/send patches or contact Mauro.
This increased can keep occurring (not frequently) but of course
according with kernel evolution.

Hans, could you please adjust your emails scripts?

Thanks
Douglas
