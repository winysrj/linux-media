Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234BAC282C2
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 22:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E02412184C
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 22:07:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dEM8zVuY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbfAWWHj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:07:39 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36948 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbfAWWHj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 17:07:39 -0500
Received: by mail-pg1-f196.google.com with SMTP id c25so1700897pgb.4;
        Wed, 23 Jan 2019 14:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1Jk2MMgJQvJPbyt6l2ah4OLc8hnzQ27LONq4lg9xpb0=;
        b=dEM8zVuYjQMrD6G4OX80zfYtRECagwC7SNcCB3RsZ9Arz0BWGul63ooTARHctV3ZH0
         Gh5fCqPPa2eh4wYxknjAswYH6ucLIMDCtN+yKgTMyx92OUPV68md4q0t5Rmyt7a0Hq2M
         924BR6eJyMo+Jbs3bjmFbUDsNdOM80VWi5FjiPOFQIYmfuplLOSxSqty5uZy2mUMtrBF
         5u033PHUVUJ0z/xQtz714AtifX5n1FR5xvr1RdD5zIXxXkXn635Fs7SQ+eY3OZ413aah
         IFobagfyfcKbdaIjmlxBJD3FW/K+un7rXJ0nvU1Jeg7tKyNOWbk5JRDd8VOPwSC/Se8Y
         OPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1Jk2MMgJQvJPbyt6l2ah4OLc8hnzQ27LONq4lg9xpb0=;
        b=Qoq6U8XRTReNaJVg1cWtU6MtdQQ2OU0A87qNukfnUh0ts0/zw2J7fU//PlbpVMGBmb
         JV2Vy0XtLajOegT2GfZg0mRW7eAkN0YHfXdDIHL4+G0sPEq93bULPcniakBLuS2a82FO
         ujO0zrDjUKHuZbLywp1t5a+exQB3Y8Yhyv5DN3zPxRD07rI6m3cPUVIDaWg0nab4k431
         0pZ2zi9Frky9onvD1nBx++LTV7KMycEvKZglFrMcK+CQYuq/HkcvENkK7j1VTKKmV4G3
         4BcY6gtiLsQOYSFBceyy+1Z27BU4u36CrIiDnAa190cyqdERyomz1tfWq308fxup0MGd
         eYiA==
X-Gm-Message-State: AJcUukfAIM7MElrhNWkf6UNy2EoTQdcVavRZFp/MJNsSyrVHJw3f1cNN
        /8XJ3AW89GBmR08KABNMbes=
X-Google-Smtp-Source: ALg8bN7HPw4HTllMqIpS03WMs77ZtohsVG0uwCfzilx2R1ouVBjXYws1Wv+pbg7FM9Mc1PwhkSLxDg==
X-Received: by 2002:a62:e0d8:: with SMTP id d85mr3742687pfm.214.1548281258183;
        Wed, 23 Jan 2019 14:07:38 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id w136sm27394462pfd.169.2019.01.23.14.07.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 23 Jan 2019 14:07:37 -0800 (PST)
Date:   Wed, 23 Jan 2019 14:07:35 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH 1/7] Input: document meanings of KEY_SCREEN and KEY_ZOOM
Message-ID: <20190123220735.GE179701@dtor-ws>
References: <20190118233037.87318-1-dmitry.torokhov@gmail.com>
 <nycvar.YFH.7.76.1901211110190.6626@cbobk.fhfr.pm>
 <CAO-hwJLMKyOeuFyCyaR+zO9BNTDA1pXe35yRF_4nK7ZpOY=3GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO-hwJLMKyOeuFyCyaR+zO9BNTDA1pXe35yRF_4nK7ZpOY=3GQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 21, 2019 at 11:41:32AM +0100, Benjamin Tissoires wrote:
> On Mon, Jan 21, 2019 at 11:11 AM Jiri Kosina <jikos@kernel.org> wrote:
> >
> > On Fri, 18 Jan 2019, Dmitry Torokhov wrote:
> >
> > > It is hard to say what KEY_SCREEN and KEY_ZOOM mean, but historically DVB
> > > folks have used them to indicate switch to full screen mode. Later, they
> > > converged on using KEY_ZOOM to switch into full screen mode and KEY)SCREEN
> > > to control aspect ratio (see Documentation/media/uapi/rc/rc-tables.rst).
> > >
> > > Let's commit to these uses, and define:
> > >
> > > - KEY_FULL_SCREEN (and make KEY_ZOOM its alias)
> > > - KEY_ASPECT_RATIO (and make KEY_SCREEN its alias)
> > >
> > > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > ---
> > >
> > > Please let me know how we want merge this. Some of patches can be applied
> > > independently and I tried marking them as such, but some require new key
> > > names from input.h
> >
> > Acked-by: Jiri Kosina <jkosina@suse.cz>
> 
> Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Mauro, any objections on pushing the media doc patch through my tree?

Thanks.

-- 
Dmitry
