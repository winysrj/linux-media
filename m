Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab0BSCyl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 21:54:41 -0500
Message-ID: <4B7DFD65.4040501@redhat.com>
Date: Fri, 19 Feb 2010 00:54:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pete Eberlein <pete@sensoray.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] go7007 staging changes
References: <1265934770.4626.249.camel@pete-desktop>
In-Reply-To: <1265934770.4626.249.camel@pete-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pete Eberlein wrote:
> Hello.
> 
> This series moves most of the subdevice drivers used by the go7007
> driver out of the staging directory.  The sony-tuner, ov7640, tw2804 and
> tw9903 are converted to use the v4l2_subdev API, and the wis- versions
> are made obsolete.  The wis-saa7113 and wis-saa7115 drivers are
> obsolete, and don't add anything not already in the existing saa7113 and
> saa7115 video decoder drivers.  The audio chip driver wis-uda1342
> doesn't belong in 
> 
> If these changes are accepted, it should be determined if the go7007
> driver can be moved out of staging, or what work remains to be done.

Hi Pete,

Nice work! It seems that the driver is almost ready.

Please work around the comments made by the others and submit us a new version.
I think you may add a patch at the end of the series, moving all those drivers to
drivers/media and drivers/media/go7007.

Cheers,
Mauro
