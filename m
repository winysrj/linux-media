Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1073 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaILIIS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 04:08:18 -0400
Message-ID: <5412A9DB.8080701@xs4all.nl>
Date: Fri, 12 Sep 2014 10:07:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>,
	"mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: v4l2 ioctls
References: <54124BDC.3000306@osg.samsung.com>
In-Reply-To: <54124BDC.3000306@osg.samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2014 03:26 AM, Shuah Khan wrote:
> Hi Mauro/Hans,
> 
> I am working on adding sharing construct to dvb-core and v4l2-core.
> In the case of dvb I have clean start and stop points to acquire the
> tuner and release it. Tuner is acquired from dvb_frontend_start() and
> released from dvb_frontend_thread() when thread exits. This works very
> well.
> 
> The problem with analog case is there are no clear entry and exit
> points. Instead of changing ioctls, it will be cleaner to change
> the main ioctl entry routine __video_do_ioctl(). Is there an easy
> way to tell which ioctls are query only and which are set?
> 
> So far I changed the following to check check for tuner token
> before they invoke v4l2_ioctl_ops:
> 
> v4l_g_tuner()

G_TUNER should work, even if the tuner is in a different mode. See my
slides on that topic:

http://hverkuil.home.xs4all.nl/presentations/ambiguities2.odp

> v4l_s_tuner()
> v4l_s_modulator()
> v4l_s_frequency()
> v4l_s_hw_freq_seek()

Other ioctls that should claim the tuner are:

S_STD
S_INPUT
STREAMON
QUERYSTD (depends on the hardware)

Strictly speaking these ioctls only need to claim the tuner if
they capture from the tuner input, but I think in most cases you aren't
able to use a radio tuner at the same time as capturing from an S-Video
or Composite input. Usually due to the audio muxing part that switches
to a line-in jack when you start capturing video.

Once an application takes ownership of a tuner (and multiple apps can
own a tuner as long as they all want the same tuner mode), then that
application stays owner for as long as the filehandle remains open.

A tuner owner can switch tuner mode as long as there are no other owners.

And opening a radio device should take tuner ownership immediately.
Although, as I mentioned before, I think we should try to fix radio
applications so that this is no longer necessary. It's very ugly
behavior even though it is part of the V4L2 spec.

> 
> This isn't enough looks like, since I see tuner_s_std() getting
> invoked and cutting off the dvb stream.

You are right, I forgot about those ioctls. Calling S_STD, S_INPUT or
STREAMON clearly indicates that you want to switch to TV mode.

> I am currently releasing
> the tuner from v4l2_fh_exit(), but I don't think that is a good
> idea since all these ioctls are independent control paths. Each
> ioctl might have to acquire and release it at the end. More on
> this below.
> 
> For example, xawtv makes several ioctls before it even touches the
> tuner to set frequency and starting the stream. What I am looking
> for is an ioctl that would signal the intent to hold the tuner.
> Is that possible?
> 
> The question is can we identify a clean start and stop points
> for analog case for tuner ownership??

The clean start points are the ioctls listed above. The stop point is
when the filehandle is closed.

> 
> Would it make sense to treat all these ioctls as independent and
> make them acquire and release lock or hold the tuner in shared
> mode?

I don't follow what you mean.

> Shared doesn't really make sense to me since two user-space
> analog apps can interfere with each other.

This is allowed by the API. If you want to prevent other apps from
making changes, then an application should raise its priority using
S_PRIORITY. It's quite often very handy to have one application to
do the streaming and another application to switch channels/inputs.

> 
> I am trying avoid changing tuner-core and if at all possible.
> 
> I can send the code I have now for review if you like. I have the
> locking construct in a good state at the moment. dvb is in good
> shape.

I'm happy to look at it.

Regards,

	Hans

