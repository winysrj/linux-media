Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:34116 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbbIJOQK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 10:16:10 -0400
Received: by ykdg206 with SMTP id g206so58468278ykd.1
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2015 07:16:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <06bad8b26ee0cef02d9c52d578af3a51a0f03b1f.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<06bad8b26ee0cef02d9c52d578af3a51a0f03b1f.1440902901.git.mchehab@osg.samsung.com>
Date: Thu, 10 Sep 2015 16:16:10 +0200
Message-ID: <CABxcv=mdyshSH5wzRRJHnhiavr_m74=Ax07=JzSTO1uxiCmJtA@mail.gmail.com>
Subject: Re: [PATCH v8 10/55] [media] media: rename the function that create
 pad links
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Rafael_Louren=C3=A7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>, Shuah Khan <shuahkh@osg.samsung.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Olli Salonen <olli.salonen@iki.fi>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Navya Sri Nizamkari <navyasri.tech@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	anuvazhayil <anuv.1994@gmail.com>,
	Mahati Chamarthy <mahati.chamarthy@gmail.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Jiayi Ye <yejiayily@gmail.com>,
	Wolfram Sang <wsa@the-dreams.de>,
	Heena Sirwani <heenasirwani@gmail.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>, linux-sh@vger.kernel.org,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 30, 2015 at 5:06 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> With the new API, a link can be either between two PADs or between an interface
> and an entity. So, we need to use a better name for the function that create
> links between two pads.
>
> So, rename the such function to media_create_pad_link().
>
> No functional changes.
>
> This patch was created via this shell script:
>         for i in $(find drivers/media -name '*.[ch]' -type f) $(find drivers/staging/media -name '*.[ch]' -type f) $(find include/ -name '*.h' -type f) ; do sed s,media_entity_create_link,media_create_pad_link,g <$i >a && mv a $i; done
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
