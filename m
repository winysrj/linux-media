Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60384 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbbL1K0o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 05:26:44 -0500
Date: Mon, 28 Dec 2015 08:26:33 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org,
	Luis de Bethencourt <luis@debethencourt.com>,
	linux-sh@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
	linux-samsung-soc@vger.kernel.org,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	linux-arm-kernel@lists.infradead.org,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Antti Palosaari <crope@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>
Subject: Re: [PATCH 2/2] [media] media-device: split media initialization
 and registration
Message-ID: <20151228082633.1786af24@recife.lan>
In-Reply-To: <20151228011452.GA26561@valkosipuli.retiisi.org.uk>
References: <1441890195-11650-1-git-send-email-javier@osg.samsung.com>
	<1441890195-11650-3-git-send-email-javier@osg.samsung.com>
	<55F1BA5C.50508@linux.intel.com>
	<20151215091342.2f825d91@recife.lan>
	<20151228011452.GA26561@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Dec 2015 03:14:53 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Tue, Dec 15, 2015 at 09:13:42AM -0200, Mauro Carvalho Chehab wrote:
> > Em Thu, 10 Sep 2015 20:14:04 +0300
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > 
> > > Hi Javier,
> > > 
> > > Thanks for the set! A few comments below.
> > > 
> > > Javier Martinez Canillas wrote:
> > > > The media device node is registered and so made visible to user-space
> > > > before entities are registered and links created which means that the
> > > > media graph obtained by user-space could be only partially enumerated
> > > > if that happens too early before all the graph has been created.
> > > > 
> > > > To avoid this race condition, split the media init and registration
> > > > in separate functions and only register the media device node when
> > > > all the pending subdevices have been registered, either explicitly
> > > > by the driver or asynchronously using v4l2_async_register_subdev().
> > > > 
> > > > Also, add a media_entity_cleanup() function that will destroy the
> > > > graph_mutex that is initialized in media_entity_init().
> > > > 
> > > > Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> > > > 
> > > > ---
> > > > 
> > > >  drivers/media/common/siano/smsdvb-main.c      |  1 +
> > > >  drivers/media/media-device.c                  | 38 +++++++++++++++++++++++----
> > > >  drivers/media/platform/exynos4-is/media-dev.c | 12 ++++++---
> > > >  drivers/media/platform/omap3isp/isp.c         | 11 +++++---
> > > >  drivers/media/platform/s3c-camif/camif-core.c | 13 ++++++---
> > > >  drivers/media/platform/vsp1/vsp1_drv.c        | 19 ++++++++++----
> > > >  drivers/media/platform/xilinx/xilinx-vipp.c   | 11 +++++---
> > > >  drivers/media/usb/au0828/au0828-core.c        | 26 +++++++++++++-----
> > > >  drivers/media/usb/cx231xx/cx231xx-cards.c     | 22 +++++++++++-----
> > > >  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c   | 11 +++++---
> > > >  drivers/media/usb/dvb-usb/dvb-usb-dvb.c       | 13 ++++++---
> > > >  drivers/media/usb/siano/smsusb.c              | 14 ++++++++--
> > > >  drivers/media/usb/uvc/uvc_driver.c            |  9 +++++--
> > > >  include/media/media-device.h                  |  2 ++
> > > >  14 files changed, 156 insertions(+), 46 deletions(-)
> > > > 
> > > > diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
> > > > index ab345490a43a..8a1ea2192439 100644
> > > > --- a/drivers/media/common/siano/smsdvb-main.c
> > > > +++ b/drivers/media/common/siano/smsdvb-main.c
> > > > @@ -617,6 +617,7 @@ static void smsdvb_media_device_unregister(struct smsdvb_client_t *client)
> > > >  	if (!coredev->media_dev)
> > > >  		return;
> > > >  	media_device_unregister(coredev->media_dev);
> > > > +	media_device_cleanup(coredev->media_dev);
> > > >  	kfree(coredev->media_dev);
> > > >  	coredev->media_dev = NULL;
> > > >  #endif
> > > > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > > > index 745defb34b33..a8beb0b445a6 100644
> > > > --- a/drivers/media/media-device.c
> > > > +++ b/drivers/media/media-device.c
> > > > @@ -526,7 +526,7 @@ static void media_device_release(struct media_devnode *mdev)
> > > >  }
> > > >  
> > > >  /**
> > > > - * media_device_register - register a media device
> > > > + * media_device_init() - initialize a media device
> > > >   * @mdev:	The media device
> > > >   *
> > > >   * The caller is responsible for initializing the media device before
> > > > @@ -534,12 +534,11 @@ static void media_device_release(struct media_devnode *mdev)
> > > >   *
> > > >   * - dev must point to the parent device
> > > >   * - model must be filled with the device model name
> > > > + *
> > > > + * returns zero on success or a negative error code.
> > > >   */
> > > > -int __must_check __media_device_register(struct media_device *mdev,
> > > > -					 struct module *owner)
> > > > +int __must_check media_device_init(struct media_device *mdev)
> > > 
> > > I think I suggested making media_device_init() return void as the only
> > > remaining source of errors would be driver bugs.
> > > 
> > > I'd simply replace the WARN_ON() below with BUG().
> > 
> > That sounds like bad idea to me, and it is against the current
> > Kernel policy of using BUG() only when there's no other way, e. g. on
> > event so severe that the Kernel has no other thing to do except to
> > stop running.
> > 
> > For sure, this is not the case here. Also, all drivers have already
> > a logic that checks if the device init happened. So, they should already
> > be doing the right thing.
> 
> My point is that it's simply counter-productive to require the caller to
> perform error handling in cases such as the only possible source of the
> error being a NULL argument passed to the callee.
> 
> To give you some examples, device_register(), device_add() nor mutex_lock()
> perform such checks. Some functions in V4L2 do, but I understand that's
> sometimes for historical reasons where NULL arguments were allowed. Or that
> there are other possible sources for errors in non-trivial functions and the
> rest of the checks are done on the side.
> 
> If you don't like BUG_ON(), just drop it. It's as simple as that.

Ah, I see your point. Yeah, dropping WARN_ON makes sense. I'll address
it.

> If there are other sources of errors then the matter is naturally entirely
> different.
> 

Regards,
Mauro
