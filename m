Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:53207 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0ECHXH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 03:23:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 02/15] [RFC] v4l2-ctrls: reorder 'case' statements to match order in header.
Date: Mon, 3 May 2010 09:23:39 +0200
Cc: linux-media@vger.kernel.org
References: <cover.1272267136.git.hverkuil@xs4all.nl> <201005022242.26593.laurent.pinchart@ideasonboard.com> <201005030842.59931.hverkuil@xs4all.nl>
In-Reply-To: <201005030842.59931.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005030923.40475.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 03 May 2010 08:42:59 Hans Verkuil wrote:
> On Sunday 02 May 2010 22:42:26 Laurent Pinchart wrote:
> > Hi Hans,
> > 
> > On Monday 26 April 2010 09:33:33 Hans Verkuil wrote:
> > > To make it easier to determine whether all controls are added in
> > > v4l2-ctrls.c the case statements inside the switch are re-ordered to
> > > match the header.
> > > 
> > > Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> > 
> > This patch should be merged with the previous one.
> 
> I didn't do that in order to make the previous patch easier to review.
> That patch just moves this table unchanged from v4l2-common.c to
> v4l2-ctrl.c. Since the table doesn't change it is easy to verify that,
> well, no changes were made.
> 
> I will keep this as a separate patch if you don't mind.

N/P.

-- 
Regards,

Laurent Pinchart
