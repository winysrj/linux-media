Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34863 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbbKPNNS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 08:13:18 -0500
Subject: Re: [PATCH v2 3/3] [media] include/media: move platform_data to
 linux/platform_data/media
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <013152dcb3d4eaddd39aa4a37868430567bdc2d6.1447671420.git.mchehab@osg.samsung.com>
 <b8bd73bedde742571b1ab8a7c0917a732dbf2ca1.1447671420.git.mchehab@osg.samsung.com>
Cc: k.kozlowski.k@gmail.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Kukjin Kim <kgene@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Eduardo Valentin <edubezval@gmail.com>,
	Lee Jones <lee.jones@linaro.org>,
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
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-ID: <5649D663.4070104@samsung.com>
Date: Mon, 16 Nov 2015 22:13:07 +0900
MIME-Version: 1.0
In-Reply-To: <b8bd73bedde742571b1ab8a7c0917a732dbf2ca1.1447671420.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 16.11.2015 o 20:00, Mauro Carvalho Chehab pisze:
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

Acked-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

