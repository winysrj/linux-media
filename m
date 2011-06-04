Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4163 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab1FDKbm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2011 06:31:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv2 PATCH 05/11] v4l2-ctrls: add v4l2_fh pointer to the set control functions.
Date: Sat, 4 Jun 2011 12:31:37 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl> <f3f32913df4962bdb541abe87348e561c5e6d325.1306329390.git.hans.verkuil@cisco.com> <201106032155.23482.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201106032155.23482.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106041231.37586.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, June 03, 2011 21:55:23 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Wednesday 25 May 2011 15:33:49 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > When an application changes a control you want to generate an event.
> > However, you want to avoid sending such an event back to the application
> > (file handle) that caused the change.
> > 
> > Add the filehandle to the various set control functions.
> 
> To implement per-file handle controls, the get/try functions will need the 
> file handle as well. Should this patch handle that, or do you want to postpone 
> it until a driver uses per-file handle controls ?

No, this has nothing to do with per-filehandle controls. This filehandle is
needed to prevent events from being sent to the filehandle that caused the
change (leads to nasty feedback-loops). Since get and try will never raise
control events I do not need the filehandle there.

It's patches 3/11 and 11/11 that actually add support for per-filehandle controls.

Regards,

	Hans
