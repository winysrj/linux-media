Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46697 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab1ILBQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Sep 2011 21:16:30 -0400
Received: by yie30 with SMTP id 30so2276555yie.19
        for <linux-media@vger.kernel.org>; Sun, 11 Sep 2011 18:16:29 -0700 (PDT)
Date: Sun, 11 Sep 2011 20:16:14 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Josh Boyer <jwboyer@redhat.com>, linux-media@vger.kernel.org,
	Dave Jones <davej@redhat.com>,
	Daniel Dickinson <libre@cshore.neomailbox.net>
Subject: Re: [PATCH] uvcvideo: Fix crash when linking entities
Message-ID: <20110912011614.GA4834@elie.sbx02827.chicail.wayport.net>
References: <1315348148-7207-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <20110907153240.GI10700@zod.bos.redhat.com>
 <201109080938.54655.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109080938.54655.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Mauro,

Laurent Pinchart wrote:
> On Wednesday 07 September 2011 17:32:41 Josh Boyer wrote:
>> On Wed, Sep 07, 2011 at 12:29:08AM +0200, Laurent Pinchart wrote:

>>>  drivers/media/video/uvc/uvc_entity.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> This patch should fix a v3.0 regression that results in a kernel crash as
>>> reported in http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=637740 and
>>> https://bugzilla.redhat.com/show_bug.cgi?id=735437.
[...]
>> I built a test kernel for Fedora with the patch and the submitter of the
>> above bug has reported that the issue seems to be fixed.
>
> Thank you. I will push the patch upstream.

Any news?  From Red Hat bugzilla, it seems that the fix was tested by
Marcin Zajaczkowski and user matanya.  More importantly, the patch
just makes sense.

I don't see this patch in Linus's master or

 git://linuxtv.org/media_tree.git staging/for_v3.2
