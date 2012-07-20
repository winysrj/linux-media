Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2080 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2GTH3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 03:29:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [PATCH] vivi: remove pointless video_nr++
Date: Fri, 20 Jul 2012 09:28:33 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201207192245.49852.hverkuil@xs4all.nl> <CALF0-+UD-+L4AcN8BkTrjoXq4m78sV3eeTiLgY0Q1B1Y==_5sg@mail.gmail.com> <CALF0-+U5rSwoVNOzpQ6qMrvVjOO=5C8-WsyRhfiJeQfat1Tbtg@mail.gmail.com>
In-Reply-To: <CALF0-+U5rSwoVNOzpQ6qMrvVjOO=5C8-WsyRhfiJeQfat1Tbtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207200928.33546.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu July 19 2012 23:15:42 Ezequiel Garcia wrote:
> On Thu, Jul 19, 2012 at 6:05 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> > On Thu, Jul 19, 2012 at 5:45 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> Remove the pointless video_nr++. It doesn't do anything useful and it has
> >> the unexpected side-effect of changing the video_nr module option, so
> >> cat /sys/module/vivi/parameters/video_nr gives a different value back
> >> then what was specified with modprobe.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> >> index 1e8c4f3..679e329 100644
> >> --- a/drivers/media/video/vivi.c
> >> +++ b/drivers/media/video/vivi.c
> >> @@ -1330,9 +1330,6 @@ static int __init vivi_create_instance(int inst)
> >>         /* Now that everything is fine, let's add it to device list */
> >>         list_add_tail(&dev->vivi_devlist, &vivi_devlist);
> >>
> >> -       if (video_nr != -1)
> >> -               video_nr++;
> >> -
> >>         v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
> >>                   video_device_node_name(vfd));
> >>         return 0;
> >> --
> >
> > Hans,
> >
> > I think you forgot to *also* remove the video_nr module parameter.
> > (and, of course, pass a '-1' to video_register_device)
> >
> 
> Or maybe not, :-) if you want to be able to force video device number.

Some people apparently want to force it. I never understood why, but enough
people do it so that we can't remove it.

Regards,

	Hans
