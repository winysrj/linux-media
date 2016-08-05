Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57660 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161249AbcHEMrP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 08:47:15 -0400
Date: Fri, 5 Aug 2016 15:46:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [v4l-utils RFC 0/3] mediatext library and test program
Message-ID: <20160805124639.GO3243@valkosipuli.retiisi.org.uk>
References: <1469114146-11109-1-git-send-email-sakari.ailus@linux.intel.com>
 <175a83b2-8112-f849-2e7a-7a22a2e864aa@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175a83b2-8112-f849-2e7a-7a22a2e864aa@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jul 22, 2016 at 03:09:47PM +0200, Hans Verkuil wrote:
> Hi Sakari,
> 
> First a practical matter: you should consider using the v4l-helpers.h: it
> will shield you and probably the end-user as well from lots of
> complexities, esp. the single vs multiplanar differences.
> 
> I really need to spend some time documenting it, but it isn't all that difficult.

Thanks. I wasn't aware of this --- partly because I seldom write user space
software. :-) I took a glance and it appears applicable to me on video
nodes. I'll consider that when updating the set the next time.

> 
> 
> On 07/21/2016 05:15 PM, Sakari Ailus wrote:
> > Hi everyone,
> > 
> > We've got a number of V4L2 (and MC) test programs for about as many reasons.
> > The existing programs are concentrated to work on a single device node at a
> > time, and with a single interface, be that Media controller or V4L2.
> > 
> > The test programs are also command line controlled, working their way with
> > the device at hand based on the information passed to the test programs on
> > the command line. This has made perfect sense for the past 15 years, as long
> > as we've had such test programs: they have covered, for large part, needs to
> > perform testing in various cases without leaving significant gaps.
> > 
> > With the upcoming request API, however, this has become insufficient. The
> > very nature of the request API requires that requests can contain resources
> > (e.g. memory buffers) that is associated to a number of video device nodes.
> > The requests may well be different from each other, including the types of
> > resources that are used for each request.
> > 
> > So I decided we need a new test program. The scope for the original
> > mediatext library and test program were slightly different from what is in
> > this (very RFC) patchset. I deemed mediatext as the best starting point for
> > writing a new test program.
> 
> Is this utility meant to testing different scenarios, or as a way to test drivers
> (compliance tests)? I think the first, right?

The first. I haven't thought of compliancy testing when writing the code.
Nothing prevents using it for that though but right now it's probably not
the best tool for that at the moment.

