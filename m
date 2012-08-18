Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3689 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2HRPGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Aug 2012 11:06:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?iso-8859-15?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: How to add new chip ids to v4l2-chip-ident.h ?
Date: Sat, 18 Aug 2012 17:06:03 +0200
Cc: linux-media@vger.kernel.org
References: <502FA46E.3050500@googlemail.com>
In-Reply-To: <502FA46E.3050500@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208181706.03257.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat August 18 2012 16:19:26 Frank Schäfer wrote:
> Hi,
> 
> I would like to know how to add new chip ids to v4l2-chip-ident.h. Ist
> there a kind of policy for choosing numbers ?

Using numbers that match the chip number is recommended, but if that can't
be done due to clashes, then pick some other, related, number (e.g. 12700
instead of 2700) or create a range of number for all possible models of that
chip series.

> Which numbers would be approriate for the em25xx/em26xx/em27xx/em28xx
> chips ?
> Unfortunately 2700 is already used by V4L2_IDENT_VP27SMPX...

Please note that adding an identifier to v4l2-chip-ident.h is only needed
if the VIDIOC_DBG_* ioctls are implemented. If those are not implemented,
then there is no need for an ID either.

Regards,

	Hans
