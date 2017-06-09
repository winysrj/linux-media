Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33256 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751561AbdFIK15 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 06:27:57 -0400
Date: Fri, 9 Jun 2017 13:27:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kevin Hilman <khilman@baylibre.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/4] [media] davinci: vpif_capture: get subdevs from
 DT when available
Message-ID: <20170609102752.GO1019@valkosipuli.retiisi.org.uk>
References: <20170606233741.26718-1-khilman@baylibre.com>
 <20170606233741.26718-3-khilman@baylibre.com>
 <f305d0fc-b5cd-591a-1d95-7ae66bfa72ec@xs4all.nl>
 <CAOi56cV18wJce8hzTk0r0YKvr4vzLi8QDwu01Az1rae-9=wMRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi56cV18wJce8hzTk0r0YKvr4vzLi8QDwu01Az1rae-9=wMRg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kevin,

On Thu, Jun 08, 2017 at 06:01:45PM -0700, Kevin Hilman wrote:
> On Wed, Jun 7, 2017 at 11:29 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On 07/06/17 01:37, Kevin Hilman wrote:
> >> Enable  getting of subdevs from DT ports and endpoints.
> >>
> >> The _get_pdata() function was larely inspired by (i.e. stolen from)
> >> am437x-vpfe.c
> >>
> >> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
> >> ---
> >>  drivers/media/platform/davinci/vpif_capture.c | 126 +++++++++++++++++++++++++-
> >>  drivers/media/platform/davinci/vpif_display.c |   5 +
> >>  include/media/davinci/vpif_types.h            |   9 +-
> >>  3 files changed, 134 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> >> index fc5c7622660c..b9d927d1e5a8 100644
> >> --- a/drivers/media/platform/davinci/vpif_capture.c
> >> +++ b/drivers/media/platform/davinci/vpif_capture.c
> >> @@ -22,6 +22,8 @@
> >>  #include <linux/slab.h>
> >>
> >>  #include <media/v4l2-ioctl.h>
> >> +#include <media/v4l2-of.h>
> >
> > v4l2-of.h no longer exists, so this v2 is wrong. Unfortunately this patch has
> > already been merged in our master. I'm not sure how this could have slipped past
> > both my and Mauro's patch testing (and yours, for that matter).
> 
> I have that file in the various trees I tested agains.
> 
> > Can you fix this and post a patch on top of the media master that makes this
> > compile again?
> 
> Sorry for the dumb question, but what tree are you referring to?  I
> tried the master branch of both [1] and [2] and both seem to have that
> include.

These patches are now merged as well as the changes requested:

<URL:https://git.linuxtv.org/media_tree.git/commit/?id=a2d17962c9ca7ac66a132bbbfc6054559856e14e>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
