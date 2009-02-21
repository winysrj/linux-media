Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:49903 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZBUMu0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 07:50:26 -0500
Date: Sat, 21 Feb 2009 04:50:23 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: wk <handygewinnspiel@gmx.de>
cc: linux-media@vger.kernel.org
Subject: Re: RFCv1: v4l-dvb development models & old kernel support
In-Reply-To: <499FE9ED.7050405@gmx.de>
Message-ID: <Pine.LNX.4.58.0902210448310.24268@shell2.speakeasy.net>
References: <200902211200.45373.hverkuil@xs4all.nl> <499FE9ED.7050405@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 21 Feb 2009, wk wrote:
> Hans Verkuil wrote:
> > Comments?
> >
> > 	Hans
> >
>
> As only beeing reader of this list.., why not simply reduce the work load by
>
> - reducing the number of supported kernel versions to five major
> versions? Currently 2.6.28 would mean down to 2.6.23,
> this would be enough cover all nearly up-to-date distributions. Users
> from embedded devices are anyway mostly not able to compile or use newer
> drivers.

Supporting versions between 2.6.23 and 2.6.28 isn't much more work than
supporting just 2.6.23 and 2.6.28.  There aren't many compat issues that
appeared in say 2.6.25 and disappeared in 2.6.27 that could be ignored.
