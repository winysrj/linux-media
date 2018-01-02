Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:39947 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbeABJA2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 04:00:28 -0500
Date: Tue, 2 Jan 2018 10:00:20 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>, geert@glider.be,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-renesas-soc@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-sh@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/9] v4l: i2c: Copy ov772x soc_camera sensor driver
Message-ID: <20180102090020.GC4314@w540>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org>
 <1514469681-15602-7-git-send-email-jacopo+renesas@jmondi.org>
 <CAOFm3uEU1ZegJgjUYXVJCTLRROtJ_KJDgf1-KiHdoJSw-5zd3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOFm3uEU1ZegJgjUYXVJCTLRROtJ_KJDgf1-KiHdoJSw-5zd3Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philippe,
   thanks for the comment,

On Fri, Dec 29, 2017 at 01:47:30PM +0100, Philippe Ombredanne wrote:
> Jacopo,
>
> On Thu, Dec 28, 2017 at 3:01 PM, Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
> > Copy the soc_camera based driver in v4l2 sensor driver directory.
> > This commit just copies the original file without modifying it.
> > No modification to KConfig and Makefile as soc_camera framework
> > dependencies need to be removed first in next commit.
>
> Do you mind using a simpler SPDX identifier instead of this long
> legalese boilerplate?
> This is documented in Thomas doc patches. This applies to your entire
> patch set of course.

Please read the changelogs. In this commit I am just copying the
already in mainline driver with no code changes. I have gathered all
of changes in [7/9] (and in [9/9] for tw9910 driver).

If you look at those patches, you'll notice I have replaced the
license text with the SPDX identifier.

Thanks
    j

> Thanks!
> --
> Cordially
> Philippe Ombredanne
