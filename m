Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3415 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab0F0JK1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 05:10:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Correct way to do s_ctrl ioctl taking into account subdev framework?
Date: Sun, 27 Jun 2010 11:12:33 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <AANLkTim9TfITmvy7nEuSVJnCxRwCkpbmgRc2FIIIWHGF@mail.gmail.com> <201006262051.52754.hverkuil@xs4all.nl> <AANLkTikPKv6iCQmV14JSiR61AUMswsOoTB7i-eSHAwH4@mail.gmail.com>
In-Reply-To: <AANLkTikPKv6iCQmV14JSiR61AUMswsOoTB7i-eSHAwH4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006271112.33893.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 26 June 2010 21:04:51 Devin Heitmueller wrote:
> On Sat, Jun 26, 2010 at 2:51 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > There really is no good way at the moment to handle cases like this, or at
> > least not without a lot of work.
> 
> Ok, it's good to know I'm not missing something obvious.
> 
> > The plan is to have the framework merged in time for 2.6.36. My last patch
> > series for the framework already converts a bunch of subdevs to use it. Your
> > best bet is to take the patch series and convert any remaining subdevs used
> > by em28xx and em28xx itself. I'd be happy to add those patches to my patch
> > series, so that when I get the go ahead the em28xx driver will be fixed
> > automatically.
> >
> > It would be useful for me anyway to have someone else use it: it's a good
> > check whether my documentation is complete.
> 
> Sure, could you please point me to the tree in question and I'll take a look?

http://git.linuxtv.org/hverkuil/v4l-dvb.git, branch ctrlfw5.

This tree is based on the latest v4l-dvb master.

Laurent, when you start working on moving UVC over to the control framework,
please use this new branch. The old patch series no longer applies cleanly
due to changes in the master.

Regards,

         Hans

> 
> Given I've got applications failing, for the short term I will likely
> just submit a patch which makes the s_ctrl always return zero
> regardless of the subdev response, instead of returning 1.
> 
> Thanks,
> 
> Devin
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
