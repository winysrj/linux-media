Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1278 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0CUWp0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Mar 2010 18:45:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: Phase 1: Proposal to convert V4L1 drivers
Date: Sun, 21 Mar 2010 23:45:04 +0100
Cc: Hans de Goede <hdegoede@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	David Ellingsworth <david@identd.dyndns.org>
References: <201003200958.49649.hverkuil@xs4all.nl>
In-Reply-To: <201003200958.49649.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003212345.04736.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 20 March 2010 09:58:49 Hans Verkuil wrote:
> These drivers have no hardware to test with: bw-qcam, c-qcam, arv, w9966.
> However, all four should be easy to convert to v4l2, even without hardware.
> Volunteers?

I've converted these four drivers to V4L2.

See my tree:

http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-v4l1

It's obviously untested and it needs a closer review, but the bulk of the work
is done.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
