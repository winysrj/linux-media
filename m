Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway14.websitewelcome.com ([69.41.245.8]:54070 "HELO
	gateway14.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752402Ab0BSTza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 14:55:30 -0500
Subject: Re: [PATCH 0/5] go7007 staging changes
From: Pete Eberlein <pete@sensoray.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <4B7DFD65.4040501@redhat.com>
References: <1265934770.4626.249.camel@pete-desktop>
	 <4B7DFD65.4040501@redhat.com>
Content-Type: text/plain
Date: Fri, 19 Feb 2010 10:08:25 -0800
Message-Id: <1266602905.5714.1720.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-02-19 at 00:54 -0200, Mauro Carvalho Chehab wrote:
> Pete Eberlein wrote:
> > Hello.
> > 
> > This series moves most of the subdevice drivers used by the go7007
> > driver out of the staging directory.  The sony-tuner, ov7640, tw2804 and
> > tw9903 are converted to use the v4l2_subdev API, and the wis- versions
> > are made obsolete.  The wis-saa7113 and wis-saa7115 drivers are
> > obsolete, and don't add anything not already in the existing saa7113 and
> > saa7115 video decoder drivers.  The audio chip driver wis-uda1342
> > doesn't belong in 
> > 
> > If these changes are accepted, it should be determined if the go7007
> > driver can be moved out of staging, or what work remains to be done.
> 
> Hi Pete,
> 
> Nice work! It seems that the driver is almost ready.
> 
> Please work around the comments made by the others and submit us a new version.
> I think you may add a patch at the end of the series, moving all those drivers to
> drivers/media and drivers/media/go7007.

Thanks for the feedback, Mauro.  Other projects have been consuming my
time, but I hope to soon resubmit the patches incorporating the comments
from Hans, and adding the go7007 subdirectory.  I also realized that the
s2250 driver is actually two devices, one of which is tlv320aic23b, and
should be using that driver instead.  I also fixed up the patch for the
ADS Tech DVD Xpress DX2 from Timothy Jones, and will get that submitted
too.

> Cheers,
> Mauro

Pete Eberlein

