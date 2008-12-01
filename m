Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1CVX8w016447
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 07:31:33 -0500
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1CVJFF029873
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 07:31:19 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Mon, 1 Dec 2008 13:31:25 +0100
References: <200812011246.08885.hverkuil@xs4all.nl>
In-Reply-To: <200812011246.08885.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011331.25676.laurent.pinchart@skynet.be>
Cc: davinci-linux-open-source-bounces@linux.davincidsp.com,
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

On Monday 01 December 2008, Hans Verkuil wrote:
> Hi Mauro,
>
> Please pull from http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng for the
> following:
>
> - v4l2: add v4l2_device and v4l2_subdev structs to the v4l2 framework.
> - v4l2-common: add i2c helper functions
> - cs53l32a: convert to v4l2_subdev.
> - cx25840: convert to v4l2_subdev.
> - m52790: convert to v4l2_subdev.
> - msp3400: convert to v4l2_subdev.
> - saa7115: convert to v4l2_subdev.
> - saa7127: convert to v4l2_subdev.
> - saa717x: convert to v4l2_subdev.
> - tuner: convert to v4l2_subdev.
> - upd64031a: convert to v4l2_subdev.
> - upd64083: convert to v4l2_subdev.
> - vp27smpx: convert to v4l2_subdev.
> - wm8739: convert to v4l2_subdev.
> - wm8775: convert to v4l2_subdev.
> - ivtv/ivtvfb: convert to v4l2_device/v4l2_subdev.
>
> All points raised in reviews are addressed so I think it is time to get
> this merged so people can start to use it.

Does linuxtv.org and Mercurial provide the necessary infrastructure to 
integrate those changes into the v4l-dvb repository while not pushing them 
upstream yet ? I'd like to see more people testing (and breaking and 
fixing :-)) your changes before they reach the mainline kernel.

> Reviewed-by: Laurent Pinchart <laurent.pinchart@skynet.be>
> Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Reviewed-by: Andy Walls <awalls@radix.net>
> Reviewed-by: David Brownell <david-b@pacbell.net>
>
> Once this is in I'll start on converting the other i2c drivers.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
