Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55002 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbbIJRjs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2015 13:39:48 -0400
Subject: Re: [PATCH 2/2] [media] media-device: split media initialization and
 registration
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Cc: Luis de Bethencourt <luis@debethencourt.com>,
	linux-sh@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?Q?S=c3=b6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
	linux-samsung-soc@vger.kernel.org,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	linux-arm-kernel@lists.infradead.org,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Antti Palosaari <crope@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>
References: <1441890195-11650-1-git-send-email-javier@osg.samsung.com>
 <1441890195-11650-3-git-send-email-javier@osg.samsung.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <55F1C04C.1040906@linux.intel.com>
Date: Thu, 10 Sep 2015 20:39:24 +0300
MIME-Version: 1.0
In-Reply-To: <1441890195-11650-3-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Javier Martinez Canillas wrote:
> Also, add a media_entity_cleanup() function that will destroy the
> graph_mutex that is initialized in media_entity_init().

media_device_init() and media_device_cleanup()?

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
