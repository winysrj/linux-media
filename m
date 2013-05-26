Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2444 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3EZUPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 16:15:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jon Arne =?iso-8859-1?q?J=F8rgensen?= <jonarne@jonarne.no>
Subject: Re: [RFC PATCH 00/24] Remove VIDIOC_DBG_G_CHIP_IDENT
Date: Sun, 26 May 2013 22:15:23 +0200
Cc: linux-media@vger.kernel.org
References: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl> <20130526184210.GC2367@dell.arpanet.local>
In-Reply-To: <20130526184210.GC2367@dell.arpanet.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201305262215.23756.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun May 26 2013 20:42:10 Jon Arne Jørgensen wrote:
> On Sun, May 26, 2013 at 03:26:55PM +0200, Hans Verkuil wrote:
> > With the introduction in 3.10 of the new superior VIDIOC_DBG_G_CHIP_INFO
> > ioctl there is no longer any need for the DBG_G_CHIP_IDENT ioctl or the
> > v4l2-chip-ident.h header.
> > 
> > This patch series removes all code related to this ioctl and the
> > v4l2-chip-ident.h header.
> > 
> > This patch series simplifies drivers substantially and deletes over 2800
> > lines in total.
> >
> Maybe a stupid question, but what tree should I apply this patch set to?
> I can't get it to apply to any of my kernel-trees.

Not a stupid question at all. I should have mentioned that this patch series
sits on top of my for-v3.11 tree:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/for-v3.11

Regards,

	Hans

> I tried your hverkuil/media_tree.git, but could not get it to apply
> there either.
> 
> Best regards,
> Jon Arne
