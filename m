Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mASIYZNH032512
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 13:34:35 -0500
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mASIYOuj013023
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 13:34:24 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: David Brownell <david-b@pacbell.net>
Date: Sat, 29 Nov 2008 00:04:10 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E904ECE1@dbde02.ent.ti.com>
In-Reply-To: <200811280833.30868.david-b@pacbell.net>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"davinci-linux-open-source-bounces@linux.davincidsp.com"
	<davinci-linux-open-source-bounces@linux.davincidsp.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH 2/2] TVP514x Driver with Review comments fixed
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



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: David Brownell [mailto:david-b@pacbell.net]
> Sent: Friday, November 28, 2008 10:04 PM
> To: Hiremath, Vaibhav
> Cc: video4linux-list@redhat.com; davinci-linux-open-source-
> bounces@linux.davincidsp.com; linux-omap@vger.kernel.org; Jadav,
> Brijesh R; Shah, Hardik; Hadli, Manjunath; R, Sivaraj; Karicheri,
> Muralidharan
> Subject: Re: [PATCH 2/2] TVP514x Driver with Review comments fixed
> 
> On Friday 28 November 2008, hvaibhav@ti.com wrote:
> > +/*
> > + * Supported standards - These must be ordered according to enum
> tvp514x_std
> > + * order.
> 
> In this case it'd be easy to remove that restriction...
> 
> 
[Hiremath, Vaibhav] Very true, I never thought this of while implementing. I will change this in next patch.

> > + * Currently supports two standards only, need to add support for
> rest of the
> > + * modes, like SECAM, etc...
> > + */
> > +static struct tvp514x_std_info tvp514x_std_list[] = {
> > +       {
> 
> 	[STD_NTSC_MJ] = {
> 
> > +        .width = NTSC_NUM_ACTIVE_PIXELS,
> > +        .height = NTSC_NUM_ACTIVE_LINES,
> > +        .video_std = VIDEO_STD_NTSC_MJ_BIT,
> > +        .standard = {
> > +                     .index = 0,
> > +                     .id = V4L2_STD_NTSC,
> > +                     .name = "NTSC",
> > +                     .frameperiod = {1001, 30000},
> > +                     .framelines = 525
> > +                    },
> > +       }, {
> 
> 	[STD_PAL_BDGHIN] = { ...
> 
> ... for clarity.  Though it's more conventional to have
> the "undefined" value be zero, and thus what kzalloc or
> static initialization provides, than have NTSC be zero.  :)
> 
> 
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
