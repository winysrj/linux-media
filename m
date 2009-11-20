Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3643 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZKTKNE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 05:13:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: High prio fixes for 2.6.32: urgent!
Date: Fri, 20 Nov 2009 11:13:01 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911201113.01923.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Linus just released 2.6.32-rc8 and expects that to be the last rcX. However, 
I have still four urgent fixes pending:

- radio-gemtek-pci fix
- davinci patch (duplicate config pointer)
- s2250 mutex patch
- add the missing s2250-loader.h

The first is already in v4l-dvb, but has not yet been pushed upstream, the 
others are still pending.

The last concerns a file that is in our v4l-dvb repository, but is *not* in 
the 2.6.32-rc8 tree. So that needs to be pushed upstream.

The other two patches are in two different pull requests from me, but I'll 
make another tree later today with just these two high-prio patches to make 
it easy for you to merge just those.

I hope you can find some time to get these pushed to 2.6.32.

Regards,

	Hans

PS: I found another compiler error for a davinci-emac.c file in 2.6.32. I've 
notified the davinci mailinglist about this as well.

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