> 
> > mediatext acts as an interface between an end user or a script and the
> > kernel interfaces, with an ability to work with multiple devices at a time,
> > including multiple video nodes:
> > 
> >                        shell script
> >                            |
> >                            |
> >                            |  <- two-way pipe
> >                            |
> >                            |
> >                        mediatext
> >                      /     |     \
> >                     /      |      \
> >              /dev/video*   |     /dev/v4l-subdev*
> >                            |
> >                          /dev/mediaX
> > 
> > The shell script (which could be any other program as well but shell scripts
> > are convenient for the purpose) is always in the control of the main loop of
> > the test. Events are delivered to the script by mediatext based on file
> > handle state changes, so the script has a possibility to react to each of
> > them (e.g. buffer becoming dequeueable on one of the video nodes).
> > 
> > A simple example script for a UVC compliant Logitech webcam is below. It
> > opens the device based on the name of the entity, and sets up the device for
> > streaming with a specified format with three MMAP buffers. The first 50
> > frames are written to a file, and capturing is stopped once about 100 frames
> > have been captured. Dequeued buffers are immediately requeued, and this is
> > explicitly done by the shell script.
> > 
> > ---------------------8<---------------------
> > #!/bin/bash
> > 
> > eval_line() {
> >     while [ $# -ne 0 ]; do
> > 	local name=${1%=*}
> > 	local value=${1#*=}
> > 	p[$name]="$value"
> > 	shift
> >     done
> > }
> > 
> > coproc mediatext -d /dev/media0 2>&1
> > 
> > cat <<EOF >&${COPROC[1]}
> > v4l open entity="UVC Camera (046d:0825)" name=uvc
> > v4l fmt vdev=uvc type=CAPTURE width=320 height=240 \
> >         pixelformat=YUYV bytesperline=0
> > v4l reqbufs vdev=uvc type=CAPTURE count=3 memory=MMAP
> > v4l qbuf vdev=uvc
> > v4l qbuf vdev=uvc
> > v4l qbuf vdev=uvc
> >                                   
> > v4l streamon vdev=uvc type=CAPTURE
> > EOF
> > 
> > while IFS= read -ru ${COPROC[0]} line; do
> > 	unset p; declare -A p
> > 	eval eval_line $line
> > 	echo $line
> > 	case ${p[event]} in
> > 	dqbuf)
> > 		if ((${p[seq]} < 50)); then
> > 			echo v4l write vdev=uvc \
> > 				sequence=${p[seq]} >&${COPROC[1]}
> > 		fi
> > 		if ((${p[seq]} > 100)); then
> > 			echo quit >&${COPROC[1]}
> > 		fi
> > 		cat <<EOF >&${COPROC[1]}
> > 			v4l qbuf vdev=uvc
> > EOF
> > 	;;
> > 	esac;
> > done
> > ---------------------8<---------------------
> > 
> > Requests are naturally supported as well, right now only for buffer-related
> > IOCTLs but support for other IOCTLs can be added as well. The library has
> > been designed to be modular and easily extensible. There are no drivers
> > implementing them yet, and the kernel patches are still in development.
> > 
> > The kernel patches from which the headers have been generated from are
> > available here:
> > 
> > <URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=shortlog;h=refs/heads/request>
> > 
> > As noted, the test program is still in development phase. I thought this
> > still would be useful for others working on the request API so I decided to
> > share it already.
> 
> Can you show a test script/shell example of the use of the request API?

We don't have a driver that would support requests in mainline right now.
The below changes to the script assume that uvcvideo would support requests.

---------------------8<---------------------
#!/bin/bash

eval_line() {
    while [ $# -ne 0 ]; do
	local name=${1%=*}
	local value=${1#*=}
	p[$name]="$value"
	shift
    done
}

coproc mediatext -d /dev/media0 2>&1

cat <<EOF >&${COPROC[1]}
v4l open entity="UVC Camera (046d:0825)" name=uvc
v4l fmt vdev=uvc type=CAPTURE width=320 height=240 \
        pixelformat=YUYV bytesperline=0
v4l reqbufs vdev=uvc type=CAPTURE count=3 memory=MMAP

v4l streamon vdev=uvc type=CAPTURE
EOF

for ((i = 0; i < 10; i++)); do
	cat <<EOF >&${COPROC[1]}
media req-create req=foo$i
v4l qbuf vdev=tpg req=foo$i
media req-queue req=foo$i
EOF
done

while IFS= read -ru ${COPROC[0]} line; do
	unset p; declare -A p
	eval eval_line $line
	echo $line
	case ${p[event]} in
	dqbuf)
		if ((${p[seq]} < 50)); then
			echo v4l write vdev=uvc \
				sequence=${p[seq]} >&${COPROC[1]}
		fi
	;;
	dqevent)
		if ((${p[req-id]} > 100)); then
			echo quit >&${COPROC[1]}
		fi
		cat <<EOF >&${COPROC[1]}
			media req-create req=${p[req]}
			v4l qbuf vdev=uvc
			media req-queue req=${p[req]}
EOF
	;;
	esac;
done
---------------------8<---------------------

> 
> > 
> > Current todo list:
> > 
> > - The scope of the current media-ctl functionality command format does not
> >   match with the rest of the program. To be fixed.
> > 
> > - Support requests for non-buffer related IOCTLs. This is pending on
> >   relevant kernel patches.
> > 
> > - Clean up command parameters and event messages to make them more
> >   consistent.
> > 
> 
> I'd split off the parser code into its own source as well.
> 
> Is there a reason you use C instead of C++? C++ would make life a bit easier: STL
> of course, but the cv4l-helpers.h (the C++ variant of v4l-helpers.h) is quite nice
> as well.

I think this is primarily a question of opinion in this case and I prefer C
over C++. Things like proper support for inheritance might help in some cases
but that's applicable to a lot of programs written in C.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
