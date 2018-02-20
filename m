Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:43336 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbeBTSSR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Feb 2018 13:18:17 -0500
Received: by mail-qk0-f177.google.com with SMTP id i184so17596964qkf.10
        for <linux-media@vger.kernel.org>; Tue, 20 Feb 2018 10:18:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3383770.t3Sncl0gtc@avalon>
References: <CAKTMqxtRQvZqZGQ0oWSf79b3ZGs6Stpctx9yqi8X1Myq-CY2JA@mail.gmail.com>
 <dd70c226-e7db-e55e-e467-a6b0d1e7849d@ideasonboard.com> <alpine.DEB.2.20.1802191456110.8694@axis700.grange>
 <3383770.t3Sncl0gtc@avalon>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Tue, 20 Feb 2018 13:18:16 -0500
Message-ID: <CAGoCfiy296wh1u+LE-RoSVVzc8kNKngDvne-R2cDdOBM9LtVfg@mail.gmail.com>
Subject: Re: Bug: Two device nodes created in /dev for a single UVC webcam
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
        <axdoomer@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Feb 19, 2018 at 11:19 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> I've tested VLC (2.2.8) and haven't noticed any issue. If a program is
> directed to the metadata video node and tries to capture video from it it will
> obviously fail. That being said, software that work today should continue
> working, otherwise it's a regression, and we'll have to handle that.

Perhaps it shouldn't be a video node then (as we do with VBI devices).
Would something like /dev/videometadataX would be more appropriate?

People have for years operated under the expectation that /dev/videoX
nodes are video nodes.  If we're going to be creating things with that
name which aren't video nodes then that is going to cause considerable
confusion as well as messing up all sorts of existing applications
which operate under that expectation.

I know that some of the older PCI boards have always exposed a bunch
of video nodes for various things (i.e. raw video vs. mpeg, etc), but
because USB devices have traditionally been simpler they generally
expose only one node of each type (i.e. one /dev/videoX, /dev/vbiX
/dev/radioX).  I've already gotten an email from a customer who has a
ton of scripts which depend on this behavior, so please seriously
consider the implications of this design decision.

It's easy to brush this off as "all the existing applications will
eventually be updated", but you're talking about changing the basic
behavior of how these device nodes have been presented for over a
decade.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
