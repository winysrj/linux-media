Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2481 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbZGWVyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 17:54:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: eduardo.valentin@nokia.com
Subject: New tree with final (?) string control implementation
Date: Thu, 23 Jul 2009 23:54:46 +0200
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907232354.46673.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eduardo,

I've prepared a new tree:

http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-strctrl

This contains the full string control implementation, including updates to 
the v4l2-spec, based on the RFC that I posted on Monday.

Can you prepare your si4713 patches against this tree and verify that 
everything is working well?

If it is, then I can make a pull request for this tree and soon after that 
you should be able to merge your si4713 driver as well. If I'm not mistaken 
the string controls API is the only missing bit that prevents your driver 
from being merged.

Thanks,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
