Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9G6uMYi007683
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:56:22 -0400
Received: from smtp-vbr3.xs4all.nl (smtp-vbr3.xs4all.nl [194.109.24.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9G6tcoY003982
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:55:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Thu, 16 Oct 2008 08:55:35 +0200
References: <uskqyqg58.wl%morimoto.kuninori@renesas.com>
	<8763ntf3o8.fsf@free.fr>
	<aec7e5c30810152346q251c963h7a4419fa59fb6612@mail.gmail.com>
In-Reply-To: <aec7e5c30810152346q251c963h7a4419fa59fb6612@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810160855.35749.hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Add ov772x driver
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

On Thursday 16 October 2008 08:46:31 Magnus Damm wrote:
> On Thu, Oct 16, 2008 at 3:35 PM, Robert Jarzmik 
<robert.jarzmik@free.fr> wrote:
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> >> Hm, so, to test your camera you have to modify your source and
> >> rebuild your kernel... And same again to switch back to normal
> >> operation. Does not sound very convenient to me. OTOH, making it a
> >> module parameter makes it much easier. In fact, maybe it would be
> >> a good idea to add a new camera-class control for this mode. Yet
> >> another possibility is to enable debug register-access in the
> >> driver and use that to manually set the test mode from user-space.
> >> A new v4l-control seems best to me, not sure what others will say
> >> about this. As you probably know, many other cameras also have
> >> this "test pattern" mode, some even several of them. So, this
> >> becomes a control with a parameter then.
> >
> > Personnaly I'm rather inclined for the debug registers solutions.
> >
> > When developping a camera driver, the test pattern alone is not
> > enough. You have to tweak the registers, see if the specification
> > is correct, then understand the specification, and then change your
> > driver code. My experience tells me you never understand correctly
> > are camera setup from the first time.
>
> One thing is when people write their driver, but the scenario that
> I'm thinking about is more when people take an already existing
> soc_camera sensor driver and hook it up to some soc_camera host.
> There are all sorts of endian and swapping issues that need to be
> worked out. They depend on soc_camera host driver, endian setting and
> userspace. Having a test pattern available would surely help there in
> my opinion.
>
> > So IMHO the registers are enough here.
> >
> >> Then a new control or raw register access would be a better way, I
> >> think.
> >
> > So do I.
>
> I dislike the register access option since it requires the developer
> to have some user space tool that most likely won't ship with the
> kernel. I think seeing it as yet another video input source is pretty
> clean. Or maybe it isn't very useful at all, I'm not sure. =)

Just to give some background: register access can be done via the 
v4l2-dbg utility (see v4l2-apps/util) which uses the 
VIDIOC_DBG_G/S_REGISTER ioctls which are only compiled into the driver 
when the CONFIG_VIDEO_ADV_DEBUG option is set. This is the standard way 
of accessing registers.

An alternative for selecting a test pattern could be to have two inputs: 
one is the camera and another one is the test pattern. Here too you 
could enable the test pattern input only if CONFIG_VIDEO_ADV_DEBUG is 
set.

Just some ideas for you.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
