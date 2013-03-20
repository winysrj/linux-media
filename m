Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3120 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab3CTTUS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 15:20:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [REVIEW PATCH 11/15] au0828: fix disconnect sequence.
Date: Wed, 20 Mar 2013 20:20:09 +0100
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@kernellabs.com>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com> <6d4b25c7bfc65cfff4937133bed3e60828c20174.1363035203.git.hans.verkuil@cisco.com> <CAGoCfiyYRwjb-+i84MrxBXaxJT=Fy7ucj02N1Lvy8n4LC0FBKw@mail.gmail.com>
In-Reply-To: <CAGoCfiyYRwjb-+i84MrxBXaxJT=Fy7ucj02N1Lvy8n4LC0FBKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303202020.09575.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue March 12 2013 03:05:50 Devin Heitmueller wrote:
> On Mon, Mar 11, 2013 at 5:00 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> >
> > The driver crashed when the device was disconnected while an application
> > still had a device node open. Fixed by using the release() callback of struct
> > v4l2_device.
> 
> This is all obviously good stuff.  I actually spent a couple of days
> working through various disconnect scenarios, but hadn't had a chance
> to do a PULL request.  I will review my tree and see if you missed any
> other cases that I took care of.

I want to make a pull request for this. Can I have your Acked-by or do you
want to look at this some more?

Regards,

	Hans
