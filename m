Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40337 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292Ab0CBUml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Mar 2010 15:42:41 -0500
Received: by bwz1 with SMTP id 1so104304bwz.21
        for <linux-media@vger.kernel.org>; Tue, 02 Mar 2010 12:42:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201003022128.06210.hverkuil@xs4all.nl>
References: <829197381002281856o749e3e9al36334b8b42b34562@mail.gmail.com>
	 <49ae9be6ffaaac102dc02f94f2fd047c.squirrel@webmail.xs4all.nl>
	 <829197381003010220w57248cb2l636a75d5bf4b19c1@mail.gmail.com>
	 <201003022128.06210.hverkuil@xs4all.nl>
Date: Tue, 2 Mar 2010 15:42:39 -0500
Message-ID: <829197381003021242p1ae9d91ek68e2c063024d316@mail.gmail.com>
Subject: Re: How do private controls actually work?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 2, 2010 at 3:28 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> I will NAK it only because you use V4L2_CID_PRIVATE_BASE. The rest of the
> code is fine. It would be sufficient to create a private user control like
> this:
>
> #define V4L2_CID_SAA7115_BASE           (V4L2_CTRL_CLASS_USER | 0x1000)
> #define V4L2_CID_SAA7115_CHROMA_GAIN    (V4L2_CID_SAA7115_BASE+0)

Easy enough.

>> And exactly what "class" of extended controls should I use for video
>> decoders?  It would seem that a video decoder doesn't really fall into
>> any of the existing categories - "Old-style user controls", "MPEG
>> compression controls", "Camera controls", or "FM modulator controls".
>> Are we saying that now I'm also going to be introducing a whole new
>> class of control too?
>
> CHROMA_AGC is a user control. And setting the CHROMA_GAIN should be in that
> same class. It makes no sense to use two different classes for this.

Ok, I wasn't sure if "user control" was really synonymous with "video
decoder", nor was I sure if you were suggesting whether the "user
control" section was exclusively for the legacy controls (and not
accepting new controls).

>> > The EXT_G/S_CTRLS ioctls do not accept PRIVATE_BASE because I want to
>> > force driver developers to stop using PRIVATE_BASE. So only G/S_CTRL will
>> > support controls in that range for backwards compatibility.
>>
>> While we're on the topic, do you see any problem with the proposed fix
>> for the regression you introduced?:
>>
>> http://kernellabs.com/hg/~dheitmueller/em28xx-test/rev/142ae5aa9e8e
>
> No problems at all. That's the correct fix.
>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Great, I'll add your Ack to the patch.

>>
>> Between trying to figure out what the expected behavior is supposed to
>> be (given the complete lack of documentation on how private controls
>> are expected to be implemented in the extended controls API) and
>> isolating and fixing the regression, it's hard not to be a little
>> irritated at this situation.  This was supposed to be a very small
>> change - a single private control to a mature driver.  And now it
>> seems like I'm going to have to extend the basic infrastructure in the
>> decoder driver, the bridge driver, add a new class of controls, all so
>> I can poke one register?
>
> As you can see it is not that bad. That said, there is one disadvantage:
> the em28xx driver does not support the V4L2_CTRL_FLAG_NEXT_CTRL that is needed
> to enumerate this private user control. I do not know whether you need it since
> you can still get and set the control, even if you can't enumerate it.

It's funny though.  I haven't looked at that part of the code
specifically, but the em28xx driver does appear to show private
controls in the output of the queryctrl() command (at least it is
showing up in the output of "v4l2-ctl -l".  Are there two different
APIs for enumerating controls?

> Unfortunately implementing this flag is non-trivial. We are missing code that
> can administrate all the controls, whether they are from the main host driver
> or from subdev drivers. The control framework that I'm working should handle
> that, but it's not there yet. There is a support function in v4l2-common.c,
> though: v4l2_ctrl_next(). It works, but it requires that bridge drivers know
> which controls are handled by both the bridge driver and all subdev drivers.
> That's not ideal since bridge drivers shouldn't have to know that from subdev
> drivers.
>
> Looking at the em28xx driver I think that supporting V4L2_CTRL_FLAG_NEXT_CTRL
> in em28xx is too much work. So for the time being I think we should support
> both a CHROMA_GAIN control using the old PRIVATE_BASE offset, and the proper
> SAA7115_CHROMA_GAIN control. Once we have a working framework, then the
> PRIVATE_BASE variant can be removed.

I had some extended discussion with Mauro on this yesterday on
#linuxtv, and he is now in favor of introducing a standard user
control for chroma gain, as opposed to doing a private control at all.

> I find all this just as irritating as you, but unfortunately I cannot conjure
> up the time I need to finish it out of thin air :-( This part of the V4L2 API
> is actually quite complex to correctly implement in drivers. So there is little
> point in modifying individual drivers. Instead we just will have to wait for
> the control framework to arrive.

Yeah, I understand.  Thanks for taking the time to help clarify how
this stuff is intended to wrok.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
