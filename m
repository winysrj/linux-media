Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:32774 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbbKPNBb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 08:01:31 -0500
Received: by wmec201 with SMTP id c201so175082761wme.0
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2015 05:01:30 -0800 (PST)
Date: Mon, 16 Nov 2015 13:01:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Eduardo Valentin <edubezval@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Vinod Koul <vinod.koul@intel.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Fabian Frederick <fabf@skynet.be>,
	Heiko Stuebner <heiko@sntech.de>,
	Patrice Chotard <patrice.chotard@st.com>,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-sh@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 3/3] [media] include/media: move platform_data to
 linux/platform_data/media
Message-ID: <20151116130126.GE17829@x1>
References: <013152dcb3d4eaddd39aa4a37868430567bdc2d6.1447671420.git.mchehab@osg.samsung.com>
 <b8bd73bedde742571b1ab8a7c0917a732dbf2ca1.1447671420.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8bd73bedde742571b1ab8a7c0917a732dbf2ca1.1447671420.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Nov 2015, Mauro Carvalho Chehab wrote:

> Let's not mix platform_data headers with the core headers. Instead, let's
> create a subdir at linux/platform_data and move the headers to that
> common place, adding it to MAINTAINERS.
> 
> The headers were moved with:
> 	mkdir include/linux/platform_data/media/; git mv include/media/gpio-ir-recv.h include/media/ir-rx51.h include/media/mmp-camera.h include/media/omap1_camera.h include/media/omap4iss.h include/media/s5p_hdmi.h include/media/si4713.h include/media/sii9234.h include/media/smiapp.h include/media/soc_camera.h include/media/soc_camera_platform.h include/media/timb_radio.h include/media/timb_video.h include/linux/platform_data/media/
> 
> And the references fixed with this script:
>     MAIN_DIR="linux/platform_data/"
>     PREV_DIR="media/"
>     DIRS="media/"
> 
>     echo "Checking affected files" >&2
>     for i in $DIRS; do
> 	for j in $(find include/$MAIN_DIR/$i -type f -name '*.h'); do
> 		 n=`basename $j`
> 		git grep -l $n
> 	done
>     done|sort|uniq >files && (
> 	echo "Handling files..." >&2;
> 	echo "for i in \$(cat files|grep -v Documentation); do cat \$i | \\";
> 	(
> 		cd include/$MAIN_DIR;
> 		for j in $DIRS; do
> 			for i in $(ls $j); do
> 				echo "perl -ne 's,(include [\\\"\\<])$PREV_DIR($i)([\\\"\\>]),\1$MAIN_DIR$j\2\3,; print \$_' |\\";
> 			done;
> 		done;
> 		echo "cat > a && mv a \$i; done";
> 	);
> 	echo "Handling documentation..." >&2;
> 	echo "for i in MAINTAINERS \$(cat files); do cat \$i | \\";
> 	(
> 		cd include/$MAIN_DIR;
> 		for j in $DIRS; do
> 			for i in $(ls $j); do
> 				echo "  perl -ne 's,include/$PREV_DIR($i)\b,include/$MAIN_DIR$j\1,; print \$_' |\\";
> 			done;
> 		done;
> 		echo "cat > a && mv a \$i; done"
> 	);
>     ) >script && . ./script
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  Documentation/video4linux/omap4_camera.txt                    | 2 +-
>  Documentation/video4linux/si4713.txt                          | 2 +-
>  MAINTAINERS                                                   | 1 +
>  arch/arm/mach-omap1/include/mach/camera.h                     | 2 +-
>  arch/arm/mach-omap2/board-rx51-peripherals.c                  | 4 ++--
>  arch/arm/plat-samsung/devs.c                                  | 2 +-
>  arch/sh/boards/mach-ap325rxa/setup.c                          | 2 +-
>  drivers/media/platform/marvell-ccic/mmp-driver.c              | 2 +-
>  drivers/media/platform/s5p-tv/hdmi_drv.c                      | 2 +-
>  drivers/media/platform/s5p-tv/sii9234_drv.c                   | 2 +-
>  drivers/media/platform/soc_camera/omap1_camera.c              | 2 +-
>  drivers/media/platform/soc_camera/soc_camera_platform.c       | 2 +-
>  drivers/media/platform/timblogiw.c                            | 2 +-
>  drivers/media/radio/radio-timb.c                              | 2 +-
>  drivers/media/radio/si4713/radio-usb-si4713.c                 | 2 +-
>  drivers/media/radio/si4713/si4713.h                           | 2 +-
>  drivers/media/rc/gpio-ir-recv.c                               | 2 +-
>  drivers/media/rc/ir-rx51.c                                    | 2 +-
>  drivers/mfd/timberdale.c                                      | 4 ++--

Acked-by: Lee Jones <lee.jones@linaro.org>
  
>  drivers/staging/media/omap4iss/iss.h                          | 2 +-
>  drivers/staging/media/omap4iss/iss_csiphy.h                   | 2 +-
>  include/{ => linux/platform_data}/media/gpio-ir-recv.h        | 1 -
>  include/{ => linux/platform_data}/media/ir-rx51.h             | 0
>  include/{ => linux/platform_data}/media/mmp-camera.h          | 0
>  include/{ => linux/platform_data}/media/omap1_camera.h        | 0
>  include/{ => linux/platform_data}/media/omap4iss.h            | 0
>  include/{ => linux/platform_data}/media/s5p_hdmi.h            | 1 -
>  include/{ => linux/platform_data}/media/si4713.h              | 2 +-
>  include/{ => linux/platform_data}/media/sii9234.h             | 0
>  include/{ => linux/platform_data}/media/soc_camera_platform.h | 0
>  include/{ => linux/platform_data}/media/timb_radio.h          | 0
>  include/{ => linux/platform_data}/media/timb_video.h          | 0
>  32 files changed, 24 insertions(+), 25 deletions(-)
>  rename include/{ => linux/platform_data}/media/gpio-ir-recv.h (99%)
>  rename include/{ => linux/platform_data}/media/ir-rx51.h (100%)
>  rename include/{ => linux/platform_data}/media/mmp-camera.h (100%)
>  rename include/{ => linux/platform_data}/media/omap1_camera.h (100%)
>  rename include/{ => linux/platform_data}/media/omap4iss.h (100%)
>  rename include/{ => linux/platform_data}/media/s5p_hdmi.h (99%)
>  rename include/{ => linux/platform_data}/media/si4713.h (96%)
>  rename include/{ => linux/platform_data}/media/sii9234.h (100%)
>  rename include/{ => linux/platform_data}/media/soc_camera_platform.h (100%)
>  rename include/{ => linux/platform_data}/media/timb_radio.h (100%)
>  rename include/{ => linux/platform_data}/media/timb_video.h (100%)

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
