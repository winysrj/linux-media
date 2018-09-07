Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:39468 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbeIGTAB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2018 15:00:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: jacopo mondi <jacopo@jmondi.org>,
        "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v2 5/5] media: ov5640: fix restore of last mode set
Date: Fri, 07 Sep 2018 17:18:56 +0300
Message-ID: <2363168.XP4MAGOgOS@avalon>
In-Reply-To: <3ad25a94-3de0-1a9a-ff02-30d3d282b363@st.com>
References: <1534155586-26974-1-git-send-email-hugues.fruchet@st.com> <20180816101023.GA19047@w540> <3ad25a94-3de0-1a9a-ff02-30d3d282b363@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hugues,

On Thursday, 16 August 2018 18:07:54 EEST Hugues FRUCHET wrote:
> On 08/16/2018 12:10 PM, jacopo mondi wrote:
> > On Mon, Aug 13, 2018 at 12:19:46PM +0200, Hugues Fruchet wrote:
> > 
> >> Mode setting depends on last mode set, in particular
> >> because of exposure calculation when downscale mode
> >> change between subsampling and scaling.
> >> At stream on the last mode was wrongly set to current mode,
> >> so no change was detected and exposure calculation
> >> was not made, fix this.
> > 
> > I actually see a different issue here...
> 
> Which problem do you have exactly, you got a VGA JPEG instead of a QVGA 
> YUYV ?
> 
> > The issue I see here depends on the format programmed through
> > set_fmt() never being applied when using the sensor with a media
> > controller equipped device (in this case an i.MX6 board) through
> > capture sessions, and the not properly calculated exposure you see may
> > be a consequence of this.
> > 
> > I'll try to write down what I see, with the help of some debug output.
> > 
> > - At probe time mode 640x460@30 is programmed:
> > 
> >    [    1.651216] ov5640_probe: Initial mode with id: 2
> > 
> > - I set the format on the sensor's pad and it gets not applied but
> >    marked as pending as the sensor is powered off:
> > 
> >    #media-ctl --set-v4l2 "'ov5640 2-003c':0[fmt:UYVY2X8/320x240
> >    field:none]"
> >     [   65.611983] ov5640_set_fmt: NEW mode with id: 1 - PENDING
> 
> So here sensor->current_mode is set to <1>;//QVGA
> and sensor->pending_mode_change is set to true;
> 
> > - I start streaming with yavta, and the sensor receives a power on;
> >    this causes the 'initial' format to be re-programmed and the pending
> >    change to be ignored:
> > 
> >    #yavta -c10 -n4 -f YUYV -s $320x240  -F"../frame-#.yuv" /dev/video4
> >    
> >     [   69.395018] ov5640_set_power:1805 - on
> >     [   69.431342] ov5640_restore_mode:1711
> >     [   69.996882] ov5640_set_mode: Apply mode with id: 0
> > 
> >    The 'ov5640_set_mode()' call from 'ov5640_restore_mode()' clears the
> >    sensor->pending flag, discarding the newly requested format, for
> >    this reason, at s_stream() time, the pending flag is not set
> >    anymore.
> 
> OK but before clearing sensor->pending_mode_change, set_mode() is
> loading registers corresponding to sensor->current_mode:
> static int ov5640_set_mode(struct ov5640_dev *sensor,
> 			   const struct ov5640_mode_info *orig_mode)
> {
> ==>	const struct ov5640_mode_info *mode = sensor->current_mode;
> ...
> 	ret = ov5640_set_mode_direct(sensor, mode, exposure);
> 
> => so mode <1> is expected to be set now, so I don't understand your trace:
> ">     [   69.996882] ov5640_set_mode: Apply mode with id: 0"
> Which variable do you trace that shows "0" ?
> 
> > Are you using a media-controller system? I suspect in non-mc cases,
> > the set_fmt is applied through a single power_on/power_off session, not
> > causing the 'restore_mode()' issue. Is this the case for you or your
> > issue is differnt?
> > 
> > Edit:
> > Mita-san tried to address the issue of the output pixel format not
> > being restored when the image format was restored in
> > 19ad26f9e6e1 ("media: ov5640: add missing output pixel format setting")
> > 
> > I understand the issue he tried to fix, but shouldn't the pending
> > format (if any) be applied instead of the initial one unconditionally?
> 
> This is what does the ov5640_restore_mode(), set the current mode 
> (sensor->current_mode), that is done through this line:
> 	/* now restore the last capture mode */
> 	ret = ov5640_set_mode(sensor, &ov5640_mode_init_data);
> => note that the comment above is weird, in fact it is the "current" 
> mode that is set.
> => note also that the 2nd parameter is not the mode to be set but the 
> previously applied mode ! (ie loaded in ov5640 registers). This is used
> to decide if we have to go to the "set_mode_exposure_calc" or 
> "set_mode_direct".
> 
> the ov5640_restore_mode() also set the current pixel format 
> (sensor->fmt), that is done through this line:
> 	return ov5640_set_framefmt(sensor, &sensor->fmt);
> ==> This is what have fixed Mita-san, this line was missing previously, 
> leading to "mode registers" being loaded but not the "pixel format 
> registers".

This seems overly complicated to me. Why do we have to set the mode at power 
on time at all, why can't we do it at stream on time only, and simplify all 
this logic ?

> PS: There are two other "set mode" related changes that are related to
> this:
> 1) 6949d864776e ("media: ov5640: do not change mode if format or
> frame interval is unchanged")
> => this is merged in media master, unfortunately I've introduced a 
> regression on "pixel format" side that I've fixed in this patchset :
> 2) https://www.mail-archive.com/linux-media@vger.kernel.org/msg134413.html
> Symptom was a noisy image when capturing QVGA YUV (in fact captured as 
> JPEG data).

[snip]

-- 
Regards,

Laurent Pinchart
