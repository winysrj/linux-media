Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43568 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbbLKOE6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 09:04:58 -0500
Message-id: <566AD804.5040403@samsung.com>
Date: Fri, 11 Dec 2015 15:04:52 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Harry Wei <harryxiyou@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?EUC-KR?Q?S=C3=B6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rafael =?EUC-KR?Q?Louren=C3=A7o_de?= Lima Chehab
	<chehabrafael@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Steven Rostedt <rostedt@goodmis.org>,
	Bryan Wu <cooloney@gmail.com>,
	Shraddha Barke <shraddha.6596@gmail.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Junsu Shin <jjunes0@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Navya Sri Nizamkari <navyasri.tech@gmail.com>,
	Nicholas Mc Guire <der.herr@hofr.at>,
	Inki Dae <inki.dae@samsung.com>, linux-doc@vger.kernel.org,
	linux-kernel@zh-kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH 03/10] media framework: rename pads init function to
 media_entity_pads_init()
References: <cover.1449840443.git.mchehab@osg.samsung.com>
 <063476f381aebf981106b7d134348a0a9acc67cc.1449840443.git.mchehab@osg.samsung.com>
In-reply-to: <063476f381aebf981106b7d134348a0a9acc67cc.1449840443.git.mchehab@osg.samsung.com>
Content-type: text/plain; charset=true; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/11/2015 02:34 PM, Mauro Carvalho Chehab wrote:
> With the MC next gen rework, what's left for media_entity_init()
> is to just initialize the PADs. However, certain devices, like
> a FLASH led/light doesn't have any input or output PAD.
>
> So, there's no reason why calling media_entity_init() would be
> mandatory. Also, despite its name, what this function actually
> does is to initialize the PADs data. So, rename it to
> media_entity_pads_init() in order to reflect that.
>
> The media entity actual init happens during entity register,
> at media_device_register_entity(). We should move init of
> num_links and num_backlinks to it.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
[...]
> diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> index 5c686a24712b..13d5a36bc5d8 100644
> --- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
> +++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> @@ -651,7 +651,7 @@ struct v4l2_flash *v4l2_flash_init(
>   	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>   	strlcpy(sd->name, config->dev_name, sizeof(sd->name));
>
> -	ret = media_entity_init(&sd->entity, 0, NULL);
> +	ret = media_entity_pads_init(&sd->entity, 0, NULL);
>   	if (ret < 0)
>   		return ERR_PTR(ret);
>

For this part:

Acked-by: Jacek Anaszewski <j.anaszewski@samsung.com>

-- 
Best Regards,
Jacek Anaszewski
