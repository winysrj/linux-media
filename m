Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:41511 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab0EBUlw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 16:41:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 02/15] [RFC] v4l2-ctrls: reorder 'case' statements to match order in header.
Date: Sun, 2 May 2010 22:42:26 +0200
Cc: linux-media@vger.kernel.org
References: <cover.1272267136.git.hverkuil@xs4all.nl> <5f14ea711d1d98ea7fbdfbbc27422e679a9a1f63.1272267137.git.hverkuil@xs4all.nl>
In-Reply-To: <5f14ea711d1d98ea7fbdfbbc27422e679a9a1f63.1272267137.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005022242.26593.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 26 April 2010 09:33:33 Hans Verkuil wrote:
> To make it easier to determine whether all controls are added in
> v4l2-ctrls.c the case statements inside the switch are re-ordered to match
> the header.
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

This patch should be merged with the previous one.

-- 
Regards,

Laurent Pinchart
