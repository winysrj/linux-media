Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54533 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933188AbcCROCB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 10:02:01 -0400
Subject: Re: [PATCH] [media] media: rename media unregister function
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <2ffc02c944068b2c8655727238d1542f8328385d.1458306276.git.mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?Q?S=c3=b6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
	Antti Palosaari <crope@iki.fi>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>, Tommi Rantala <tt.rantala@gmail.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	Luis de Bethencourt <luis@debethencourt.com>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, devel@driverdev.osuosl.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56EC0A55.3010803@osg.samsung.com>
Date: Fri, 18 Mar 2016 08:01:57 -0600
MIME-Version: 1.0
In-Reply-To: <2ffc02c944068b2c8655727238d1542f8328385d.1458306276.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/18/2016 07:05 AM, Mauro Carvalho Chehab wrote:
> Now that media_device_unregister() also does a cleanup, rename it
> to media_device_unregister_cleanup().
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

I think adding cleanup is redundant. media_device_unregister()
would imply that there has to be some cleanup releasing resources.
I wouldn't make this change.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
