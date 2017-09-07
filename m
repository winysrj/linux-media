Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:32966 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754350AbdIGHvb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Sep 2017 03:51:31 -0400
Date: Thu, 7 Sep 2017 10:51:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v8 12/21] v4l: async: Introduce helpers for calling async
 ops callbacks
Message-ID: <20170907075128.2rhfymo6jnzdt33d@valkosipuli.retiisi.org.uk>
References: <20170905130553.1332-1-sakari.ailus@linux.intel.com>
 <20170905130553.1332-13-sakari.ailus@linux.intel.com>
 <a341b599-de8f-49d2-6e83-fc049fad3904@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a341b599-de8f-49d2-6e83-fc049fad3904@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 06, 2017 at 09:50:36AM +0200, Hans Verkuil wrote:
> On 09/05/2017 03:05 PM, Sakari Ailus wrote:
> > Add three helper functions to call async operations callbacks. Besides
> > simplifying callbacks, this allows async notifiers to have no ops set,
> > i.e. it can be left NULL.
> 
> What is the use-case of that?

Going forward, the sub-notifiers that are just for binding associated
devices (later in the patchset, 17th and 18th patches) there is no need for
callbacks. This allows having no ops either.

> 
> Anyway:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
