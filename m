Return-path: <mchehab@gaivota>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2552 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1ACTyN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 14:54:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Ellingsworth <david@identd.dyndns.org>
Subject: Re: [RFCv2 PATCH 06/10] radio_ms800: use video_drvdata instead of filp->private_data
Date: Mon, 3 Jan 2011 20:54:01 +0100
Cc: linux-media@vger.kernel.org
References: <6515cfbdde63364fd12bca1219870f38ff371145.1294078230.git.hverkuil@xs4all.nl> <7e1e3d8066d44fb6b9e1caba57378a2efbe891c1.1294078230.git.hverkuil@xs4all.nl> <AANLkTiki207JrsiZxboKDNPjQ69rzWS=MhjTzJj3zL2R@mail.gmail.com>
In-Reply-To: <AANLkTiki207JrsiZxboKDNPjQ69rzWS=MhjTzJj3zL2R@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101032054.01080.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Monday, January 03, 2011 20:35:41 David Ellingsworth wrote:
> Why does this matter? From my understanding, v4l2_fh is meant to be
> embed it in a device specific structure.

No, v4l2_fh is a per-filehandle structure, not a per-device node structure.

filp->private_data is meant to store per-filehandle data (such as v4l2_fh),
but instead it stores per-device node data (struct video_device). And that
prevents it from being used to store struct v4l2_fh.

And there is a perfectly valid alternative for this in the form of
video_drvdata which does not use filp->private_data and so makes it available
for v4l2_fh.

Regards,

	Hans

> If it is the first member in
> the device specific structure, then the pointer to v4l2_fh is the same
> as the one to the device specific structure. Otherwise, a simple
> container_of can be used to calculate the appropriate address of the
> container. In either case, the pointer calculation method is always
> going to be faster than executing a call, and de-referencing multiple
> pointers to retrieve the same information. filp->private data is there
> for a reason, why not use it as intended and avoid the additional
> overhead added by this patch?
> 
> Regards,
> 
> David Ellingsworth
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
