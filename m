Return-path: <mchehab@localhost.localdomain>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:46460 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792Ab0ILVdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 17:33:38 -0400
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove V4L1 support from the pwc
 driver
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <1284326939.2394.29.camel@localhost>
References: <201009122226.11970.hverkuil@xs4all.nl>
	 <1284325962.2394.24.camel@localhost>  <1284326939.2394.29.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Sep 2010 17:34:34 -0400
Message-ID: <1284327274.2394.33.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

On Sun, 2010-09-12 at 17:28 -0400, Andy Walls wrote:
> On Sun, 2010-09-12 at 17:12 -0400, Andy Walls wrote:
> > On Sun, 2010-09-12 at 22:26 +0200, Hans Verkuil wrote:
> > 
> > > And other news on the V4L1 front:
> > 
> > > I'm waiting for test results on the cpia2 driver. If it works, then the V4L1
> > > support can be removed from that driver as well.
> > 


> In the cpia2 driver:
> 
>        /* CPIA2 extension to Video4Linux API */
>         case CPIA2_IOC_SET_GPIO:
>                 retval = ioctl_set_gpio(arg, cam);
>                 break;
> 
> Yuck.

And another gem in the cpia2 driver, this V4L2 control:


        {
                .id            = CPIA2_CID_GPIO,
                .type          = V4L2_CTRL_TYPE_INTEGER,
                .name          = "GPIO",
                .minimum       = 0,
                .maximum       = 255,
                .step          = 1,
                .default_value = 0,
        },

Give me a GUI with a slider for that control, and I'm sure I can fry a
camera.

That should be removed.

Regards,
Andy


