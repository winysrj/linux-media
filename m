Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58775 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbbKXGYm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2015 01:24:42 -0500
Date: Tue, 24 Nov 2015 14:24:06 +0800
From: Shawn Guo <shawnguo@kernel.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Acked-by: Arnd Bergmann" <arnd@arndb.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	Russell King <linux@arm.linux.org.uk>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Daniel Ribeiro <drwyrm@gmail.com>,
	Stefan Schmidt <stefan@openezx.org>,
	Harald Welte <laforge@openezx.org>,
	Tomas Cech <sleep_walker@suse.com>,
	Sergey Lapin <slapin@ossfans.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	openezx-devel@lists.openezx.org
Subject: Re: [PATCH v2] [media] move media platform data to
 linux/platform_data/media
Message-ID: <20151124062405.GK11999@tiger>
References: <592e25aa9ecb358f48f844195252368b950059b6.1447759269.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <592e25aa9ecb358f48f844195252368b950059b6.1447759269.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 17, 2015 at 09:21:13AM -0200, Mauro Carvalho Chehab wrote:
> Now that media has its own subdirectory inside platform_data,
> let's move the headers that are already there to such subdir.
> 
> After moving those files, the references were adjusted using this
> script:
> 
>     MAIN_DIR="linux/platform_data/"
>     PREV_DIR="linux/platform_data/"
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
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Shawn Guo <shawnguo@kernel.org>
