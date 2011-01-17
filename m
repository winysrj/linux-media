Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4962 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab1AQHsu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 02:48:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [RFC/PATCH v6 0/4] Multi Format Codec 5.1 driver for S5PC110 SoC
Date: Mon, 17 Jan 2011 08:48:17 +0100
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>, pawel@osciak.com,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com
References: <1294417534-3856-1-git-send-email-k.debski@samsung.com> <201101170759.29752.hverkuil@xs4all.nl> <000401cbb619$1b9f1840$52dd48c0$%debski@samsung.com>
In-Reply-To: <000401cbb619$1b9f1840$52dd48c0$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101170848.17908.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, January 17, 2011 08:35:21 Kamil Debski wrote:
> Hi Hans,
> 
> > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > Hi Kamil,
> > 
> > I still need to review this carefully since this is the first codec
> > driver.
> > I had hoped to do this during the weekend, but I didn't manage it. I
> > hope I
> > can get to it on Friday.
> 
> This would be great.
>  
> > One thing I noticed: you aren't using the control framework in this
> > driver.
> > Please switch to that. From now on I will NACK any new driver that is
> > not
> > using that framework. I'm in the process of converting all existing
> > drivers
> > to it, and I don't want to have to fix new drivers as well :-)
> > 
> > Documentation is in Documentation/video4linux/v4l2-controls.txt.
> > 
> 
> I am aware of that. I think my reply to one of your previous comments might
> have got lost in your inbox.
> 
> I have doubts about the point of using the control framework in my case.
> I agree with you that for the majority of drivers it will be very useful.
> In case of MFC or mem2mem FIMC - those two drivers use per file handle
> contexts and that's the thing that stops me from using your framework. 
> 
> If I understand the control framework correctly, there is no support for
> such use case. When S_CTRL is run on an MFC driver then the value passed
> to the driver is stored in s5p_mfc_ctx structure instead of writing this to
> hardware directly. This value is then used, when it is necessary to setup
> hardware. For example before running codec initialization for that context.
> 
> In case of the control framework, the I could implement my .s_ctrl
> callback which sets the appropriate field in s5p_mfc_ctx structure.
> The thing I don't like about this is the redundancy of storing the control
> value. In the one instance scenario it is stored in the driver in
> s5p_mfc_ctx
> and in the control fw. In multiple instance scenario the values in
> s5p_mfc_ctx
> and in the control fw will be different. I know that there are volatile
> controls in the framework, but in this case all controls would have to be
> volatile.
> 
> Correct me if I am wrong, but I don't see that the control framework is for
> mem2mem drivers that can have multiple contexts. Again, I agree with you
> that it is generally a good idea, but not for every driver. I am open to
> discuss this use case with you - maybe some functionality could be added
> to the control framework?

Normally the struct v4l2_ctrl_handler is put in either the top-level device
structure (a global handler) or it is per-device node. But there is nothing
preventing you from doing this per-filehandle.

However, a small change will be needed to the v4l framework since right now
it assumes that struct video_device has a pointer to the corresponding control
handler. This should be moved down to struct v4l2_fh.

So struct v4l2_fh should get a pointer to a v4l2_ctrl_handler. If not set, then
it will use any value set in video_device. And v4l2-ioctl.c should use the
struct v4l2_fh control handler pointer if available.

These changes are very minor and then you can use per-filehandle controls.

The reason why I want drivers to use this is that it is next to impossible to
write full-featured and correct control handling code without it. I've been
implementing control API tests to v4l2-compliance and it is depressing to see
how few drivers actually do the right thing.

Regards,

	Hans

> 
> Best wishes,
> --
> Kamil Debski
> Linux Platform Group
> Samsung Poland R&D Center
> 
> > 
> > On Friday, January 07, 2011 17:25:30 Kamil Debski wrote:
> > > Hello,
> > >
> > > This is the sixth version of the MFC 5.1 driver, decoding part. The
> > suggestions
> > > and comments from the group members have been very helpful.
> > >
> > > I would be grateful for your comments. Original cover letter ant
> > detailed change
> > > log has been attached below.
> > >
> > > Best regards,
> > > Kamil Debski
> 
> <snip>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
