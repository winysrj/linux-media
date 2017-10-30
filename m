Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54274 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751624AbdJ3NoQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 09:44:16 -0400
Date: Mon, 30 Oct 2017 15:44:13 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Wenyou Yang <wenyou.yang@microchip.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: atmel-isc: Fix clock ID for clk_prepare/unprepare
Message-ID: <20171030134413.swyju4ob5x4vaz66@valkosipuli.retiisi.org.uk>
References: <20171030004650.15571-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171030004650.15571-1-wenyou.yang@microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 30, 2017 at 08:46:50AM +0800, Wenyou Yang wrote:
> Fix the clock ID to do the runtime pm should be ISC_ISPCK,
> instead of ISC_MCK in clk_prepare(), clk_unprepare() and
> isc_clk_is_enabled().
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
