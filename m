Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47576 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaFCKkd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 06:40:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 0/2] v4l-utils: Add missing v4l2-mediabus.h header
Date: Tue, 03 Jun 2014 12:40:59 +0200
Message-ID: <3433266.HJNPOlTexz@avalon>
In-Reply-To: <538D99DE.8040602@xs4all.nl>
References: <1401756292-27676-1-git-send-email-laurent.pinchart@ideasonboard.com> <7921712.MU9v3dyUpo@avalon> <538D99DE.8040602@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 03 June 2014 11:48:14 Hans Verkuil wrote:
> On 06/03/14 11:46, Laurent Pinchart wrote:
> > On Tuesday 03 June 2014 08:52:29 Hans Verkuil wrote:
> >> On 06/03/2014 02:44 AM, Laurent Pinchart wrote:
> >>> Hello,
> >>> 
> >>> This patch set adds the missing v4l2-mediabus.h header, required by
> >>> media-ctl. Please see individual patches for details, they're pretty
> >>> straightforward.
> >> 
> >> Nack.
> >> 
> >> The kernel headers used in v4l-utils are installed via 'make
> >> sync-with-kernel'. So these headers shouldn't be edited, instead
> >> Makefile.am should be updated. In particular, that's where the missing
> >> header should be added.
> > 
> > I had seen mentions of sync-with-kernel and for some reason thought it was
> > a script. As I couldn't find it in the repository I decided to sync the
> > headers manually :-/
> > 
> > Thanks for fixing the problem. By the way, what would you think about
> > modifying sync-with-kernel to use installed kernel headers ?
> 
> Patches are welcome!
> 
> :-)

Patch sent :-)

-- 
Regards,

Laurent Pinchart

