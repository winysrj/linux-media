Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47515 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332AbbBQMr4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 07:47:56 -0500
Message-ID: <54E33877.5060601@linux.intel.com>
Date: Tue, 17 Feb 2015 14:47:51 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] media/v4l2-ctrls: Always run s_ctrl on volatile ctrls
References: <1424175681-19787-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1424175681-19787-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thanks for the patch!

Ricardo Ribalda Delgado wrote:
> Volatile controls can change their value outside the v4l-ctrl framework.
> We should ignore the cached written value of the ctrl when evaluating if
> we should run s_ctrl.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
