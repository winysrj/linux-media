Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41767 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbZCaFKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 01:10:49 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"R, Sivaraj" <sivaraj@ti.com>, "Hadli, Manjunath" <mrh@ti.com>,
	"Shah, Hardik" <hardik.shah@ti.com>,
	"Kumar, Purushotam" <purushotam@ti.com>
Date: Tue, 31 Mar 2009 10:40:26 +0530
Subject: RE: [RFC] Stand-alone Resizer/Previewer Driver support under V4L2
 framework
Message-ID: <19F8576C6E063C45BE387C64729E73940427E3F7E8@dbde02.ent.ti.com>
References: <19F8576C6E063C45BE387C64729E73940427E3F70B@dbde02.ent.ti.com>
 <A24693684029E5489D1D202277BE89442E9030C0@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89442E9030C0@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Aguirre Rodriguez, Sergio Alberto
> Sent: Monday, March 30, 2009 9:10 PM
> To: Hiremath, Vaibhav; linux-media@vger.kernel.org
> Cc: DongSoo(Nathaniel) Kim; Toivonen Tuukka.O (Nokia-D/Oulu); linux-
> omap@vger.kernel.org; Nagalla, Hari; Sakari Ailus; Hans Verkuil;
> Jadav, Brijesh R; R, Sivaraj; Hadli, Manjunath; Shah, Hardik; Kumar,
> Purushotam
> Subject: RE: [RFC] Stand-alone Resizer/Previewer Driver support
> under V4L2 framework
> 
> Hi Vaibhav,
> 
> Please find some comments below
> 
> > -----Original Message-----
> > From: Hiremath, Vaibhav
> > Sent: Monday, March 30, 2009 8:35 AM
> > To: linux-media@vger.kernel.org
> > Cc: Aguirre Rodriguez, Sergio Alberto; DongSoo(Nathaniel) Kim;
> Toivonen
> > Tuukka.O (Nokia-D/Oulu); linux-omap@vger.kernel.org; Nagalla,
> Hari; Sakari
> > Ailus; Hans Verkuil; Jadav, Brijesh R; R, Sivaraj; Hadli,
> Manjunath; Shah,
> > Hardik; Kumar, Purushotam
> > Subject: [RFC] Stand-alone Resizer/Previewer Driver support under
> V4L2
> > framework
> >
> > Hi,
> >
> > With reference to the mail-thread started by Sakari on Resizer
> driver
> > interface,
> >
> > http://marc.info/?l=linux-omap&m=123628392325716&w=2
> >
> > I would like to bring some issues and propose changes to adapt
> such
> > devices under V4L2 framework. Sorry for delayed response on this
> mail-
> > thread, actually I was on vacation.
> >
> > As proposed by Sakari, I do agree with the approach of having V4L2
> > interface for memory-to-memory operation of the ISP (like resizer
> and
> > previewer), but I would like to bring some important
> aspects/issues here -
> >
> > 	- Some drawbacks of V4L2-buf layer framework for such kind of
> > devices
> > 	- Need for backward compatibility.
> >
> > Drawbacks for V4L2-Buf layer -
> > -----------------------------
> >
> > 1} In case of resizer driver, the input buffer will always be
> different
> > than output buffer.
> >
> > In case of Mmapped buffer there is no issue, since driver
> allocates
> > maximum of input and output. User doesn't have control on this,
> although
> > there is loss of memory from system point of view.
> >
> > In case of User Pointer Exchange, User would expect and may
> allocate
> > different sizes of buffers for input and output which V4L2-buf
> layer
> > doesn't support with single queue. And to address this, I think
> here we
> > need to have either of following approaches -
> >
> > 	- Use two separate buffer queues, one for input and another
> for
> > output.
> > 	- Or hack the driver for v4l2_buffer, internally using
> different
> > buffer params for input and output. [Not recommended]
> >
> > Please note that sometimes application receives buffers from
> another
> > driver or from some codecs engine that's why input and output
> buffer will
> > never be of same size.
> >
> > 2) V4L2-buf layer doesn't support IOMEM coming from user
> application. Just
> > to give low level details about this -
> >
> > When application tries to configure for 'V4L2_MEMORY_USERPTR' with
> buffer
> > coming from another driver (which is iomampped), then QUEUEBUF
> ioctl will
> > fail from 'videobuf_iolock' --> videobuf_dma_init_user_locked -->
> > get_user_pages.
> >
> > In 'get_user_pages' it checks for IOMEM flag and returns error,
> which is
> > expected behavior from Kernel point of view. We are trying to map
> buffer
> > which is already mapped to kernel by another driver.
> 
> I'm not sure if I understood the problem right... Can you please
> help me clarify?
> 
> So, basically the problem is that both drivers needs to associate a
> single buffer with 2 different DMA transfers at the same time (one
> from other driver, and other from ISP) Is that correct?
> 
[Hiremath, Vaibhav] No, 

