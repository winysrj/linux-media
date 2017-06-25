Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751359AbdFYVW6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 17:22:58 -0400
Subject: Re: [PATCH v3 2/2] v4l: async: add subnotifier registration for
 subdevices
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
 <20170613143036.533-3-niklas.soderlund+renesas@ragnatech.se>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <78b6c3f2-7b4c-b2ff-aca9-6057b9d60056@kernel.org>
Date: Sun, 25 Jun 2017 23:22:53 +0200
MIME-Version: 1.0
In-Reply-To: <20170613143036.533-3-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2017 04:30 PM, Niklas Söderlund wrote:
> When the registered() callback of v4l2_subdev_internal_ops is called the
> subdevice has access to the master devices v4l2_dev and it's called with
> the async frameworks list_lock held. In this context the subdevice can
> register its own notifiers to allow for incremental discovery of
> subdevices.
> 
> The master device registers the subdevices closest to itself in its
> notifier while the subdevice(s) register notifiers for their closest
> neighboring devices when they are registered. Using this incremental
> approach two problems can be solved:
> 
> 1. The master device no longer has to care how many devices exist in
>     the pipeline. It only needs to care about its closest subdevice and
>     arbitrary long pipelines can be created without having to adapt the
>     master device for each case.
> 
> 2. Subdevices which are represented as a single DT node but register
>     more than one subdevice can use this to improve the pipeline
>     discovery, since the subdevice driver is the only one who knows which
>     of its subdevices is linked with which subdevice of a neighboring DT
>     node.
> 
> To enable subdevices to register/unregister notifiers from the
> registered()/unregistered() callback v4l2_async_subnotifier_register()
> and v4l2_async_subnotifier_unregister() are added. These new notifier
> register functions are similar to the master device equivalent functions
> but run without taking the v4l2-async list_lock which already is held
> when the registered()/unregistered() callbacks are called.
> 
> Signed-off-by: Niklas Söderlund<niklas.soderlund+renesas@ragnatech.se>
> Acked-by: Hans Verkuil<hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus<sakari.ailus@linux.intel.com>

Acked-by: Sylwester Nawrocki <snawrocki@kernel.org>
