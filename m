Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBI99RFF004089
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 04:09:27 -0500
Received: from smtp-vbr4.xs4all.nl (smtp-vbr4.xs4all.nl [194.109.24.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBI99Be6028391
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 04:09:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Brandon Jenkins" <bcjenkins@tvwhere.com>
Date: Thu, 18 Dec 2008 10:09:09 +0100
References: <15114.62.70.2.252.1228832086.squirrel@webmail.xs4all.nl>
	<200812161655.39431.hverkuil@xs4all.nl>
	<de8cad4d0812170904x474a5503ve5fcef84ebfeba65@mail.gmail.com>
In-Reply-To: <de8cad4d0812170904x474a5503ve5fcef84ebfeba65@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812181009.09836.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: v4l2-compat-ioctl32 update?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wednesday 17 December 2008 18:04:12 Brandon Jenkins wrote:
> On Tue, Dec 16, 2008 at 10:55 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Saturday 13 December 2008 15:46:15 Brandon Jenkins wrote:
> >> On Wed, Dec 10, 2008 at 4:52 AM, Brandon Jenkins
> >
> > <bcjenkins@tvwhere.com> wrote:
> >> > Hi Hans,
> >> >
> >> > I have patched the module, rebooted and ran a script to query
> >> > dev/video (HVR-1600) for all of the get and list controls in the
> >> > help output.
> >> >
> >> > I am attaching the output of that, the dmesg output, and dmesg
> >> > output while running captures using SageTV. I will work on a script
> >> > to execute the set commands. Please let me know if I can be doing
> >> > this better.
> >> >
> >> > Regards,
> >> >
> >> > Brandon
> >>
> >> Hi Hans,
> >>
> >> Is this data useful? I will work on the script to test setting this
> >> weekend but would like to make sure it is the output you would like
> >> to see.
> >
> > Hi Brandon,
> >
> > Please test with this tree:
> >
> > http://linuxtv.org/hg/~hverkuil/v4l-dvb-compat32
> >
> > All V4L1 and V4L2 ioctls are now supported and several broken
> > conversions are fixed. This should work pretty good and it should not
> > result in any kernel log messages.
> >
> > At least, that's the case when I test with ivtv.
> >
> > Regards,
> >
> >        Hans
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG
>
> Hi Hans,
>
> Thank you for the update. The only dmesg output I am seeing now is:
>
> [65808.551034] cx18-2 info: Input unchanged
> [65808.562048] compat_ioctl32: VIDIOC_S_EXT_CTRLS<7>compat_ioctl32:
> VIDIOC_S_EXT_CTRLS<7>compat_ioctl32:
> VIDIOC_S_EXT_CTRLS<7>compat_ioctl32:
> VIDIOC_S_EXT_CTRLS<7>compat_ioctl32:
> VIDIOC_S_EXT_CTRLS<7>compat_ioctl32: VIDIOC_S_EXT_CTRLS<6>cx18-2 info:
> Start encoder stream encoder MPEG
> [65808.563454] cx18-2 info: PLL regs = int: 15, frac: 2876158, post: 4
> [65808.563459] cx18-2 info: PLL = 108.000014 MHz
> [65808.563462] cx18-2 info: PLL/8 = 13.500001 MHz
> [65808.563465] cx18-2 info: ADC Sampling freq = 14.317384 MHz
> [65808.563466] cx18-2 info: Chroma sub-carrier freq = 3.579545 MHz
> [65808.563471] cx18-2 info: hblank 122, hactive 720, vblank 26 ,
> vactive 487, vblank656 26, src_dec 543,burst 0x5b, luma_lpf 1, uv_lpf
> 1, comb 0x66, sc 0x087c1f
> [65808.563532] cx18-2 info: Setup VBI h: 0 lines c000c bpl 1444 fr 1
> 20602060 307090d0
>
> Thanks for your efforts!

Hi Brandon,

This can't be right. Are you sure that you are using the right 
v4l2_compat_ioctl32 module? Check that you do not accidentally have the old 
compat_ioctl32 module instead. VIDIOC_S_EXT_CTRLS works fine here, and in 
any case, these compat_ioctl32 messages you get should have a newline at 
the end as well.

Regards,

	Hans

>
> Brandon



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
