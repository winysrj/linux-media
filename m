Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:53977 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZA2LCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 06:02:51 -0500
Date: Thu, 29 Jan 2009 03:02:47 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Marton Balint <cus@fazekas.hu>
cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH] cx88: fix unexpected video resize when setting tv norm
In-Reply-To: <Pine.LNX.4.64.0901290232500.25376@cinke.fazekas.hu>
Message-ID: <Pine.LNX.4.58.0901290257330.17300@shell2.speakeasy.net>
References: <571b3176dc82a7206ade.1231614963@roadrunner.athome>
 <Pine.LNX.4.58.0901101325420.1626@shell2.speakeasy.net>
 <Pine.LNX.4.64.0901290232500.25376@cinke.fazekas.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2009, Marton Balint wrote:
> The status of this patch has changed to "Changes Requested" in
> patchwork, but it's not obvious to me what changes are needed exactly.
> Yes, in the comments quite a few questions came up, but we haven't
> decided the correct course of action for good, and the patch also makes
> sense in it's current form.

The most serious problem with the patch is that the current image size may
not be valid after changing norms.  The driver and v4l2 aren't designed to
allow an invalid image size to be selected, yet this patch would allow that
to happen.
