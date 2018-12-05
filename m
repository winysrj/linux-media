Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD209C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 22:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 564ED208E7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 22:09:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="pV2BrK19"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 564ED208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ragnatech.se
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbeLEWJx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 17:09:53 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33440 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbeLEWJx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 17:09:53 -0500
Received: by mail-lj1-f196.google.com with SMTP id v1-v6so19839611ljd.0
        for <linux-media@vger.kernel.org>; Wed, 05 Dec 2018 14:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=hA1nUTPXFiA6waXgznXDqMsmWGgiQdVF4OcfvOvBcMM=;
        b=pV2BrK19HFaIWmabG5Ht1Y1nUDBnl+DeWWOoU8voSFMAPFSv6LNlFmV7rsRmnrql5U
         bdIOKIv7NZuTfRZSjq/5fRnHBDkKO7MhbuFAd3Tw+H5enDOyLJUNKv/L6LOklOJAzN4S
         YNC9UNSjCHdZa2GoyN3zv24LlcJm3xou8EyxV2uYB0hrvy1CwA0WXsY9DqeU1gkyj6IJ
         kBMOCgy2pPCR9mb3eVn9mhPEcKjHNCm9IPNN2Fe0SbAlq1+ZXaDdjddmOJXka6yPb6m6
         aYAAZ0LWKPbZT/SI9Y3KtwHvTmysbHPk0QRM2iKIKNdCk8oprswGY3DCvNbCZe46qht3
         ZQGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=hA1nUTPXFiA6waXgznXDqMsmWGgiQdVF4OcfvOvBcMM=;
        b=c2CKRWOiRjTCmIMKF/MOjn1Ao3hj0QslCXDwBDGHs3TGkAckNDICLCpwEA1zGiUazX
         kU6qqPkwofqEQHW/GT1qkSHc7FfZXMMvYPrJo6F5CL1TQb6SywDCzlEgXq7dbe3vtd2t
         77OZI6wh9WSx8L2AEaqf9cKs86FHTc8kPgiwj4+DMpTmo6wccM5h2OpnHLtrHHGKVVwS
         buJVIxXPq+sSFo9cZUX5334Wx6/nChkrZ0PGnbFPqFg6sbnGGr8G4a76nKWb6Ha+cFR/
         boerM+eh57PzcVQ+5ybRh9c8npGitTQBz5jh8WXK8QdrpkSieldfX4uh+SDqNYEzdX44
         bY0A==
X-Gm-Message-State: AA+aEWasMiaiFw67RKEgz89pzAldmnInqIMohaPOjdz2vFwGH8QEL5w3
        cymLApeaeHnlQUHiEhB3ffdFkw==
X-Google-Smtp-Source: AFSGD/V0dIiaoDhitewojuFqQ3Yr00Fb1Z+5mznJ9xENwkqr81tHwyWQCH/OoU/fHX6t6m1nWBUKYw==
X-Received: by 2002:a2e:5c86:: with SMTP id q128-v6mr5545157ljb.119.1544047791076;
        Wed, 05 Dec 2018 14:09:51 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id c133sm4150783lfc.45.2018.12.05.14.09.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Dec 2018 14:09:50 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Wed, 5 Dec 2018 23:09:50 +0100
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 00/30] v4l: add support for multiplexed streams
Message-ID: <20181205220950.GA17972@bigcity.dyn.berto.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181203221628.rzb7sz5purso4uak@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181203221628.rzb7sz5purso4uak@kekkonen.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

Thanks for your feedback.

On 2018-12-04 00:16:29 +0200, Sakari Ailus wrote:
> Hi Niklas,
> 
> On Fri, Nov 02, 2018 at 12:31:14AM +0100, Niklas Söderlund wrote:
> > Hi all,
> > 
> > This series adds support for multiplexed streams within a media device
> > link. The use-case addressed in this series covers CSI-2 Virtual
> > Channels on the Renesas R-Car Gen3 platforms. The v4l2 changes have been
> > a joint effort between Sakari and Laurent and floating around for some
> > time [1].
> > 
> > I have added driver support for the devices used on the Renesas Gen3
> > platforms, a ADV7482 connected to the R-Car CSI-2 receiver. With these
> > changes I can control which of the analog inputs of the ADV7482 the
> > video source is captured from and on which CSI-2 virtual channel the
> > video is transmitted on to the R-Car CSI-2 receiver.
> > 
> > The series adds two new subdev IOCTLs [GS]_ROUTING which allows
> > user-space to get and set routes inside a subdevice. I have added RFC
> > support for these to v4l-utils [2] which can be used to test this
> > series, example:
> > 
> >     Check the internal routing of the adv748x csi-2 transmitter:
> >     v4l2-ctl -d /dev/v4l-subdev24 --get-routing
> >     0/0 -> 1/0 [ENABLED]
> >     0/0 -> 1/1 []
> >     0/0 -> 1/2 []
> >     0/0 -> 1/3 []
> > 
> > 
> >     Select that video should be outputed on VC 2 and check the result:
> >     $ v4l2-ctl -d /dev/v4l-subdev24 --set-routing '0/0 -> 1/2 [1]'
> > 
> >     $ v4l2-ctl -d /dev/v4l-subdev24 --get-routing
> >     0/0 -> 1/0 []
> >     0/0 -> 1/1 []
> >     0/0 -> 1/2 [ENABLED]
> >     0/0 -> 1/3 []
> > 
> > This series is tested on R-Car M3-N and for your testing needs this
> > series is available at
> > 
> >     git://git.ragnatech.se/linux v4l2/mux
> > 
> > * Changes since v1
> > - Rebased on latest media-tree.
> > - Incorporated changes to patch 'v4l: subdev: compat: Implement handling 
> >   for VIDIOC_SUBDEV_[GS]_ROUTING' by Sakari.
> > - Added review tags.
> 
> I was looking at the patches and they seem very nice to me. It's not that
> I've written most of them, but I still. X-)

:-)

> 
> I noticed that the new [GS]_ROUTING interface has no documentation
> currently. Could you write it?

Will add it for the next version. Thanks for pointing this out.

> 
> Also what I'd like to see is the media graph of a device that is driven by
> these drivers. That'd help to better understand the use case also for those
> who haven't worked with the patches.

I will attach the media graph for this simple use-case with the adv7482 
and a more complex case using 8 cameras and GMSL in the next version.

-- 
Regards,
Niklas Söderlund
