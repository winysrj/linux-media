Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1300 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1ARHWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 02:22:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Qing Xu <qingx@marvell.com>
Subject: Re: soc-camera s_fmt question?
Date: Tue, 18 Jan 2011 08:21:57 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <AANLkTimucMmO8Vb_y4xnhehQt+mamNMmXyY_qfrVOSo7@mail.gmail.com> <201101171854.27768.hverkuil@xs4all.nl> <7BAC95F5A7E67643AAFB2C31BEE662D014040BF2AA@SC-VEXCH2.marvell.com>
In-Reply-To: <7BAC95F5A7E67643AAFB2C31BEE662D014040BF2AA@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101180821.57714.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, January 18, 2011 03:30:09 Qing Xu wrote:
> Hi,
> 
> Thanks for your answer! So, we will be waiting and keeping sync with latest soc-camera + videobuf2 framework.

Erm, just to avoid any confusion: I am *not* going to convert soc-camera
to videobuf2. I just mentioned it because if someone does, then that should
fix your problems with REQBUFS(0) (and probably STREAMON/OFF problems as well).

I think soc-camera will benefit a lot from such a move so I hope someone
(Guennadi? You?) will take on this job.

Regards,

	Hans

> 
> -Qing
> 
> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: 2011年1月18日 1:54
> To: Guennadi Liakhovetski
> Cc: Qing Xu; Laurent Pinchart; linux-media@vger.kernel.org
> Subject: Re: soc-camera s_fmt question?
> 
> On Monday, January 17, 2011 18:43:06 Guennadi Liakhovetski wrote:
> > On Mon, 17 Jan 2011, Qing Xu wrote:
> >
> > > Hi,
> > >
> > > We are now nearly complete porting our camera driver to align with
> > > soc-camera framework, however, we encounter a problem when it works with
> > > our application during switch format from preview to still capture,
> > > application's main calling sequence is as follow:
> > > 1) s_fmt /* preview @ YUV, VGA */
> > > 2) request buffer (buffer count = 6)
> > > 2) queue buffer
> > > 3) stream on
> > > 4) q-buf, dq-buf...
> > > 5) stream off
> > >
> > > 6) s_fmt /* still capture @ jpeg, 2592x1944*/
> > > 7) request buffer (buffer count = 3)
> > > 8) same as 3)->5)...
> > >
> > > The point is in soc_camera_s_fmt_vid_cap() {
> > >         if (icd->vb_vidq.bufs[0]) {
> > >                 dev_err(&icd->dev, "S_FMT denied: queue initialised\n");
> > >                 ret = -EBUSY;
> > >                 goto unlock;
> > >         }
> > > }
> > > We didn't find vb_vidq.bufs[0] be free, (it is freed in
> > > videobuf_mmap_free(), and in __videobuf_mmap_setup, but no one calls
> > > videobuf_mmap_free(), and in __videobuf_mmap_setup it is freed at first
> > > and then allocated sequentially), so we always fail at calling s_fmt.
> > > My idea is to implement soc_camera_reqbufs(buffer count = 0), to provide
> > > application opportunity to free this buffer node, refer to v4l2 spec,
> > > http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-reqbufs.html
> > > "A count value of zero frees all buffers, after aborting or finishing
> > > any DMA in progress, an implicit VIDIOC_STREAMOFF."
> >
> > Currently buffers are freed in soc-camera upon close(). Yes, I know about
> > that clause in the API spec, and I know, that it is unimplemented in
> > soc-camera. Do you have a reason to prefer that over close()ing and
> > re-open()ing the device?
> 
> I think it would be a good idea to look into converting soc_camera to the
> new videobuf2 framework that was just merged. It has much better semantics
> when it comes to allocating and freeing queues. You can actually understand
> it, something that you can't say for the old videobuf. And videobuf2 does
> the right thing with REQBUFS(0) as well.
> 
> Regards,
> 
>         Hans
> 
> >
> > Thanks
> > Guennadi
> >
> > >
> > > What do you think?
> > >
> > > Any ideas will be appreciated!
> > > Thanks!
> > > Qing Xu
> > >
> > > Email: qingx@marvell.com
> > > Application Processor Systems Engineering,
> > > Marvell Technology Group Ltd.
> > >
> >
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> --
> Hans Verkuil - video4linux developer - sponsored by Cisco
> �翳�.n�����+%��遍荻�w��.n��伐�{炳g����n�r■�����ㄨ&｛�夸z罐����zf＂������������赙z_璁�:+v�)撸�
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
