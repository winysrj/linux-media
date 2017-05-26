Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61940 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1946586AbdEZBr4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 May 2017 21:47:56 -0400
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Tomasz Figa <tfiga@chromium.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: RE: [PATCH v4] dw9714: Initial driver for dw9714 VCM
Date: Fri, 26 May 2017 01:47:54 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A595AA0A47B@FMSMSX114.amr.corp.intel.com>
References: <1494478820-22199-1-git-send-email-rajmohan.mani@intel.com>
 <CAAFQd5Ck3CKp-JR8d3d1X9-2cRS0oZG9GPwcpunBq50EY7qCtg@mail.gmail.com>
 <CGME20170511143945epcas1p26203dff026b3dc9c2f65c5ca0be7967b@epcas1p2.samsung.com>
 <9fc11dec-8c64-a681-21f9-2602fb1132c1@samsung.com>
 <20170511145913.GI3227@valkosipuli.retiisi.org.uk>
 <8a1a65d6-6b56-6471-1216-b42adcd5a693@samsung.com>
 <20170512115234.GK3227@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170512115234.GK3227@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari, Sylwester,

> >
> > You're right, sorry. I'd expect such things to be better covered in
> > the API documentation.  Probably pm_runtime_put_noidle() is a better
> 
> Well, the documentation tells what the function does. It'd be good if it pointed
> that the usage count needs to be decremented if the function fails.
> 
> I guess the reason is that it's just a synchronous variant of pm_runtime_get(),
> which could not handle the error anyway.
> 
> > match for just decreasing usage_count.  Now many drivers appear to not
> > be balancing usage_count when when pm_runtime_get_sync() fails.
> 
> Ah, quite a few drivers seem to be using pm_runtime_put_noidle() which seems
> to be the correct thing to do as the device won't be on then anyway.
> 

Ack

> --
> Regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