Let's take real-time example here, say you have 128 Mb DDR available with you and you have asked linux to use only say 80Mb. And rest of the memory you are mapping to kernel from some another driver using ioremap.

This is valid use-case, since most of application does this due to memory fragmentation.

Now you want to use this ioremapped buffer for your capture driver as a use pointer exchange mechanism. And here it fails due to issues as I explained before.

> >
> > One thing I am not able to understand, how nobody came across such
> use-
> > case which is very common. And to address this issue we need to
> add
> > support for IOMEM in V4L2-buf layer.
> >
> > NOTE: Currently both of these issues have been addressed as a
> custom
> > implementation for our internal use case.
> >
> > Backward Compatibility -
> > -----------------------
> >
> > This is an important aspect, since similar hardware modules are
> available
> > on Davinci as well as on OMAP and their driver interface is
> completely
> > different.
> >
> > On Davinci, resizer driver is supported through plane char driver
> > interface which handles all data/buffer processing and control
> paths. It
> > maintains internal queue for priority of resizing tasks and stuff.
> >
> > The driver is present under /drivers/char/Davinci.
> >
> > Here I feel, V4L2 way is better, since all image processing
> drivers should
> > go under "drivers/media/video/". And again we can make use of
> readily
> > available V4L2 framework interface for data and control path to
> manage
> > buffers. We should enhance V4L2 framework to support such devices.
> >
> >
> > Proposed Required Changes -
> > --------------------------
> >
> > I am putting some high level changes required to be done for
> supporting
> > such devices -
> >
> > 	- Enhancement in V4L2-buf layer for above issues
> >
> > 	- Will be directly using sub-device frame-work and have to
> enhance
> > it to support such devices.
> >
> > 	- Below are the parameters we need to configure for Resizer
> from
> > user application -
> >
> >   __s32 in_hsize;    /* input frame horizontal size.*/
> >   __s32 in_vsize;    /* input frame vertical size */
> >   __s32 in_pitch;    /* offset between 2 rows of input frame.*/
> >   __s32 inptyp;      /* for determining 16 bit or 8 bit data.*/
> >   __s32 vert_starting_pixel; /* vertical starting pixel in
> input.*/
> >   __s32 horz_starting_pixel; /* horizontal starting pixel in
> input.*/
> >   __s32 cbilin;      /* filter with luma or bi-linear
> interpolation.*/
> >   __s32 pix_fmt;     /* UYVY or YUYV */
> >   __s32 out_hsize;   /* output frame horizontal size. */
> >   __s32 out_vsize;   /* output frame vertical size.*/
> >   __s32 out_pitch;   /* offset between 2 rows of output frame.*/
> >   __s32 hstph;       /* for specifying horizontal starting
> phase.*/
> >   __s32 vstph;       /* for specifying vertical starting phase.*/
> >   __u16 tap4filt_coeffs[32]; /* horizontal filtercoefficients.*/
> >   __u16 tap7filt_coeffs[32]; /* vertical filter coefficients. */
> >   struct rsz_yenh yenh_params;
> >
> > (Pasted from previous patches posted by Sergio)
> >
> >
> > Putting one sample proposal using VIDIOC_S_FMT -
> >
> > APPROACH 1 -
> > ----------
> >
> > Either we can add this under "struct v4l2_format" or need to
> enhance
> > "stuct v4l2_crop" to support such device.
> >
> > We can use 'VIDIOC_S_FMT' ioctl to configure the resizer
> parameters. From
> > top level it will look something like -
> >
> > struct v4l2_buffer buf;
> > struct v4l2_format fmt;
> > struct rsz_parm parm;	/*Contains custom configuration specific to
> module
> > other than input and output params*/
> >
> > <Fill the "rsz_parm" structure>
> 
> I think this should be managed through different controls (mostly
> private ones), since this looks really hardware specific to me.
> 
[Hiremath, Vaibhav] Yes this could be hardware specific, as of now we can live-up with "priv" field but we need to understand some more such devices to get standard interface.

