Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56415 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbZKMOwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 09:52:32 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>
Date: Fri, 13 Nov 2009 08:52:36 -0600
Subject: RE: [PATCH 6/6] TVP514x:Switch to automode for s_input/querystd
Message-ID: <A69FA2915331DC488A831521EAE36FE40155937055@dlee06.ent.ti.com>
References: <hvaibhav@ti.com> <200911091339.52771.hverkuil@xs4all.nl>
 <19F8576C6E063C45BE387C64729E73940436F94106@dbde02.ent.ti.com>
 <200911100835.45013.hverkuil@xs4all.nl>
In-Reply-To: <200911100835.45013.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

IMO, querystd() should make use of the auto mode to detect the current
standard and is internal to the driver how it achieves that. Also I agree
that locking the standard while streaming is ongoing and reverting back
to auto mode when it stops is okay based on the use cases that I have
come across. Same is true for TVP7002 which does query preset. 

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>Sent: Tuesday, November 10, 2009 2:36 AM
>To: Hiremath, Vaibhav
>Cc: linux-media@vger.kernel.org; Jadav, Brijesh R; Karicheri, Muralidharan
>Subject: Re: [PATCH 6/6] TVP514x:Switch to automode for s_input/querystd
>
>On Tuesday 10 November 2009 06:49:55 Hiremath, Vaibhav wrote:
>>
>> > -----Original Message-----
>> > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>> > Sent: Monday, November 09, 2009 6:10 PM
>> > To: Hiremath, Vaibhav
>> > Cc: linux-media@vger.kernel.org; Jadav, Brijesh R; Karicheri,
>> > Muralidharan
>> > Subject: Re: [PATCH 6/6] TVP514x:Switch to automode for
>> > s_input/querystd
>> >
>> > Hi Vaibhav,
>> >
>> > See the review comments below.
>> >
>> > On Tuesday 13 October 2009 17:12:59 hvaibhav@ti.com wrote:
>> > > From: Vaibhav Hiremath <hvaibhav@ti.com>
>> > >
>> > > Driver should switch to AutoSwitch mode on S_INPUT and QUERYSTD
>> > ioctls.
>> > > It has been observed that, if user configure the standard
>> > explicitely
>> > > then driver preserves the old settings.
>> > >
>> > > Reviewed by: Vaibhav Hiremath <hvaibhav@ti.com>
>> > > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
>> > > ---
>> > >  drivers/media/video/tvp514x.c |   17 +++++++++++++++++
>> > >  1 files changed, 17 insertions(+), 0 deletions(-)
>> > >
>> > > diff --git a/drivers/media/video/tvp514x.c
>> > b/drivers/media/video/tvp514x.c
>> > > index 2443726..0b0412d 100644
>> > > --- a/drivers/media/video/tvp514x.c
>> > > +++ b/drivers/media/video/tvp514x.c
>> > > @@ -523,10 +523,18 @@ static int tvp514x_querystd(struct
>> > v4l2_subdev *sd, v4l2_std_id *std_id)
>> > >  	enum tvp514x_std current_std;
>> > >  	enum tvp514x_input input_sel;
>> > >  	u8 sync_lock_status, lock_mask;
>> > > +	int err;
>> > >
>> > >  	if (std_id == NULL)
>> > >  		return -EINVAL;
>> > >
>> > > +	err = tvp514x_write_reg(sd, REG_VIDEO_STD,
>> > > +			VIDEO_STD_AUTO_SWITCH_BIT);
>> > > +	if (err < 0)
>> > > +		return err;
>> > > +
>> > > +	msleep(LOCK_RETRY_DELAY);
>> > > +
>> >
>> > We have a problem here with the V4L2 spec.
>> >
>> > The spec says that the standard should not change unless set
>> > explicitly by
>> > the user. So switching to auto mode in querystd is not correct.
>> >
>> [Hiremath, Vaibhav] Hans, I have added this considering that; querystd
>means auto-detection of standard.
>>
>> V4L2 spec says that, Sense the video standard received by the current
>input.
>>
>> When user explicitly calls querystd, don't you think user should be aware
>of the fact that, driver is going to detect the standard automatically
>under this call.
>
>The spec is very silent about that :-)
>
>Perhaps we should modify the documentation and add one additional clause:
>
>QUERYSTD might return -EBUSY when capture is in progress depending on the
>driver.
>
>With this in place we can put the tvp514x in autodetect mode as long as
>there
>is no streaming going on. When streaming is started the tvp514x is set to
>the
>last selected S_STD standard and kept there until streaming stops, at which
>time it goes back to autodetect.
>
>Calling QUERYSTD while streaming will return -EBUSY.
>
>This makes sense to me.
>
>> > Is it possible to detect the standard without switching to automode?
>> > If it is,
>> > then that's the preferred solution.
>> >
>> [Hiremath, Vaibhav] We can detect based on the TVP_VIDEO_STD_STATUS
>register, but will not be auto-detection. We will be reading the standard
>set by previous ioctls.
>>
>> > If it cannot be done, then we need to extend the API and add support
>> > for a
>> > proper way of enabling automode.
>> >
>> > This is actually a long standing issue that used to be pretty low
>> > prio since
>> > it is very rare to see 'spontaneous' switches from e.g. PAL to NTSC.
>> >
>> > But with the upcoming timings API for HDTV this will become much
>> > more common.
>> > (e.g. switching from 1080p to 720p).
>> >
>> > We need to define this quite carefully. In particular what will
>> > happen if the
>> > standard switches while streaming. How does that relate to a scaler
>> > setup with
>> > S_FMT? Do we know when this happens so that we can notify the
>> > application?
>> [Hiremath, Vaibhav] At-least in TVP5146 we have interrupt which we can
>enable on standard change from user on current input, but we are not using
>it. This could be another interesting point, how to add such support.
>>
>> > Can we lock the standard when starting capturing?
>> [Hiremath, Vaibhav] I think this makes sense to me, we should not allow
>changing the standard once streaming is going on.
>>
>> I think event manager may play a major role here, on standard change we
>should be able to send event back to application. Now the question is how
>application is going to handle this, since currently there is not way
>application can specify AUTOMODE, he has to query the standard and set it
>again.
>
>I don't think this is an issue for this device. And for HDTV devices we
>have
>to wait and see how that will work out.
>
>Regards,
>
>	Hans
>
>>
>> Thanks,
>> Vaibhav
>> >
>> > My gut feeling is that AUTO detect should only be allowed if the
>> > application
>> > can be notified when the standard changes, or if the standard can be
>> > locked
>> > when streaming starts.
>> >
>> > The second part that is needed is some way to set the receiver into
>> > auto
>> > switching mode. For SDTV that probably means adding a new AUTO
>> > standard bit.
>> > Although to be honest I'm not keen on having to add something to
>> > v4l2_std_id.
>> >
>> > For the HDTV timings API we probably need to add an AUTO preset.
>> >
>> > Murali, can you think about this a bit and see how that will work
>> > out?
>> >
>> > >  	/* get the current standard */
>> > >  	current_std = tvp514x_get_current_std(sd);
>> > >  	if (current_std == STD_INVALID)
>> > > @@ -643,6 +651,15 @@ static int tvp514x_s_routing(struct
>> > v4l2_subdev *sd,
>> > >  		/* Index out of bound */
>> > >  		return -EINVAL;
>> > >
>> > > +	/* Since this api is goint to detect the input, it is required
>> > > +	   to set the standard in the auto switch mode */
>> > > +	err = tvp514x_write_reg(sd, REG_VIDEO_STD,
>> > > +			VIDEO_STD_AUTO_SWITCH_BIT);
>> >
>> > Huh? I don't see what s_routing has to do with auto switch mode.
>> >
>> > > +	if (err < 0)
>> > > +		return err;
>> > > +
>> > > +	msleep(LOCK_RETRY_DELAY);
>> > > +
>> > >  	input_sel = input;
>> > >  	output_sel = output;
>> > >
>> > > --
>> > > 1.6.2.4
>> > >
>> >
>> > Regards,
>> >
>> > 	Hans
>> >
>> >
>> > --
>> > Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>>
>>
>>
>>
>
>
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

