Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:59135 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965983AbcAZPaD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 10:30:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/7] [media] pwc: hide unused label
Date: Tue, 26 Jan 2016 16:29:18 +0100
Message-ID: <2829409.X8sFnRsOHN@wuerfel>
In-Reply-To: <1453817424-3080054-1-git-send-email-arnd@arndb.de>
References: <1453817424-3080054-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 26 January 2016 15:09:55 Arnd Bergmann wrote:
> The pwc driver causes a warning when CONFIG_USB_PWC_INPUT_EVDEV is unset:
> 
> drivers/media/usb/pwc/pwc-if.c: In function 'usb_pwc_probe':
> drivers/media/usb/pwc/pwc-if.c:1115:1: warning: label 'err_video_unreg' defined but not used [-Wunused-label]
> 
> Obviously, the cleanup of &pdev->vdev is not needed without the input device,
> so we can just move it inside of the existing #ifdef and remove the
> extra label.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 

Please ignore patch 1. I made some late changes and failed to noticed
the build failure I introduced in another configuration.

	Arnd
