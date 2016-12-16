Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41944
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759756AbcLPKNt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 05:13:49 -0500
Date: Fri, 16 Dec 2016 08:12:12 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab
 references as needed
Message-ID: <20161216081212.33a7c197@vento.lan>
In-Reply-To: <fb4e2e82-bee4-9cb5-eb4e-9d1f5e9abe82@xs4all.nl>
References: <20161109154608.1e578f9e@vento.lan>
        <20161213102447.60990b1c@vento.lan>
        <20161215113041.GE16630@valkosipuli.retiisi.org.uk>
        <7529355.zfqFdROYdM@avalon>
        <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl>
        <fa996ec5-0650-9774-7baf-5eaca60d76c7@osg.samsung.com>
        <47bf7ca7-2375-3dfa-775c-a56d6bd9dabd@xs4all.nl>
        <ea29010f-ffdc-f10f-8b4f-fb1337320863@osg.samsung.com>
        <2f5a7ca0-70d1-c6a9-9966-2a169a62e405@xs4all.nl>
        <b83be9ed-5ce3-3667-08c8-2b4d4cd047a0@osg.samsung.com>
        <fb4e2e82-bee4-9cb5-eb4e-9d1f5e9abe82@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 16 Dec 2016 11:03:09 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> So:
> 
> 1) subdev drivers should disallow unbind
> 2) interface entities should call media_device_unregister_entity() when they
>     are unregistered (if that doesn't already happen)

Sounds like a plan to me.

Thanks,
Mauro
