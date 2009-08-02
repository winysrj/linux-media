Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4848 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbZHBJ3Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Aug 2009 05:29:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org,
	Michael Krufky via Mercurial <mkrufky@kernellabs.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] sms1xxx: fix broken Hauppauge devices
Date: Sun, 2 Aug 2009 11:29:10 +0200
References: <E1MX6O1-0008QJ-N4@mail.linuxtv.org>
In-Reply-To: <E1MX6O1-0008QJ-N4@mail.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908021129.10292.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 01 August 2009 06:40:01 Patch from Michael Krufky wrote:
> The patch number 12374 was added via Michael Krufky <mkrufky@kernellabs.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
> 
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> ------
> 
> From: Michael Krufky  <mkrufky@kernellabs.com>
> sms1xxx: fix broken Hauppauge devices
> 
> 
> The current GPIO configuration breaks all Hauppauge devices.
> 
> The code being removed affects Hauppauge devices only,
> and is the cause of the breakage.
> 
> Priority: high
> 
> Signed-off-by: Michael Krufky <mkrufky@kernellabs.com>

Hi Mike,

The daily build now has this warning:

/marune/build/v4l-dvb-master/v4l/sms-cards.c: In function 'sms_board_event':
/marune/build/v4l-dvb-master/v4l/sms-cards.c:120: warning: unused variable 'board'

And 'board' is indeed no longer used. Can you make a patch fixing this?
I suspect that it can just be removed.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
