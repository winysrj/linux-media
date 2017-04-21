Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41346
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1041589AbdDURnq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 13:43:46 -0400
Date: Fri, 21 Apr 2017 14:43:32 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: RFC: Power states and VIDIOC_STREAMON
Message-ID: <20170421144332.63ef11b1@vento.lan>
In-Reply-To: <CAGoCfixZhG+9WuHgk=zfqgGbJvoggf2FyZMfVS+ifYYR+nw9rQ@mail.gmail.com>
References: <CAGoCfixZhG+9WuHgk=zfqgGbJvoggf2FyZMfVS+ifYYR+nw9rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

Em Wed, 19 Apr 2017 15:15:20 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> Hello all,
> 
> I'm in the process of putting together a bunch of long-standing fixes
> for HVR-950q driver, and I ran into a regression related to the way
> the video decoder is being managed.  Before we dig into the details
> here's the general question:
> 
> Should a user be able to interrogate video decoder properties after
> doing a tune without having first called VIDIOC_STREAMON?
> 
> A long-standing use case is to be able to use a command-line tool like
> v4l2-ctl to set the input, set the standard, issue a tuning request,
> poll for a lock status, and once you see a signal lock then start
> streaming.  This means that prior to starting streaming the tuner,
> analog demodulator, and video decoder are all running even though
> you're not actually receiving video buffers.
> 
> The problem comes down to these two patches:
> 
> https://git.linuxtv.org/media_tree.git/commit/drivers/media/dvb-frontends/au8522_decoder.c?id=38fe3510fa8fb5e75ee3b196e44a7b717d167e5d
> https://git.linuxtv.org/media_tree.git/commit/drivers/media/dvb-frontends/au8522_decoder.c?id=d289cdf022c5bebf09c73097404aa9faf2211381
> 
> Prior to these patches, I would power up the IP blocks for the analog
> demodulator and decoder when the video routing was setup (typically
> when setting the input).  However as a result of these patches
> powering up of those IP blocks is deferred until STREAMON is called.
> Hence if you just set the input and issue a tuning request, and poll
> for lock then you will never see the tuner in a locked state
> regardless of the actual signal state.
> 
> I can appreciate the motivation behind Mauro's change in wanting to
> constrain the window that the analog decoder is powered up to reduce
> the risk of having it powered up at the same time as the digital
> demodulator, but if it breaks long-standing ABI behavior then that
> probably isn't going to work.
> 
> I did take a look at the the VIDIOC_STREAMON docs, which state that
> the "Capture hardware is disabled and no buffers are filled" prior to
> calling STREAMON:
> 
> https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/vidioc-streamon.html
> 
> However that language would suggest that even the tuner would be
> powered down prior to calling STREAMON, which we know is almost never
> the case.
> 
> I suspect the ambiguity lies in what is defined by "capture hardware":
> 
> The DMA engine or other mechanism of transferring completed video
> buffers to userland?
> The DMA engine and the video decoder?
> The DMA engine, video decoder, and analog demodulator?
> The DMA engine, video decoder, analog demodulator, and tuner?
> 
> I had always interpreted it such that the STREAMON call just
> controlled whether the DMA engine was running, and thus you could do
> anything else with the decoder before calling STREAMON other than
> actually receiving video buffers.

Indeed there's an ambiguity there, although I always read that
the device's logic should keep accepting calls via both DVB
and V4L2 APIs until V4L2 streaming ioctls are issued.

That's, btw, what happens on older drivers like cx88 and bttv.

For example, on bttv, there's this logic:

static int bttv_s_fmt_vid_cap(struct file *file, void *priv,
				struct v4l2_format *f)
{
	int retval;
	const struct bttv_format *fmt;
	struct bttv_fh *fh = priv;
	struct bttv *btv = fh->btv;
	__s32 width, height;
	unsigned int width_mask, width_bias;
	enum v4l2_field field;

	retval = bttv_switch_type(fh, f->type);
	if (0 != retval)
		return retval;

The logic there actually happens earlier, at VIDIOC_S_FMT. Although I
guess all apps call it before streaming, the problem with the above is
that the V4L2 API doesn't actually make it mandatory to call this ioctl
before start streaming.

I guess that the idea of doing that at STREAMON started when we 
discussed how to lock hybrid devices via MC. I guess it was suggested
by Shuah, who looked on those issues and analyzed what apps used to do.

> My instinct would be to revert the patch in question since it breaks
> ABI behavior which has been present for over a decade, but I suspect
> such a patch would be rejected since it was Mauro himself who
> introduced the change in behavior.

It doesn't matter who committed a patch. If it is wrong, something
should be done.

However, in the specific case of a change like that, just reverting the
patch right now would make it worse, as it will break the resource locks
between FM, analog TV and digital TV, causing regressions.

Locking it at tuner get status is a bad place, as I guess that would
break locking between FM radio and analog TV, as both can read
tuner status.

Maybe one solution would be to lock the resources on either
for VIDIOC_S_FMT, VIDIOC_STREAMON or read() (whatever comes first),
but we need to check if this won't break switching between analog TV
and FM.

> I look forward to hearing from the V4L2 maintainers with regards to
> what the expected ABI behavior should be, at which point I can figure
> out how to adjust the driver code to accommodate such behavior (and if
> that means I cannot query for a signal lock prior to calling STREAMON,
> going back and changing a bunch of userland code which expects such).

Thanks,
Mauro
