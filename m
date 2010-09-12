Return-path: <mchehab@localhost.localdomain>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36844 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753654Ab0ILV2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 17:28:07 -0400
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove V4L1 support from the pwc
 driver
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <1284325962.2394.24.camel@localhost>
References: <201009122226.11970.hverkuil@xs4all.nl>
	 <1284325962.2394.24.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Sep 2010 17:28:59 -0400
Message-ID: <1284326939.2394.29.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

On Sun, 2010-09-12 at 17:12 -0400, Andy Walls wrote:
> On Sun, 2010-09-12 at 22:26 +0200, Hans Verkuil wrote:
> 
> > And other news on the V4L1 front:
> 
> > I'm waiting for test results on the cpia2 driver. If it works, then the V4L1
> > support can be removed from that driver as well.
> 
> FYI, that will break this 2005 vintage piece of V4L1 software people may
> still be using for the QX5 microscope:

Sorry, that is of course, if there is no V4L1 compat layer still in
place.

BTW, qx5view uses a private ioctl() to change the lights on a QX5 and
not the V4L2 control.

In qx5view:

void setlight() {
#define CPIA2_IOC_SET_GPIO         _IOR('v', BASE_VIDIOCPRIVATE + 17, __u32)
    ioctl(dev, CPIA2_IOC_SET_GPIO, light_setting);
}


In the cpia2 driver:

       /* CPIA2 extension to Video4Linux API */
        case CPIA2_IOC_SET_GPIO:
                retval = ioctl_set_gpio(arg, cam);
                break;

Yuck.

Regards,
Andy