> >
> > fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > fmt.fmt.pix.width = IN_WIDTH;
> > fmt.fmt.pix.height = IN_HEIGHT;
> > fmt.fmt.pix.bytesperline= IN_WIDTH*2;
> > fmt.fmt.pix.pixelformat= V4L2_PIX_FMT_YUYV/V4L2_PIX_FMT_UYVY
> > fmt.fmt.pix.priv = &parm;
> >
> > ret = ioctl(rsz_fd, VIDIOC_S_FMT, &fmt);
> > if(ret<0) {
> > 	perror("Set Format failed\n");
> > 	return -1;
> > }
> >
> > To set output buffer we can use VIDIOC_S_FMT
> >
> > fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> > fmt.fmt.pix.width = OUT_WIDTH;
> > fmt.fmt.pix.height = OUT_HEIGHT;
> > fmt.fmt.pix.bytesperline= OUT_WIDTH*2;
> >
> > ret = ioctl(rsz_fd, VIDIOC_S_FMT, &fmt);
> > if(ret<0) {
> > 	perror("Set Format failed\n");
> > 	return -1;
> > }
> >
> > In case of resizer driver we would need to call VIDIOC_S_FMT
> twice, one
> > for input params and second for output params. And in case of
> Previewer we
> > need to call VIDIOC_S_FMT only once, with all required params as a
> part of
> > custom struct (priv).
> >
> >
> > APPROACH 2 -
> > ----------
> >
> > Instead of using "priv" variable, we can make it capability based
> > interface. For this we have to create separate class of devices,
> called
> > "V4L2_BUF_TYPE_VIDEO_RESIZE" with "struct v4l2_fmt_resize" and
> "struct
> > v4l2_fmt_previewer".
> >
> > And depending on the capability application will configure params
> using
> > VIDIOC_S_FMT.
> >
> > In both the cases we need to add one IOCTL to trigger the
> operation and
> > this should be standard, should be common for all such memory-to-
> memory
> > device operations.
> >
> >
> > APPROACH 3 -
> > ----------
> >
> > .....
> >
> > (Any other approach which I could not think of would be
> appreciated)
> >
> >
> > I would prefer second approach, since this will provide standard
> interface
> > to applications independent on underneath hardware.
> >
> > There may be many number of such configuration parameters required
> for
> > different such devices, we need to work on this and come up with
> some
> > standard capability fields covering most of available devices.
> >
> > Does anybody have some other opinions on this?
> > Any suggestions will be helpful here,
> 
> 
> I found this really old link (1999) about a CODEC type of device:
> 	http://www.thedirks.org/v4l2/v4l2cod.htm
> 
> But in the V4L2 API spec, I see that the Codec interface is
> suspended, saying:
> 
> "This interface has been be suspended from the V4L2 API implemented
> in Linux 2.6 until we have more experience with codec device
> interfaces."
> 
> I guess this usecase could awake its usage again, what do you think?
> 
> I'll be interested on what's the current stand from v4l2 community
> about the future on this codec interface.
> 
[Hiremath, Vaibhav] Thanks Sergio for pointing me to this. I will go through this and provide comments. I just had cursory look and it looks like this could be the way to go for such devices.

> Regards,
> Sergio
> 
> >
> >
> > Thanks,
> > Vaibhav Hiremath
> > Platform Support Products
> > Texas Instruments Inc
> > Ph: +91-80-25099927

