Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40904 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727165AbeIYTLt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 15:11:49 -0400
Date: Tue, 25 Sep 2018 16:04:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 0/3] Add a glossary and fix some issues at open.rst docs
Message-ID: <20180925130419.vqakvvusm7fcntnu@valkosipuli.retiisi.org.uk>
References: <cover.1537876293.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1537876293.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 25, 2018 at 09:06:50AM -0300, Mauro Carvalho Chehab wrote:
> Those three patches were part of an attempt to add definitions for
> some terms used at the media subsystem:
> 
> 	https://lwn.net/Articles/732022/
> 
> On that time, the first patch generated heated discussions, on terms
> related to mc-centric/vdev-centric. The cern of the discussions were
> how to call the subdev API and the non-subdev API part of the 
> video4linux API.
> 
> I ended by being side-tracked by other things, and didn't have a chance
> to submit an updated version.
> 
> Well, now I'm doing things differently: at the glossary.rst, I removed
> everything related to hardware control. So, it should contain only the
> terms that there aren't any divergences. So, I hope we can manage to
> merge it this time.
> 
> After having this series merged, I'll address again the MC/vdev centric
> hardware control on a separate patchset, perhaps using a different
> approach together with the new glossary definitions related
> to it.
> 
> Mauro Carvalho Chehab (3):
>   media: add glossary.rst with common terms used at V4L2 spec
>   media: open.rst: better document device node naming
>   media: open.rst: remove the minor number range

For patches 2 and 3:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
