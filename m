Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4604 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab0CVAR7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Mar 2010 20:17:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: Phase 1: Proposal to convert V4L1 drivers
Date: Mon, 22 Mar 2010 01:17:34 +0100
Cc: Hans de Goede <hdegoede@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	David Ellingsworth <david@identd.dyndns.org>
References: <201003200958.49649.hverkuil@xs4all.nl> <201003212345.04736.hverkuil@xs4all.nl>
In-Reply-To: <201003212345.04736.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003220117.34790.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 21 March 2010 23:45:04 Hans Verkuil wrote:
> On Saturday 20 March 2010 09:58:49 Hans Verkuil wrote:
> > These drivers have no hardware to test with: bw-qcam, c-qcam, arv, w9966.
> > However, all four should be easy to convert to v4l2, even without hardware.
> > Volunteers?
> 
> I've converted these four drivers to V4L2.

I've also removed the V4L1 support from cpia2 and pwc and removed some last
V4L1 code remnants from meye and zoran. It's all in the same tree.

Hans, could you test the pwc driver for me?

	Hans

> 
> See my tree:
> 
> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-v4l1
> 
> It's obviously untested and it needs a closer review, but the bulk of the work
> is done.
> 
> Regards,
> 
> 	Hans
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
