Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54763 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbcCSAtl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 20:49:41 -0400
Date: Fri, 18 Mar 2016 21:49:27 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
	Antti Palosaari <crope@iki.fi>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>, Tommi Rantala <tt.rantala@gmail.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	Luis de Bethencourt <luis@debethencourt.com>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, devel@driverdev.osuosl.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH] [media] media: rename media unregister function
Message-ID: <20160318214927.507f715a@recife.lan>
In-Reply-To: <56EC0EA3.6010108@linux.intel.com>
References: <2ffc02c944068b2c8655727238d1542f8328385d.1458306276.git.mchehab@osg.samsung.com>
	<56EC0A55.3010803@osg.samsung.com>
	<56EC0CC4.1070309@osg.samsung.com>
	<56EC0DF9.4050601@osg.samsung.com>
	<56EC0EA3.6010108@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Mar 2016 16:20:19 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Shuah Khan wrote:
> > On 03/18/2016 08:12 AM, Javier Martinez Canillas wrote:  
> >> Hello Shuah,
> >>
> >> On 03/18/2016 11:01 AM, Shuah Khan wrote:  
> >>> On 03/18/2016 07:05 AM, Mauro Carvalho Chehab wrote:  
> >>>> Now that media_device_unregister() also does a cleanup, rename it
> >>>> to media_device_unregister_cleanup().
> >>>>
> >>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>  
> >>>
> >>> I think adding cleanup is redundant. media_device_unregister()
> >>> would imply that there has to be some cleanup releasing resources.
> >>> I wouldn't make this change.
> >>>  
> >>
> >> Problem is that there is a media_device_init() and media_device_register(),
> >> so having both unregister and cleanup in this function will make very clear
> >> that a single function is the counter part of the previous two operations.
> >>    
> > 
> > Yes. I realized that this change is motivated by the fact that there is
> > the media_device_init() and we had the counterpart media_device_cleanup()
> > as an exported function. I still think there is no need to make the change
> > to add _cleanup() at the end of media_device_unregister(). It can be handled
> > in API documentation that it does both.  
> 
> I think that's a bad idea. People will only read the documentation when
> something doesn't work. In this case it's easy to miss that.

After thinking about that, I guess the best is to use kref only
if the media_device_*devres functions are used. With this, we don't
need to touch at media_device_cleanup().

Just the patch to the ML:
	https://patchwork.linuxtv.org/patch/33533/

It was tested with HVR-950Q.

Regards,
Mauro
