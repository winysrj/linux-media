Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751390AbdFYVTg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 17:19:36 -0400
Subject: Re: [PATCH v3 1/2] v4l: async: check for v4l2_dev in
 v4l2_async_notifier_register()
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170613143036.533-1-niklas.soderlund+renesas@ragnatech.se>
 <20170613143036.533-2-niklas.soderlund+renesas@ragnatech.se>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <13e31393-fabb-4691-64ec-1b5789855884@kernel.org>
Date: Sun, 25 Jun 2017 23:19:32 +0200
MIME-Version: 1.0
In-Reply-To: <20170613143036.533-2-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2017 04:30 PM, Niklas Söderlund wrote:
> Add a check for v4l2_dev to v4l2_async_notifier_register() as to fail as
> early as possible since this will fail later in v4l2_async_test_notify().
> 
> Signed-off-by: Niklas Söderlund<niklas.soderlund+renesas@ragnatech.se>
> Acked-by: Sakari Ailus<sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil<hans.verkuil@cisco.com>

Acked-by: Sylwester Nawrocki <snawrocki@kernel.org>
