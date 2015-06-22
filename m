Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:49710 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbbFVOlN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 10:41:13 -0400
Date: Mon, 22 Jun 2015 15:41:05 +0100 (BST)
From: William Towle <william.towle@codethink.co.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: HDMI and Composite capture on Lager, for kernel 4.1, version 3
In-Reply-To: <558405F6.2040003@xs4all.nl>
Message-ID: <alpine.DEB.2.02.1506221539110.7684@xk120.dyn.ducie.codethink.co.uk>
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk> <558405F6.2040003@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Hans,
> I'm not sure if I've asked this before, but shouldn't soc-camera be extended
> with support for the DV_TIMINGS ioctls in order to control the adv7604?
>
> It's peculiar that that is not included in this patch series...

   Rob tells me he did some work on this, but we don't have it passing
muster with v4l2-compliance and since gstreamer tries a number of
resolutions of its own accord and subsequently produces images and
video without it we can make do without for our needs. I can include it
in or alongside the next submission if you'd to see it.


   Regarding your other comments, in particular the specification of the
following:
 		.tdms_lock_mask = 0x43,
 		.cable_det_mask = 0x01,
...when testing just the first input, these seem reasonable - in the
case of tdms_lock_mask the two least significant bits represent
V_LOCKED_RAW and DE_REGEN_LCK_RAW, and they are set in line with
the value of TDMSPLL_LCK_A_RAW when queried.

   While an implementation suitable for testing both of the ADV7612's
A and B inputs could just add TDMSPLL_LCK_B_RAW to tdms_lock mask,
the cable detect function isn't so trivial: it would need to query two
separate (and numerically non-adjacent) registers to do its job.

   For simplicity we would like to propose that our next iteration
supports just the first input (which is sufficient for our current
needs) and has commentary in appropriate places regarding its
shortcomings, although we're open to alternative suggestions if there
has already been discussion on the matter here.

Cheers,
   Wills.
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
