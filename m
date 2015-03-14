Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:36535 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbbCNCjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 22:39:09 -0400
Received: by qcto4 with SMTP id o4so4200631qct.3
        for <linux-media@vger.kernel.org>; Fri, 13 Mar 2015 19:39:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426299523-14718-1-git-send-email-shuahkh@osg.samsung.com>
References: <1426299523-14718-1-git-send-email-shuahkh@osg.samsung.com>
Date: Fri, 13 Mar 2015 22:39:08 -0400
Message-ID: <CAGoCfix1KZWBbPso7sCi8-WiWG+OwEgjTS7Yt1YJVZULfYUgjw@mail.gmail.com>
Subject: Re: [PATCH] media: au0828 - add vidq busy checks to s_std and s_input
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Julia.Lawall@lip6.fr,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 13, 2015 at 10:18 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> au0828 s_std and s_input are missing queue busy checks. Add
> vb2_is_busy() calls to s_std and s_input and return -EBUSY
> if found busy.

These checks are only needed on devices which support more than a
single format (typically for devices which support standards for both
480 and 576 lines).  The au0828 only supports 720x480 capture, and
thus there are no conditions in which the capture window size can
change due to a standard change (since the device only supports
NTSC-M).  Hans has made clear in the past that it's permitted to
toggle inputs when we can be confident that there will be no change in
video standards (in fact, devices that are targeted at surveillance
prefer this to minimize the time toggling between multiple cameras).
A bridge that only supports one video standard and thus input frame
size falls into this category.

While a patch like this is appropriate for some bridges, it is not
needed for au0828.

Can you guys kindly please stop trying to cleanup/refactor au0828 and
xc5000?  First the xc5000 regression that caused arbitrary memory
corruption/panics and now this junk with the vbi_buffer_filled (btw,
did the submitter even *TRY* that patch to see if it actually
worked?).

I know patches like this are well intentioned, but poorly tested
patches and "cleanup" fixes which are completely untested are doing
more harm than good.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
