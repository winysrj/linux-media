Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2957 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0DFFlW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 01:41:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Serialization flag example
Date: Tue, 6 Apr 2010 00:58:54 +0200
Cc: David Ellingsworth <david@identd.dyndns.org>,
	hermann-pitton@arcor.de, awalls@md.metrocast.net,
	mchehab@redhat.com, dheitmueller@kernellabs.com,
	abraham.manu@gmail.com, linux-media@vger.kernel.org
References: <32832848.1270295705043.JavaMail.ngmail@webmail10.arcor-online.net> <x2r30353c3d1004032014qc2b31bd5uab4da9a0d364e8ff@mail.gmail.com> <201004060046.12997.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201004060046.12997.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004060058.54050.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 06 April 2010 00:46:11 Laurent Pinchart wrote:
> On Sunday 04 April 2010 05:14:17 David Ellingsworth wrote:
> > After looking at the proposed solution, I personally find the
> > suggestion for a serialization flag to be quite ridiculous. As others
> > have mentioned, the mere presence of the flag means that driver
> > writers will gloss over any concurrency issues that might exist in
> > their driver on the mere assumption that specifying the serialization
> > flag will handle it all for them.
> 
> I happen to agree with this. Proper locking is difficult, but that's not a 
> reason to introduce such a workaround. I'd much rather see proper 
> documentation for driver developers on how to implement locking properly.

I've taken a different approach in another tree:

http://linuxtv.org/hg/~hverkuil/v4l-dvb-ser2/

It adds two callbacks to ioctl_ops: pre_hook and post_hook. You can use these
to do things like prio checking and taking your own mutex to serialize the
ioctl call.

This might be a good compromise between convenience and not hiding anything.

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
