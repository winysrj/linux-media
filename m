Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:58564 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727130AbeH1ObJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 10:31:09 -0400
Date: Tue, 28 Aug 2018 12:40:04 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: v4l2-subdev.h: allow
        V4L2_FRMIVAL_TYPE_CONTINUOUS & _STEPWISE
Message-ID: <20180828104004.GA5258@frolo.macqel>
References: <1535442907-8659-1-git-send-email-phdm@macqel.be> <7bfc83d5-92dd-a604-35a6-4dc659feb7b5@xs4all.nl> <20180828102610.GA31307@frolo.macqel> <e5379767-5bf4-e0bb-e952-1e7afd39e1a9@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5379767-5bf4-e0bb-e952-1e7afd39e1a9@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Aug 28, 2018 at 12:29:21PM +0200, Hans Verkuil wrote:
> On 28/08/18 12:26, Philippe De Muyter wrote:
> > Hi Hans,
> > 
> > On Tue, Aug 28, 2018 at 12:03:25PM +0200, Hans Verkuil wrote:
> >> This is a bit too magical for my tastes. I'd add a type field:
> >>
> >> #define V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE 0
> >> #define V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS 1
> >> #define V4L2_SUBDEV_FRMIVAL_TYPE_STEPWISE 2

Should I put that in an enum like 'enum v4l2_subdev_format_whence'
or use simple define's ?

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
