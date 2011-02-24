Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55327 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab1BXUUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 15:20:25 -0500
Received: by fxm17 with SMTP id 17so944686fxm.19
        for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 12:20:23 -0800 (PST)
Subject: Re: [st-ericsson] v4l2 vs omx for camera
From: Edward Hervey <bilboed@gmail.com>
To: Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	ST-Ericsson LT Mailing List <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
Date: Thu, 24 Feb 2011 21:19:48 +0100
In-Reply-To: <AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com>
	 <AANLkTinDFMMDD-F-FsccCTvUvp6K3zewYsGT1BH9VP1F@mail.gmail.com>
	 <201102100847.15212.hverkuil@xs4all.nl>
	 <201102171448.09063.laurent.pinchart@ideasonboard.com>
	 <AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1298578789.821.54.camel@deumeu>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Fri, 2011-02-18 at 17:39 +0100, Robert Fekete wrote:
> Hi,
> 
> In order to expand this knowledge outside of Linaro I took the Liberty
> of inviting both linux-media@vger.kernel.org and
> gstreamer-devel@lists.freedesktop.org. For any newcomer I really
> recommend to do some catch-up reading on
> http://lists.linaro.org/pipermail/linaro-dev/2011-February/thread.html
> ("v4l2 vs omx for camera" thread) before making any comments. And sign
> up for Linaro-dev while you are at it :-)
> 
> To make a long story short:
> Different vendors provide custom OpenMax solutions for say Camera/ISP.
> In the Linux eco-system there is V4L2 doing much of this work already
> and is evolving with mediacontroller as well. Then there is the
> integration in Gstreamer...Which solution is the best way forward.
> Current discussions so far puts V4L2 greatly in favor of OMX.
> Please have in mind that OpenMAX as a concept is more like GStreamer
> in many senses. The question is whether Camera drivers should have OMX
> or V4L2 as the driver front end? This may perhaps apply to video
> codecs as well. Then there is how to in best of ways make use of this
> in GStreamer in order to achieve no copy highly efficient multimedia
> pipelines. Is gst-omx the way forward?
> 
> Let the discussion continue...
> 

  I'll try to summarize here my perspective from a GStreamer point of
view. You wanted some, here it is :) This is a summary to answering
everything in this mail thread at this time. You can go straight to the
last paragraphs for a summary.

  The question to be asked, imho, is not "omx or v4l2 or gstreamer", but
rather "What purpose does each of those API/interface serve, when do
they make sense, and how can they interact in the most efficient way
possible"

  Looking at the bigger picture, the end goal to all of us is to make
best usage of what hardware/IP/silica is available all the way up to
end-user applications/use-cases, and do so in the most efficient way
possible (whether in terms of memory/cpu/power usage at the lower
levels, but also in terms of manpower and flexibility at the higher
levels).

  Will GStreamer be as cpu/memory efficient as a pure OMX solution ? No,
I seriously doubt we'll break down all the fundamental notions in
GStreamer to make it use 0 cpu when running some processing.

  Can GStreamer provide higher flexibility than a pure OMX solution ?
Definitely, unless you have all the plugins for accesing all other hw
systems out there,  (de)muxers, rtp (de)payloaders, jitter buffers,
network components, auto-pluggers, convenience elements, application
interaction that GStreamer has been improving over the past 10 years.
All that is far from trivial.
  And as Rob Clark said that you could drop HW specific gst plugins in
and have it work with all existing applications, the same applies to all
the other peripheral existing *and* future plugins you need to make a
final application. So there you benefit from all the work done from the
non-hw-centric community.

  Can we make GStreamer use as little cpu/overhead as possible without
breaking the fundamental concepts it provides ? Definitely.
  There are quite a few examples out there of zero-memcpy gst plugins
wrapping hw accelerated systems for a ridiculous amount of cpu (they
just take a opaque buffer and pass it down. That's 300-500 cpu
instructions for a properly configured setup if my memory serves me
right). And efforts have been going on for the past 2 years to carry on
to make GStreamer overall consume as little cpu as possible, making it
as lockless as possible and so forth. The undergoing GStreamer 0.11/1.0
effort will allow breaking down even more barriers for even more
efficient usage.

  Can OMX provide a better interface than v4l2 for video sources ?
Possible, but doubtful, The V4L2 people have been working at it for ages
and works for a *lot* of devices out there. It is the interface one
expects to use on Linux based systems, you write your kernel drivers
with a v4l2 interface and people can use it straight away on any linux
setup.

  Do Hardware/Silica vendors want to write kernel/userspace drivers for
their hw-accelerated codecs in all variants available out there ? No
way, they've got better things to do, they need to chose one.
  Is OMX the best API out there for providing hw-accelerated codecs ?
Not in my opinion. Efforts like libva/vdpau are better in that regards,
but for most ARM SoC ... OMX is the closest thing to a '''standard'''.
And they (Khronos) don't even provide reference implementations, so you
end up with a bunch of header files that everybody {mis|ab}uses.



  So where does this leave us ?

  * OMX is here for HW-accelerated codecs and vendors are doubtfully
going to switch from it, but there are other system popping up that will
use other APIs (libva, vdpau, ...).
  * V4L2 has an long standing and evolving interface people expect for
video sources on linux-based systems. Making OMX provide an
as-robust/tested interface as that is going to be hard.
  * GStreamer can wrap all existing APIs (including the two mentionned
above), adds the missing blocks to go from standalone components to
full-blown future-looking applications/use-cases.

  * The main problem... is making all those components talk to eachother
in the most cpu/mem efficient way possible.

  No, GStreamer can't solve all of that last problem. We are working
hard on reducing as much as possible the overhead GStreamer brings in
while offering the most flexible solution out there and you can join in
making sure the plugins exposing those various APIs mentionned above
make the best usage of it. There is a point where we are going to reach
our limit.

  What *needs* to be solved is an API for data allocation/passing at the
kernel level which v4l2,omx,X,GL,vdpau,vaapi,... can use and that
userspace (like GStreamer) can pass around, monitor and know about.
  That is a *massive* challenge on its own. The choice of using
GStreamer or not ... is what you want to do once that challenge is
solved.

  Regards,

    Edward

P.S. GStreamer for Android already works :
http://www.elinux.org/images/a/a4/Android_and_Gstreamer.ppt

