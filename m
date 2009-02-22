Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2817 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbZBVLyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 06:54:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC] How to pass camera Orientation to userspace
Date: Sun, 22 Feb 2009 12:53:29 +0100
Cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-omap@vger.kernel.org
References: <200902180030.52729.linux@baker-net.org.uk> <200902211253.58061.hverkuil@xs4all.nl> <49A13466.5080605@redhat.com>
In-Reply-To: <49A13466.5080605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902221253.29719.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 22 February 2009 12:17:58 Hans de Goede wrote:
> Hans Verkuil wrote:
> >> Cons: Would require polling to support the case of a camera being
> >> turned toward / away from the user while streaming.
> >
> > Polling applies only to the bits that tell the orientation of the
> > camera. See below for a discussion of this.
>
> Didn't we agree to separate orietation (as in sensor mounted upside down)
> and the user being able to rotate the camera (which i believe we called
> pivotting).

Yes, I wrote this more as a clarification since I thought that the original 
text didn't make this distinction clearly enough.

> For the orientation case, which is the case with the sq905X, we do not
> need to poll, as for pivotting, here is my proposal:
>
> Have both orientation and pivotting flags in the input flags. The
> pivotting flags will indicate the pivotting state at the moment of doing
> the ioctl (which may change later), so these indeed may need to be
> polled, unlike the orientation flags which will never change.

Ack.

I propose to take one of the reserved fields from v4l2_input and either turn 
it into two __u16 fields (capabilities and flags) or one __u32 field 
(flags). I'm not sure whether the alignment of two __u16 fields will be 
done correctly on 32 and 64 bit systems since v4l2_input cannot change in 
size. Something to test first.

> >> Can't easily identify drivers that don't support it.
> >
> > Not too difficult to add through the use of a capability bit. Either in
> > v4l2_input or (perhaps) v4l2_capability.
>
> +1
>
> > Another Pro is that this approach will also work for v4l2_output in the
> > case of, say, rotated LCD displays. Using camera orientation bits in
> > v4l2_buffer while capturing will work, but using similar bits for
> > output will fail since the data is going in the wrong direction.
> >
> >> The interest in detecting if a driver provides this informnation is to
> >> allow libv4l to know when it should use the driver provided
> >> information and when it should use its internal table (which needs to
> >> be retained for backward compatibility). With no detection capability
> >> the driver provided info should be ignored for USB IDs in the built in
> >> table.
> >>
> >> Thoughts please
> >
> > Is polling bad in this case? It is not something that needs immediate
> > attention IMHO.  The overhead for checking once every X seconds is
> > quite
> >
>  > low.
>
> Agreed, but it still is something which should be avoided if possible,
> implementing polling also means adding a lot of IMHO unneeded code on the
> userspace side.
>
> I would prefer to make the "realtime" pivotting state available to the
> app by adding flags containing the pivotting state at frame capture to
> the v4l2_buf flags.
>
> But if people dislike this, libv4l can simple poll the input now and
> then.

I think this should be prototyped. Compare polling vs. putting the state in 
the v4l2_buf flags and see if that makes a lot of difference in the user 
experience compared to polling once a second. If it clearly improves things 
for the user, then I have no objections to adding bits to v4l2_buf.

> > Furthermore, it is only needed on devices that cannot do v/hflipping
> > in hardware.
>
> Erm, no, since we decided we want to differentiate between sensor
> orientation and camera pivotting, I think the driver should not
> automagically do v/hflipping in the pivot case, this should be left up to
> userspace. Maybe the user actually wants to have an upside down picture ?

Sorry, you're right. I'd forgotten that.

> > An alternative is to put some effort in a proper event interface. There
> > is one implemented in include/linux/dvb/video.h and used by ivtv for
> > video decoding. The idea is that the application registers events it
> > wants to receive, and whenever such an event arrives the select() call
> > will exit with a high-prio event (exception). The application then
> > checks what happened.
>
> No not another event interface please. Once could argue that we should
> export the pivotting info through the generic linux input system, but not
> a v4l specific event interface please. Actually I think making the
> pivotting sensor available through the generic input system in addition
> to making it available through input flags would be nice to have. Just
> like we need to make all those take a picture now buttons on webcams
> available through the generic input system.

Agreed. I'm not up to date when it comes to the state of event interfaces in 
linux, and this is a solution for the longer term anyway. I guess someone 
needs to pick this up and research it to see what works best.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
