Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:29883 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2HGM7v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2012 08:59:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 00/24] Various HVR-950q and xc5000 fixes
Date: Tue, 7 Aug 2012 14:59:37 +0200
Cc: linux-media@vger.kernel.org
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com> <201208070826.20796.hverkuil@xs4all.nl> <CAGoCfizCV4Qp+a-Ay298CxZPcRmQ+BZ+0MjizHHFheo2qx1-mg@mail.gmail.com>
In-Reply-To: <CAGoCfizCV4Qp+a-Ay298CxZPcRmQ+BZ+0MjizHHFheo2qx1-mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208071459.37668.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 7 August 2012 14:48:41 Devin Heitmueller wrote:
> On Tue, Aug 7, 2012 at 2:26 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Since you're working on the au0828 would it perhaps be possible to have that
> > driver use unlocked_ioctl instead of ioctl? It would be really nice if we
> > can get rid of the ioctl v4l2_operation at some point in the future.
> 
> Hi Hans,
> 
> I'm pretty sure that actually got done implicitly by patch #8 as a
> result of a fix for a race condition at startup.  Please take a look
> and let me know if I missed anything:
> 
> [PATCH 08/24] au0828: fix race condition that causes xc5000 to not
> bind for digital

Great! That's what I was hoping for. It wasn't clear from the patch subject
that that patch contained these changes, otherwise I wouldn't have bothered
you.

Anyway, another one bites the dust.

Regards,

	Hans
