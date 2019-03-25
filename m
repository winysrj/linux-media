Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D2EC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 21:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 952AF20693
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 21:47:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="eHS0zK4A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbfCYVrl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 17:47:41 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39942 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730063AbfCYVrl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 17:47:41 -0400
Received: by mail-pf1-f195.google.com with SMTP id c207so7060487pfc.7
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2019 14:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2Gg4xL4ScPNssnTqg8moxH66eUohXt4Ejl4Gc/tB5ek=;
        b=eHS0zK4Adx8x/59ecitIEiElI1ln3WUssGpHFk63TAYzEShMhs5pzHhIleccTbKAj1
         0fCt6U+QFPjxxXMtYSmIa8RotPRJ39Ej41YbWJxCfHNOEbxV1XXX0/nrp3HEDQQLjLDU
         WtthA56iyt+eo5GV1LFMUhCRtIuIrqxsyoaYs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2Gg4xL4ScPNssnTqg8moxH66eUohXt4Ejl4Gc/tB5ek=;
        b=VIzvxZIleFJdeOX34J9mQBXdqtXQNtpXbg+zEBgFljA2nRWpOp0/S59nihFA5V0YrK
         YCIo4540fObaiGwvGcukUt/wSqQ4pBy0gLANwaFmq1RdcOBveeXiR8o/AxPjT2GRXPjT
         TbqMC+v84Qby8x+cZJKucbfuojrOusHmp49mLbC4hdXYzxrULctkaOZd37qexn+6oHte
         1UZxI33lyfvQbOh671PpcaalByXKe+VT0/G00ag53IugQowC71HnbR5FCC6Cq55wwXoL
         WieS2U18lSMgP2V2S0o3XSpmwcPR3WjGWBB5wwh71XyzoXpgHOeR6H10mMzEqfuEqdGu
         KK1w==
X-Gm-Message-State: APjAAAUycw9v+CECrqSj7ONWHvhOfJT3m279SF9n0rSDfjZ0iYHGtRum
        NL3CkRU1tfX3TEyTO8+C/Box7g==
X-Google-Smtp-Source: APXvYqxB/oJKwSh7Cdv/C4pYO/etfLPkQ4Yn5f2dIGIS+2Bn4X0IfdJpL14tzfn2Hwak106n9/LYhg==
X-Received: by 2002:a62:b61a:: with SMTP id j26mr25924312pff.151.1553550460844;
        Mon, 25 Mar 2019 14:47:40 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id v19sm29523577pfa.138.2019.03.25.14.47.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 14:47:39 -0700 (PDT)
Date:   Mon, 25 Mar 2019 17:47:38 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Chenbo Feng <fengc@google.com>
Cc:     Sandeep Patil <sspatil@android.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, kernel-team@android.com,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Erick Reyes <erickreyes@google.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC v2 1/3] dma-buf: give each buffer a full-fledged inode
Message-ID: <20190325214738.GB16969@google.com>
References: <20190322025135.118201-1-fengc@google.com>
 <20190322025135.118201-2-fengc@google.com>
 <20190322150255.GA76423@google.com>
 <20190324175633.GA5826@google.com>
 <20190324204454.GA102207@google.com>
 <CAMOXUJmB50ChULNFYQuamzyw1iiLaQ7GTL-fukom82p=VFgngg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMOXUJmB50ChULNFYQuamzyw1iiLaQ7GTL-fukom82p=VFgngg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Mar 25, 2019 at 12:34:59PM -0700, Chenbo Feng wrote:
[snip]
> > > > Also what is the benefit of having st_blocks from stat? AFAIK, that is the
> > > > same as the buffer's size which does not change for the lifetime of the
> > > > buffer. In your patch you're doing this when 'struct file' is created which
> > > > AIUI is what reflects in the st_blocks:
> > > > +   inode_set_bytes(inode, dmabuf->size);
> > >
> > > Can some of the use cases / data be trimmed down? I think so. For example, I
> > > never understood what we do with map_files here (or why). It is perfectly
> > > fine to just get the data from /proc/<pid>/fd and /proc/<pid>/maps. I guess
> > > the map_files bit is for consistency?
> >
> > It just occured to me that since /proc/<pid/maps provides an inode number as
> > one of the fields, so indeed an inode per buf is a very good idea for the
> > user to distinguish buffers just by reading /proc/<pid/<maps> alone..
> >
> > I also, similar to you, don't think map_files is useful for this usecase.
> > map_files are just symlinks named as memory ranges and pointing to a file. In
> > this case the symlink will point to default name "dmabuf" that doesn't exist.
> > If one does stat(2) on a map_file link, then it just returns the inode number
> > of the symlink, not what the map_file is pointing to, which seems kind of
> > useless.
> >
> I might be wrong but I don't think we did anything special for the
> map_files in this patch. I think the confusion might be from commit
> message where Greg mentioned the map_files to describe the behavior of
> shmem buffer when comparing it with dma-buf. The file system
> implementation and the file allocation action in this patch are just
> some minimal effort to associate each dma_buf object with an inode and
> properly populate the size information in the file object. And we
> didn't use proc/pid/map_files at all in the android implementation
> indeed.

You are right.

> > > > I am not against adding of inode per buffer, but I think we should have this
> > > > debate and make the right design choice here for what we really need.
> > >
> > > sure.
> >
> > Right, so just to summarize:
> > - The intention here is /proc/<pid>/maps will give uniqueness (via the inode
> >   number) between different memory ranges. That I think is the main benefit
> >   of the patch.
> > - stat gives the size of buffer as does fdinfo
> > - fdinfo is useful to get the reference count of number of sharers of the
> >   buffer.
> > - map_files is not that useful for this usecase but can be made useful if
> >   we can name the underlying file's dentry to something other than "dmabuf".
> > - GET_NAME is not needed since fdinfo already has the SET_NAMEd name.
> >
> > Do you agree?
> >
> Thanks for summarize it, I will look into the GET_NAME/SET_NAME ioctl
> to make it more useful as you suggested above. Also, I will try to add
> some test to verify the behavior.

Sounds great, thanks!

 - Joel

