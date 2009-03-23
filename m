Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2NNrYo0032083
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 19:53:34 -0400
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2NNrD8e022746
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 19:53:13 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1042681qwh.39
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 16:53:13 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Date: Mon, 23 Mar 2009 20:53:03 -0300
References: <200903231217.45740.lamarque@gmail.com>
	<200903232011.41319.lamarque@gmail.com>
	<208cbae30903231631k33a66a12t29b0f0bdd4c2f0dc@mail.gmail.com>
In-Reply-To: <208cbae30903231631k33a66a12t29b0f0bdd4c2f0dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903232053.03407.lamarque@gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Patch implementing V4L2_CAP_STREAMING for zr364xx driver
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

Em Monday 23 March 2009, Alexey Klimov escreveu:
> Hello, Lamarque
>
> On Tue, Mar 24, 2009 at 2:11 AM, Lamarque Vieira Souza
> <lamarque@gmail.com>wrote:
>
> <snip>
>
> > > +static void read_pipe_completion(struct urb *purb)
> > > +{
> > > +     struct zr364xx_pipeinfo *pipe_info;
> > > +     struct zr364xx_camera *cam;
> > > +     int status;
> > > +     int pipe;
> > > +
> > > +     pipe_info = purb->context;
> > > +     DBG("%s %p, status %d\n", __func__, purb, purb->status);
> > > +     if (pipe_info == NULL) {
> > > +             err("no context!");
> > >
> > >
> > > +             return;
> > > +     }
> > > +
> > > +     cam = pipe_info->cam;
> > > +     if (cam == NULL) {
> > > +             err("no context!");
> > >
> > > Do you use err() macro from usb.h ?
> > > If yes - as i know it's better not to use this macros, because this
> >
> > macros
> >
> > > can suddenly became deprecated. It's more comfortable to use printk or
> > > dev_err.
> >
> >         Well, s2255drc.c uses it, since my changes are based on that I
> > supposed it
> > could be used. I will change them to printk's.
>
> I saw situation when there were troubles because driver used info() and
> warn() macroses and usb.h wasn't contain these macroses and next-kernel
> tree was some kind of broken. It's definitely  uncomfortable.
>
> > Also, our current maillist is linux-media@vger.kernel.org.
> >
> > > It's better to post patches there.
> >
> >         Ok. When I finish to remove some code I will post the new patch
> > there. That
> > also explain why this list is so calm compared to the other kernel lists
> > I have been to. By the way, do you understande something about
> > pixelformats? I
> > need to convert YUV 4:2:0 into YUV 4:2:2 (UYVY) in libv4l to make my
> > webcam work with Skype. Actually the frame is decoded into uncompressed
> > jpeg before
> > it is converted to YUV 4:2:0, so maybe I do not need to YUV 4:2:0 into
> > YUV 4:2:2 (UYVY). I am just not used to the pixel format details.
>
> Sorry, i can't help you with that :(
> It's one more reason to ask linux-media kernel list.

	Ok, thanks anyway. The resources field in struct zr364xx_camera is need to 
avoid a second call the streamon, so I inlined it as you told me. I change the 
number of frame buffers to 1 as it is in the original zr364xx.c, it is working 
this way, so the driver is going to spend less memory. Now I need to re-
implement V4L2_CAP_READWRITE.

-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
