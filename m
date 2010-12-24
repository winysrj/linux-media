Return-path: <mchehab@gaivota>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2817 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0LXSzA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Dec 2010 13:55:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: nasty bug at qv4l2
Date: Fri, 24 Dec 2010 19:54:35 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4D11E170.6050500@redhat.com> <201012241520.01460.hverkuil@xs4all.nl> <4D14B106.2000502@redhat.com>
In-Reply-To: <4D14B106.2000502@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012241954.35906.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Friday, December 24, 2010 15:41:10 Hans de Goede wrote:
> Hi,
> 
> On 12/24/2010 03:20 PM, Hans Verkuil wrote:
> > On Friday, December 24, 2010 15:19:26 Hans de Goede wrote:
> >> Hi,
> >>
> >> On 12/22/2010 12:30 PM, Mauro Carvalho Chehab wrote:
> >>> Hans V/Hans G,
> >>>
> >>> There's a nasty bug at qv4l2 or at libv4l: it is not properly updating
> >>> all info, if you change the video device. On my tests with uvcvideo (video0)
> >>> and a gspca camera (pac7302, video1), it was showing the supported formats
> >>> for the uvcvideo camera when I changed from video0 to video1.
> >>>
> >>> The net result is that the image were handled with the wrong decoder
> >>> (instead of using fourcc V4L2_PIX_FMT_PJPG, it were using BGR3), producing
> >>> a wrong decoding.
> >>>
> >>> Could you please take a look on it?
> >>
> >> I'm pretty sure this is not a libv4l issue (other apps which allows witching
> >> the source work fine), but rather a qv4l2 problem, esp. as it uses libv4lconvert
> >> directly rather then going through libv4l (iirc).
> >
> > And I'm pretty sure it isn't a qv4l2 issue :-)
> >
> > For the record: qv4l2 can open a device node either in 'raw' mode bypassing libv4l
> > and using v4lconvert to convert unsupported pixformats, or in 'wrapped' mode where
> > libv4l is used for all device node accesses.
> >
> 
> Interesting, how does it switch between the modes?

In the File menu there is an entry "Open device" (uses libv4l) and "Open raw device"
(opens the device node directly).

Depending on how the device is opened, all calls to the device node either go through
libv4l or are direct system calls.

> Mauro were you using wrapped mode
> or raw mode when you saw this ?

The button on the toolbar will always use libv4l. But if you add the device node on
the command line (e.g. qv4l2 /dev/video0), then it will open the device node in raw
mode. That's rather inconsistent and it should also use libv4l. I've just fixed
this: 'qv4l2 /dev/video0' will now also use libv4l. If you want to test a device node
bypassing libv4l, then you have to open the device node using "Open raw device" in
the File menu.

I wonder if Mauro got confused by the different behavior as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
