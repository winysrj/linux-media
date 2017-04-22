Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:43019
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1426413AbdDVCOk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 22:14:40 -0400
Date: Fri, 21 Apr 2017 23:14:31 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: RFC: Power states and VIDIOC_STREAMON
Message-ID: <20170421231431.505e4276@vento.lan>
In-Reply-To: <CAGoCfiwSdUELXbi1Nty3dSSzjUyyzYX+Sr244xzHKDW_DM0b=A@mail.gmail.com>
References: <CAGoCfixZhG+9WuHgk=zfqgGbJvoggf2FyZMfVS+ifYYR+nw9rQ@mail.gmail.com>
        <20170421144332.63ef11b1@vento.lan>
        <CAGoCfiwSdUELXbi1Nty3dSSzjUyyzYX+Sr244xzHKDW_DM0b=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Apr 2017 14:09:37 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> >> I had always interpreted it such that the STREAMON call just
> >> controlled whether the DMA engine was running, and thus you could do
> >> anything else with the decoder before calling STREAMON other than
> >> actually receiving video buffers.  
> >
> > Indeed there's an ambiguity there, although I always read that
> > the device's logic should keep accepting calls via both DVB
> > and V4L2 APIs until V4L2 streaming ioctls are issued.  
> 
> Yeah, the hybrid use case is clearly something that didn't exist back
> then.  Most of the video decoders I've worked on (e.g. tvp5150,
> saa7115) have the device running all the time and s_stream is only
> used for output control (i.e. enable/disable the ITU-656 output).

Yeah, on most devices, switching is simpler.

> > That's, btw, what happens on older drivers like cx88 and bttv.
> >
> > For example, on bttv, there's this logic:
> >
> > static int bttv_s_fmt_vid_cap(struct file *file, void *priv,
> >                                 struct v4l2_format *f)
> > {
> >         int retval;
> >         const struct bttv_format *fmt;
> >         struct bttv_fh *fh = priv;
> >         struct bttv *btv = fh->btv;
> >         __s32 width, height;
> >         unsigned int width_mask, width_bias;
> >         enum v4l2_field field;
> >
> >         retval = bttv_switch_type(fh, f->type);
> >         if (0 != retval)
> >                 return retval;
> >
> > The logic there actually happens earlier, at VIDIOC_S_FMT. Although I
> > guess all apps call it before streaming, the problem with the above is
> > that the V4L2 API doesn't actually make it mandatory to call this ioctl
> > before start streaming.
> >
> > I guess that the idea of doing that at STREAMON started when we
> > discussed how to lock hybrid devices via MC. I guess it was suggested
> > by Shuah, who looked on those issues and analyzed what apps used to do.  
> 
> I've got a pile of changes which involve refactoring the power
> management on the au8522, but I have never thoroughly reviewed where
> Shuah ended up with the MC changes and thus it's likely they don't
> take those into account.

We had also a couple of discussions at the media summits with
regards to use MC for hybrid devices and how this was supposed
to work, besides the ML discussions.

> >> My instinct would be to revert the patch in question since it breaks
> >> ABI behavior which has been present for over a decade, but I suspect
> >> such a patch would be rejected since it was Mauro himself who
> >> introduced the change in behavior.  
> >
> > It doesn't matter who committed a patch. If it is wrong, something
> > should be done.
> >
> > However, in the specific case of a change like that, just reverting the
> > patch right now would make it worse, as it will break the resource locks
> > between FM, analog TV and digital TV, causing regressions.
> >
> > Locking it at tuner get status is a bad place, as I guess that would
> > break locking between FM radio and analog TV, as both can read
> > tuner status.  
> 
> For what it's worth, FM radio isn't supported in the au0828/au8522
> driver, so that doesn't need to be a consideration for this particular
> driver unless you're suggesting some changes to the framework common
> to all devices.

Good to know, but as other devices also support FM, we need
to define something that would be compatible with what the other
drivers implement.

> > Maybe one solution would be to lock the resources on either
> > for VIDIOC_S_FMT, VIDIOC_STREAMON or read() (whatever comes first),
> > but we need to check if this won't break switching between analog TV
> > and FM.  
> 
> I could argue that despite the PAL-M changes you made a couple of
> years ago, the device is only ever really used with a single standard
> (NTSC), and thus it's entirely possible that the user may never call
> S_FMT given the default is to capture 720x480 YUY2 and the device is
> already in that mode at initialization. 

Well, even for PAL-M, an application could, in thesis use G_FMT and, if
the format matches, don't send a S_FMT.

I guess that, in practice, all GUI Open source apps will always send 
a S_FMT ioctl (and even non-GUI apps like mplayer).

> Also, IIRC the s_stream()
> subdev callback automatically gets invoked when you do a read(), in
> order to support both MMAP and READ modes.

Yes. That's why we don't need to bother much about read(), but we need
to test if whatever patchset gets applied  it won't break support for it.

> I could suggest that it
> should be locked when you call S_INPUT, but I'm pretty sure that's how
> I had it to begin with.  Likewise even in that case you could still
> hit the issue if the user is trying to use the default input of 0
> (i.e. plug in stick, call S_FREQ, and then poll for lock).

Nothing prevents that we hook it on multiple places. I mean, whatever
gets called first (STREAMON, S_INPUT, S_FMT, REQBUFS) could put the
device into BUSY state, but we need to define what ioctls should be
hooked, and implement it on all drivers.

Ideally, v4l2-compliance should be able to test it.

> 
> No easy answers here, just trade-offs between how badly you want to
> break an API that was created with no consideration for power
> management or hybrid devices.

Ideally, it shouldn't break the API. Yet, those changes were applied
a long time ago, and nobody complained so far.

I remember I tested myself switching between analog and digital modes
with some au8522, running standard apps, and it worked fine.

Actually, I had to fix several troubles that used to happen with the
old logic, that were causing troubles when switching the channels with
tvtime and xawtv and/or when switching to DVB then returning back to
analog.

I don't remember the dirty details anymore, as this was a long time
ago.

Thanks,
Mauro
