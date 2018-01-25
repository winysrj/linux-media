Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53728 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751138AbeAYKTu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 05:19:50 -0500
Date: Thu, 25 Jan 2018 12:19:47 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH] v4l2-dev.h: fix symbol collision in
 media_entity_to_video_device()
Message-ID: <20180125101947.h6olmmmmbafot6e3@valkosipuli.retiisi.org.uk>
References: <20180125003430.18558-1-niklas.soderlund+renesas@ragnatech.se>
 <CAMuHMdVH8vHN3Q0zCKRn_KnfKf8P7yhqSSKjASp=u6qCZHzkNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdVH8vHN3Q0zCKRn_KnfKf8P7yhqSSKjASp=u6qCZHzkNg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

On Thu, Jan 25, 2018 at 08:59:35AM +0100, Geert Uytterhoeven wrote:
> Hi Niklas,
> 
> On Thu, Jan 25, 2018 at 1:34 AM, Niklas Söderlund
> <niklas.soderlund+renesas@ragnatech.se> wrote:
> > A recent change to the media_entity_to_video_device() macro breaks some
> > use-cases for the macro due to a symbol collision. Before the change
> > this worked:
> >
> >     vdev = media_entity_to_video_device(link->sink->entity);
> >
> > While after the change it results in a compiler error "error: 'struct
> > video_device' has no member named 'link'; did you mean 'lock'?". While
> > the following still works after the change.
> >
> >     struct media_entity *entity = link->sink->entity;
> >     vdev = media_entity_to_video_device(entity);
> >
> > Fix the collision by renaming the macro argument to 'media_entity'.
> 
> Thanks!
> Given there also exists a "struct media_entity", using "_media_entity" seems
> safe to me.

That doesn't matter, does it? As long as the macro argument is used as a
field name of a struct. I.e. "__entity" would be fine, as well as "e". I'd
vote for __entity. :-)

In any case,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
