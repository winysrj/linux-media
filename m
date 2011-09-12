Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42894 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab1ILOUm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Sep 2011 10:20:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH] uvcvideo: Fix crash when linking entities
Date: Mon, 12 Sep 2011 16:20:39 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Josh Boyer <jwboyer@redhat.com>, linux-media@vger.kernel.org,
	Dave Jones <davej@redhat.com>,
	Daniel Dickinson <libre@cshore.neomailbox.net>
References: <1315348148-7207-1-git-send-email-laurent.pinchart@ideasonboard.com> <201109080938.54655.laurent.pinchart@ideasonboard.com> <20110912011614.GA4834@elie.sbx02827.chicail.wayport.net>
In-Reply-To: <20110912011614.GA4834@elie.sbx02827.chicail.wayport.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109121620.39982.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonathan,

On Monday 12 September 2011 03:16:14 Jonathan Nieder wrote:
> Laurent Pinchart wrote:
> > On Wednesday 07 September 2011 17:32:41 Josh Boyer wrote:
> >> On Wed, Sep 07, 2011 at 12:29:08AM +0200, Laurent Pinchart wrote:
> >>>  drivers/media/video/uvc/uvc_entity.c |    2 +-
> >>>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>> 
> >>> This patch should fix a v3.0 regression that results in a kernel crash
> >>> as reported in http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=637740
> >>> and https://bugzilla.redhat.com/show_bug.cgi?id=735437.
> 
> [...]
> 
> >> I built a test kernel for Fedora with the patch and the submitter of the
> >> above bug has reported that the issue seems to be fixed.
> > 
> > Thank you. I will push the patch upstream.
> 
> Any news?  From Red Hat bugzilla, it seems that the fix was tested by
> Marcin Zajaczkowski and user matanya.  More importantly, the patch
> just makes sense.
> 
> I don't see this patch in Linus's master or
> 
>  git://linuxtv.org/media_tree.git staging/for_v3.2

I've just sent a pull request to Mauro.

-- 
Regards,

Laurent Pinchart
