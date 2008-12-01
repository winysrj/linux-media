Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1DTx3Z016532
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 08:29:59 -0500
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1DTjiV031094
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 08:29:46 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 1 Dec 2008 14:29:53 +0100
References: <200812011246.08885.hverkuil@xs4all.nl>
	<200812011331.25676.laurent.pinchart@skynet.be>
	<200812011351.55323.hverkuil@xs4all.nl>
In-Reply-To: <200812011351.55323.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011429.54019.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com,
	davinci-linux-open-source-bounces@linux.davincidsp.com,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng
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

Hi Hans,

On Monday 01 December 2008, Hans Verkuil wrote:
> On Monday 01 December 2008 13:31:25 Laurent Pinchart wrote:
> > On Monday 01 December 2008, Hans Verkuil wrote:
> > > Hi Mauro,
> > >
> > > Please pull from http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng for
> > > the following:
> > >
> > > - v4l2: add v4l2_device and v4l2_subdev structs to the v4l2
> > > framework. - v4l2-common: add i2c helper functions
> > > - cs53l32a: convert to v4l2_subdev.
> > > - cx25840: convert to v4l2_subdev.
> > > - m52790: convert to v4l2_subdev.
> > > - msp3400: convert to v4l2_subdev.
> > > - saa7115: convert to v4l2_subdev.
> > > - saa7127: convert to v4l2_subdev.
> > > - saa717x: convert to v4l2_subdev.
> > > - tuner: convert to v4l2_subdev.
> > > - upd64031a: convert to v4l2_subdev.
> > > - upd64083: convert to v4l2_subdev.
> > > - vp27smpx: convert to v4l2_subdev.
> > > - wm8739: convert to v4l2_subdev.
> > > - wm8775: convert to v4l2_subdev.
> > > - ivtv/ivtvfb: convert to v4l2_device/v4l2_subdev.
> > >
> > > All points raised in reviews are addressed so I think it is time to
> > > get this merged so people can start to use it.
> >
> > Does linuxtv.org and Mercurial provide the necessary infrastructure
> > to integrate those changes into the v4l-dvb repository while not
> > pushing them upstream yet ? I'd like to see more people testing (and
> > breaking and fixing :-)) your changes before they reach the mainline
> > kernel.
>
> That's basically why I want this to go into the v4l-dvb repository: this
> makes it easier for people to start working with it. It doesn't affect
> existing drivers, except for the i2c driver changes and those changes
> are just transforming a big switch to a set of functions. So I really
> consider this a pretty low-risk merge.
>
> If someone is willing to do some testing with my tree in the next two
> weeks then I don't mind waiting, but it's been in development now from
> early September (if not earlier) and been reviewed several times. In
> addition, ivtv has been modified to work with it and that driver uses
> more sub-devices by far than any other driver.
>
> I don't know what more I can do, to be honest.

I am all for pushing the changes to the v4l-dvb repository so they can get 
broader testing. I am, however, a bit more concerned about pushing the 
changes to Linus yet. Shouldn't it wait until you convert other drivers and 
make the v4l2_device (infra)structure more powerful, as you announced you 
would ? There will probably be API/ABI breakage then, it patches will 
probably benefit from a few iterations in v4l-dvb before we push them to 
mainline.

I don't know if that's possible at all, or if all changes in v4l-dvb are 
automatically selected for a push to the git repository whenever Mauro 
triggers the hg->git process.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
