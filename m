Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43002 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677AbbBNJcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2015 04:32:41 -0500
Message-ID: <54DF1625.20808@xs4all.nl>
Date: Sat, 14 Feb 2015 10:32:21 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv4 00/25] dvb core: add basic support for the media controller
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/2015 11:57 PM, Mauro Carvalho Chehab wrote:
> This patch series adds basic support for the media controller at the
> DVB core: it creates one media entity per DVB devnode, if the media
> device is passed as an argument to the DVB structures.
> 
> The cx231xx driver was modified to pass such argument for DVB NET,
> DVB frontend and DVB demux.
> 
> -
> 
> version 4:
> 
> - Addressed the issues pointed via e-mail

No, you didn't. Especially with regards to the alsa node definition. I'm
pretty sure you need at least the subdevice information which is now removed.

I also do *not* like the fact that you posted a v4 and immediately applied
these patches to the master without leaving any time for more discussions.

These patches change the kernel API and need to go to proper review and need
a bunch of Acks, Laurent's at the very minimum since he's MC maintainer.

Please revert the whole patch series from master, then we can discuss this
more.

For the record, for patch 02/25:

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

I do *not* agree with this API change.

We can discuss this more on Monday.

Regards,

	Hans

> - Added a separate Kconfig option to enable media controller DVB
>   experimental support
> - Fixed some CodingStyle issues
> - Added documentation for the API changes at the DocBook
> 
> version 3:
> - Added the second series of patches ("add link graph to cx231xx 
>   using the media controller")
> - tuner-core and cx25840: add proper error handling as suggested by
>   Sakari Ailus and pointed by Joe Perches;
> - dvb core: move the media_dev struct to be inside the DVB adapter. That
>   allowed to simplify the changes for the dvbdev clients;
> - Add logic to setup the pipelines when analog or digital TV stream starts.
> - Renamed some patches to better describe its contents.
> 
> version 2:
> - Now the PADs are created for all nodes
> - Instead of using entity->flags for subtypes, create separate
>   MEDIA_ENT_T_DEVNODE_DVB_foo for each DVB devtype
> - The API change patch was split from the DVB core changes
> 
> Mauro Carvalho Chehab (24):
>   [media] media: Fix DVB devnode representation at media controller
>   [media] Docbook: Fix documentation for media controller devnodes
>   [media] media: add new types for DVB devnodes
>   [media] DocBook: Document the DVB API devnodes at the media controller
>   [media] media: add a subdev type for tuner
>   [media] DocBook: Add tuner subdev at documentation
>   [media] dvbdev: add support for media controller
>   [media] cx231xx: add media controller support
>   [media] dvb_frontend: add media controller support for DVB frontend
>   [media] dmxdev: add support for demux/dvr nodes at media controller
>   [media] dvb_ca_en50221: add support for CA node at the media
>     controller
>   [media] dvb_net: add support for DVB net node at the media controller
>   [media] dvbdev: add pad for the DVB devnodes
>   [media] tuner-core: properly initialize media controller subdev
>   [media] cx25840: fill the media controller entity
>   [media] cx231xx: initialize video/vbi pads
>   [media] cx231xx: create media links for analog mode
>   [media] dvbdev: represent frontend with two pads
>   [media] dvbdev: add a function to create DVB media graph
>   [media] cx231xx: create DVB graph
>   [media] dvbdev: enable DVB-specific links
>   [media] dvb-frontend: enable tuner link when the FE thread starts
>   [media] cx231xx: enable tuner->decoder link at videobuf start
>   [media] dvb_frontend: start media pipeline while thread is running
> 
> Zhangfei Gao (1):
>   [media] ir-hix5hd2: remove writel/readl_relaxed define
> 
>  .../DocBook/media/v4l/media-ioc-enum-entities.xml  | 102 ++++-----------
>  Documentation/DocBook/media/v4l/v4l2.xml           |   9 ++
>  drivers/media/Kconfig                              |  10 +-
>  drivers/media/dvb-core/dmxdev.c                    |  11 +-
>  drivers/media/dvb-core/dvb_ca_en50221.c            |   6 +-
>  drivers/media/dvb-core/dvb_frontend.c              | 121 ++++++++++++++++-
>  drivers/media/dvb-core/dvb_net.c                   |   6 +-
>  drivers/media/dvb-core/dvbdev.c                    | 143 ++++++++++++++++++++-
>  drivers/media/dvb-core/dvbdev.h                    |  15 +++
>  drivers/media/i2c/cx25840/cx25840-core.c           |  18 +++
>  drivers/media/i2c/cx25840/cx25840-core.h           |   3 +
>  drivers/media/rc/ir-hix5hd2.c                      |   8 --
>  drivers/media/usb/cx231xx/cx231xx-cards.c          |  98 +++++++++++++-
>  drivers/media/usb/cx231xx/cx231xx-dvb.c            |   5 +
>  drivers/media/usb/cx231xx/cx231xx-video.c          |  84 +++++++++++-
>  drivers/media/usb/cx231xx/cx231xx.h                |   5 +
>  drivers/media/v4l2-core/tuner-core.c               |  20 +++
>  drivers/media/v4l2-core/v4l2-dev.c                 |   4 +-
>  drivers/media/v4l2-core/v4l2-device.c              |   4 +-
>  include/media/media-entity.h                       |  12 +-
>  include/uapi/linux/media.h                         |  26 +++-
>  21 files changed, 592 insertions(+), 118 deletions(-)
> 

