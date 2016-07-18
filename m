Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:35048 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbcGRPQZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 11:16:25 -0400
Received: by mail-yw0-f175.google.com with SMTP id l125so162316183ywb.2
        for <linux-media@vger.kernel.org>; Mon, 18 Jul 2016 08:16:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160718150114.GC17101@phenom.ffwll.local>
References: <20160714170340.GA32755@e106950-lin.cambridge.arm.com>
 <20160715073334.GO17101@phenom.ffwll.local> <20160715090918.GB32755@e106950-lin.cambridge.arm.com>
 <20160715105715.GG4329@intel.com> <87r3auajdi.fsf@eliezer.anholt.net>
 <20160718102933.GA603@e106950-lin.cambridge.arm.com> <7d4b6836-d896-f289-f940-bf641ae8e9fb@xs4all.nl>
 <20160718150114.GC17101@phenom.ffwll.local>
From: Rob Clark <robdclark@gmail.com>
Date: Mon, 18 Jul 2016 11:16:09 -0400
Message-ID: <CAF6AEGt2vTXa49aRhYQrfTjwuC-VW=+zk9eiyAoaWuyRmsk=Fg@mail.gmail.com>
Subject: Re: DRM device memory writeback (Mali-DP)
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Daniel Vetter <daniel.vetter@ffwll.ch>, liviu.dudau@arm.com,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 18, 2016 at 11:01 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Mon, Jul 18, 2016 at 12:47:38PM +0200, Hans Verkuil wrote:
>> On 07/18/2016 12:29 PM, Brian Starkey wrote:
>> > OK, so let's talk about using connectors instead then :-)
>> >
>> > We can attach a generic fixed_mode property which can represent panel
>> > fitters or Mali-DP's writeback scaling, that sounds good.
>> >
>> > The DRM driver can create a new "virtual" encoder/connector pair, I
>> > guess with a new connector type specifically for memory-writeback?
>> > On this connector we allow the fb_id property to attach a framebuffer
>> > for writing into.
>> > We'd probably want an additional property to enable writeback, perhaps
>> > an enum: "disabled", "streaming", "oneshot".
>> >
>> > I think it makes sense to put the output buffer format, size etc.
>> > validation in the virtual encoder's atomic_check. It has access to
>> > both CRTC and connector state, and the encoder is supposed to
>> > represent the format/stream conversion element anyway.
>> >
>> > What I'm not so clear on is how to manage the API with userspace.
>>
>> I am not terribly enthusiastic (to say the least) if a new drm API is
>> created for video capture. That's what V4L2 is for and it comes with
>> kernel frameworks, documentation and utilities. Creating a new API will
>> not make userspace develoeprs happy.
>>
>> I know it is a pain to work with different subsystems, but reinventing
>> the wheel is a much bigger pain. For you and for the poor sods who have
>> to use yet another API to do the same thing.
>>
>> Of course this has to be hooked up to drm at the low level, and anything
>> that can be done to help out with that from the V4L2 side of things is
>> fine, but creating duplicate public APIs isn't the way IMHO.
>
> I agree for the streaming video use-case. But for compositors I do agree
> with Eric that a simple frame capture interface integrated with the drm
> atomic ioctl is what we want. At least my understanding of v4l is that
> it's not that well suited to grabbing specific (single) frames.

same here, we defn want to use v4l for the streaming case (so we can
take advantage of existing userspace support for
capture/encode/stream, etc)..  but for compositors, I think v4l would
be awkward.  Ideal case is single set of driver APIs, so driver
doesn't have to care so much about the use case, and then some drm_v4l
helpers to expose a v4l device for the streaming case.

There are some older patches floating around that implemented v4l
inside drm/msm.. which looked simple enough, although I don't think we
should need to do that in each drm driver..

BR,
-R
