Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45224 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab1IHHi6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 03:38:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] uvcvideo: Fix crash when linking entities
Date: Thu, 8 Sep 2011 09:38:54 +0200
Cc: linux-media@vger.kernel.org, Dave Jones <davej@redhat.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Daniel Dickinson <libre@cshore.neomailbox.net>
References: <1315348148-7207-1-git-send-email-laurent.pinchart@ideasonboard.com> <20110907153240.GI10700@zod.bos.redhat.com>
In-Reply-To: <20110907153240.GI10700@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109080938.54655.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Wednesday 07 September 2011 17:32:41 Josh Boyer wrote:
> On Wed, Sep 07, 2011 at 12:29:08AM +0200, Laurent Pinchart wrote:
> > The uvc_mc_register_entity() function wrongfully selects the
> > media_entity associated with a UVC entity when creating links. This
> > results in access to uninitialized media_entity structures and can hit a
> > BUG_ON statement in media_entity_create_link(). Fix it.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/uvc/uvc_entity.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > This patch should fix a v3.0 regression that results in a kernel crash as
> > reported in http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=637740 and
> > https://bugzilla.redhat.com/show_bug.cgi?id=735437.
> > 
> > Test results will be welcome.
> 
> I built a test kernel for Fedora with the patch and the submitter of the
> above bug has reported that the issue seems to be fixed.

Thank you. I will push the patch upstream.

-- 
Regards,

Laurent Pinchart
