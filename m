Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7OEYrYZ003906
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 10:34:54 -0400
Received: from smtp-vbr14.xs4all.nl (smtp-vbr14.xs4all.nl [194.109.24.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7OEYf9E023159
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 10:34:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Sun, 24 Aug 2008 16:34:36 +0200
References: <48AF1E83.4000102@nachtwindheim.de>
	<Pine.LNX.4.64.0808241045530.2897@areia>
In-Reply-To: <Pine.LNX.4.64.0808241045530.2897@areia>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808241634.36653.hverkuil@xs4all.nl>
Cc: Henne <henne@nachtwindheim.de>, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] V4L: fix retval in vivi driver for more than one device
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sunday 24 August 2008 16:00:45 Mauro Carvalho Chehab wrote:
> This patch is not 100% OK, for some reasons:
>
> 1) since ret won't be initialized anymore, it will generate
> compilation warnings;
>
> 2) with the current code, if you ask to allocate, let's say, 3
> virtual drivers, and the second or the third fails, you'll still have
> one allocated. With your change, you'll de-allocate even the ones
> that succeeded. IMO, the better is to allow using the ones that
> succeeded.
>
> That's said, I can see other issues on the current vivi.c code:
>
> 1) what happens if someone uses n_dev=0? It will return a wrong error
>     code.
>
> 2) there are still some cases where the driver allocates less devices
> than requested, but it will fail to register, and all stuff will be
> de-allocated;
>
> 3) what if n_dev is a big number? Currently, i think videodev will
> allow you to register up to 32 video devices of this type, even if
> you have memory for more, due to some limits inside videodev, and due
> to the number of minors allocated for V4L.  IMO, the driver should
> allocate up to the maximum allowed devices by videodev, and let users
> use they.
>
> Anyway, thanks for your patch. For sure we need to do some fixes
> here. I'll try to address all those stuff into a patch.

Hi Mauro,

Please note that I am working on creating a much improved V4L 
infrastructure to take care of such things. It's simply nuts that v4l 
drivers need to put in all the plumbing just to be able to have 
multiple instances.

In particular, all these limitations on the number of instances should 
disappear (unless you run out of minors).

Regards,

	Hans

>
> Cheers,
> Mauro.
>
> On Fri, 22 Aug 2008, Henne wrote:
> > From: Henrik Kretzschmar <henne@nachtwindheim.de>
> > Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> >
> > The variable ret should be set for each device to -ENOMEM, not only
> > the first.
> >
> > diff --git a/drivers/media/video/vivi.c
> > b/drivers/media/video/vivi.c index 3518af0..d739b59 100644
> > --- a/drivers/media/video/vivi.c
> > +++ b/drivers/media/video/vivi.c
> > @@ -1106,11 +1106,12 @@ static struct video_device vivi_template =
> > {
> >
> > static int __init vivi_init(void)
> > {
> > -	int ret = -ENOMEM, i;
> > +	int ret, i;
> > 	 struct vivi_dev *dev;
> > 	 struct video_device *vfd;
> >
> > 	for (i = 0; i < n_devs; i++) {
> > +		ret = -ENOMEM;
> > 		 dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> > 		 if (NULL == dev)
> > 			 break;


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
