Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:15790 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab2EBLYt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 07:24:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: halli manjunatha <manjunatha_halli@ti.com>
Subject: Re: RFC: Improve VIDIOC_S_HW_FREQ_SEEK
Date: Wed, 2 May 2012 13:24:34 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Ondrej Zary <linux@rainbow-software.org>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Tobias Lorenz <tobias.lorenz@gmx.net>,
	"Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
References: <201205011146.30295.hverkuil@xs4all.nl> <CAMT6PyeUBbfN3pQH_pofPv4HiVuXMP=f2SVXmy9BUByHeG_vqQ@mail.gmail.com>
In-Reply-To: <CAMT6PyeUBbfN3pQH_pofPv4HiVuXMP=f2SVXmy9BUByHeG_vqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205021324.34394.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 01 May 2012 18:19:39 halli manjunatha wrote:
> On Tue, May 1, 2012 at 4:46 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi all!
> >
> > While working on a test function for the hardware seek functionality in
> > v4l2-compliance I realized that the specification is rather vague and
> > incomplete, making it hard to write a decent test for it.
> >
> > There are a number of issues with this API:
> >
> > 1) There is no way for the application to know whether the hardware supports
> >   wrap around scanning or not (or both). It is only reported because the
> >   ioctl will return EINVAL if it doesn't support it, which is rather awkward.
> >   It's important for applications to know what to do here.
> >
> >   The solution would be to add two new capability flags to struct v4l2_tuner:
> >   V4L2_TUNER_CAP_SEEK_BOUNDED and V4L2_TUNER_CAP_SEEK_WRAP.
> >
> > 2) What happens when the seek didn't find anything? It's not a timeout, it has
> >   to return some decent error code. I propose ENODATA for this.
> >
> > 3) What should the frequency be if the seek returns an error? I think the original
> >   frequency should be restored in that case.
> Isn't this the way how it is now? means driver won't change the
> G_FREQUENCY value till it gets the new valid station during seek.

That's how it is done today, but that behavior is not specified in the v4l2 spec.

> 
> >
> > 4) What should happen if you try to set the frequency while a seek is in operation?
> >   In that case -EBUSY should be returned by VIDIOC_S_FREQUENCY.
> >
> > 5) What should happen if you try to get the frequency while a seek is in operation?
> >   It would be nice if you could get the frequency that is currently being scanned.
> >
> >   There are two options to implement this:
> >
> >   a) Add a new 'scan_frequency' field to struct v4l2_frequency. So the frequency
> >      field would always contain the frequency that was set when the seek started,
> >      and the scan_frequency is either 0 (no seek is in progress), a special value
> >      V4L2_SCAN_IN_PROGRESS (seek is in progress, but the hardware can't tell what
> >      the current seek frequency is) or it contains the frequency that is currently
> >      being scanned.
> >
> >   b) Add a new V4L2_TUNER_CAP_HAS_SEEK_FREQ capability to struct v4l2_tuner. If
> >      set, then VIDIOC_G_FREQUENCY will return the scan frequency when scanning,
> >      otherwise it will return the normal frequency.
> >
> >   I think I like option a) better. It gives you all the information you need.
> Even I prefer option A here.
> >
> > 6) What does it mean when you get a time out? The spec just says 'Try again'. But
> >   try what? If it times out due to hardware issues, then a proper error should be
> >   returned. That leaves a time out due to the scan not finding any channels, but not
> >   reaching the end of the scan either (because that would be a ENODATA return code).
> >
> >   What should be the frequency in this case? The original frequency or the last
> >   scanned frequency? And on older hardware you may not be able to get that last scanned
> >   frequency.
> >
> >   I suggest one of two options:
> >
> >   a) Abolish the time out altogether. The driver author has to set the internal
> >      timeout to such a large value that if you time out, then you can just return
> >      -ENODATA.
> >
> >   b) Hardware that cannot detect the current scan frequency behaves as a). Hardware
> >      that can detect the scan frequency will return -EAGAIN, but sets the frequency
> >      at the last scanned frequency.

Do you have any opinion/insights into this?

Regards,

	Hans

> >
> > 7) It would be nice if the ioctl was RW instead of just a write ioctl. That way the
> >   driver could report the proper spacing value that it used. I'm not entirely sure
> >   it is worth the effort at this moment though.
> >
> > Comments? Questions?
> >
> > Regards,
> >
> >        Hans
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
