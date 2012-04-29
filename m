Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44881 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2D2Rjt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 13:39:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH] Compare entity name length aswell
Date: Sun, 29 Apr 2012 19:40:10 +0200
Message-ID: <10045536.FETi1x5lnc@avalon>
In-Reply-To: <CAKnK67SP3JLHjR0w60wh6rh6zmXOB8gQFNfS08SS3ghddMoyLg@mail.gmail.com>
References: <1335362233-31022-1-git-send-email-saaguirre@ti.com> <CAKnK67SP3JLHjR0w60wh6rh6zmXOB8gQFNfS08SS3ghddMoyLg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Saturday 28 April 2012 10:04:01 Aguirre, Sergio wrote:
> On Wed, Apr 25, 2012 at 8:57 AM, Sergio Aguirre <saaguirre@ti.com> wrote:
> > Otherwise, some false positives might arise when
> > having 2 subdevices with similar names, like:
> > 
> > "OMAP4 ISS ISP IPIPEIF"
> > "OMAP4 ISS ISP IPIPE"
> > 
> > Before this patch, trying to find "OMAP4 ISS ISP IPIPE", resulted
> > in a false entity match, retrieving "OMAP4 ISS ISP IPIPEIF"
> > information instead.
> > 
> > Checking length should ensure such cases are handled well.
> 
> Any feedback about this?

Thanks for the patch, and sorry for the delay.

> > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > ---
> >  src/mediactl.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/src/mediactl.c b/src/mediactl.c
> > index 5b8c587..451a386 100644
> > --- a/src/mediactl.c
> > +++ b/src/mediactl.c
> > @@ -66,7 +66,8 @@ struct media_entity *media_get_entity_by_name(struct
> > media_device *media, for (i = 0; i < media->entities_count; ++i) {
> >                struct media_entity *entity = &media->entities[i];
> > 
> > -               if (strncmp(entity->info.name, name, length) == 0)
> > +               if ((strncmp(entity->info.name, name, length) == 0) &&
> > +                   (strlen(entity->info.name) == length))
> >                        return entity;
> >        }

Instead of calling strlen() which has a O(n) complexity, what about just 
checking that the entity name has a '\0' in the length'th position ? Something 
like the following patch:

>From 46bec667b675573cf1ce698c68112e3dbd31930e Mon Sep 17 00:00:00 2001
From: Sergio Aguirre <saaguirre@ti.com>
Date: Wed, 25 Apr 2012 08:57:13 -0500
Subject: [PATCH] Compare name length to avoid false positives in 
media_get_entity_by_name

If two subdevice have names that only differ by a suffix (such as "OMAP4
ISS ISP IPIPE" and "OMAP4 ISS ISP IPIPEIF") the media_get_entity_by_name
function might return a pointer to the entity with the longest name when
called with the shortest name. Fix this by verifying that the candidate
entity name length is equal to the requested name length.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 src/mediactl.c |    9 ++++++++-
 src/tools.h    |    1 +
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/src/mediactl.c b/src/mediactl.c
index 5b8c587..bc6a713 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -63,10 +63,17 @@ struct media_entity *media_get_entity_by_name(struct 
media_device *media,
 {
 	unsigned int i;
 
+	/* A match is impossible if the entity name is longer than the maximum
+	 * size we can get from the kernel.
+	 */
+	if (length >= FIELD_SIZEOF(struct media_entity_desc, name))
+		return NULL;
+
 	for (i = 0; i < media->entities_count; ++i) {
 		struct media_entity *entity = &media->entities[i];
 
-		if (strncmp(entity->info.name, name, length) == 0)
+		if (strncmp(entity->info.name, name, length) == 0 &&
+		    entity->info.name[length] == '\0')
 			return entity;
 	}
 
diff --git a/src/tools.h b/src/tools.h
index e56edb2..de06cb3 100644
--- a/src/tools.h
+++ b/src/tools.h
@@ -23,6 +23,7 @@
 #define __TOOLS_H__
 
 #define ARRAY_SIZE(array)	(sizeof(array) / sizeof((array)[0]))
+#define FIELD_SIZEOF(t, f)	(sizeof(((t*)0)->f))
 
 #endif /* __TOOLS_H__ */
 
-- 
Regards,

Laurent Pinchart

