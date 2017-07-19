Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:44183 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752500AbdGSLCS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 07:02:18 -0400
Subject: Re: [PATCH v5 0/4] v4l2-async: add subnotifier registration for
 subdevices
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <20170719104946.7322-1-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5e25930e-b249-6d92-1c7e-36266754f3cb@xs4all.nl>
Date: Wed, 19 Jul 2017 13:02:14 +0200
MIME-Version: 1.0
In-Reply-To: <20170719104946.7322-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/07/17 12:49, Niklas Söderlund wrote:
> * Changes since v4
> - Add patch which aborts v4l2_async_notifier_unregister() if the memory 
>   allocation for the device cache fails instead of trying to do as much 
>   as possible but still leave the system in a semi good state.

Since you are working with this code I would very much appreciate it if you
can make another patch that adds comments to this reprobing stuff, including
why device_reprobe() cannot be used here.

That will help in the future.

Regards,

	Hans
