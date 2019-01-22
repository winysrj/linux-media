Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8EE3C37124
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 00:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B67CC2089F
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 00:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548116364;
	bh=lN3AhrWOK1+g7P2zBNux+Cd4POCtJyJpbZgLuC0hTN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=tsaMkWzl3e2TSYMkEhNHhg9YQfBIfNu9cqGNK6jPNv6i7MjW37qazgYtX75+xlkvc
	 aQtKa6Q+NzCMWIJJ5iq+d1KsdQrrfJtVWRxb8ku8ugg4Ynh2NLQ+e2l2NdmOZiGpgW
	 h0QW8oG5wGD1kwFA9Qg0m26T/6m4+468UP8ujS9A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbfAVATU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 19:19:20 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37985 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfAVATU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 19:19:20 -0500
Received: by mail-ot1-f67.google.com with SMTP id e12so22121564otl.5;
        Mon, 21 Jan 2019 16:19:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5uCyXnnGfFbiQg6fSTWCRBCQgl6eqCHGAfdzWE9E2OY=;
        b=cZhGsUtVQpwpset7L6PLRoXBz0J9Q6sSX8uPBplCOsuM5hffEqrHl6+TLE1r4gNJbZ
         ucwiX7Qfz+euXEN7brW8iNFkTQYO+aXzVSu6P5GvM6Jv1Mv3r4A4DzKhS38oLdNg4kpT
         f6T/GVrRv5gR58JEVchy47XVn5UhVXXAv2K//FDtUaTZLPdxe+bRwanvl6ujFsIbVwpa
         iIvXqBmqwtwhCBIs6ohZ7AAZvVCW05u3omCYYL6ptIWQKdDVz+nWwzP8imCVQhFbJcTC
         l/u5PkfoQVIdkT4Gdsojqww3o4e7y/l9rKqoGcUTZ/0rgNGpQ7u99SLM06b6qSMn9dp9
         c6lg==
X-Gm-Message-State: AJcUukdVH4n2R9u1FTT9c+f9BYV1yMBZS6jvZ7F7KsiD+5ZPb3YayBWJ
        x7qQaOArdmQlvtKQHuhuLw==
X-Google-Smtp-Source: ALg8bN5tGyQfgsz8Qibh5c9U/V1vKGStMgN7eNkGmxtb8BiQO+UrRmQ9ow9YayylM9E6/Hs3EDyNIA==
X-Received: by 2002:a9d:77d4:: with SMTP id w20mr20274216otl.196.1548116359080;
        Mon, 21 Jan 2019 16:19:19 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id l20sm6204181otp.47.2019.01.21.16.19.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 21 Jan 2019 16:19:18 -0800 (PST)
Date:   Mon, 21 Jan 2019 18:19:17 -0600
From:   Rob Herring <robh@kernel.org>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 1/3] media: dt: bindings: sunxi-ir: Add A64 compatible
Message-ID: <20190122001917.GA31407@bogus>
References: <20190111173015.12119-1-jernej.skrabec@siol.net>
 <20190111173015.12119-2-jernej.skrabec@siol.net>
 <CAGb2v66DiqK9sL-hQev4Wy08d9T7f1Yc2DFWJ0gYOnqChJyBRw@mail.gmail.com>
 <20190121095014.b6iq5dubfi7x2pi4@flea>
 <CAGb2v66d0wM8Yt2uS4MMhU6PP02h8CKwKjinasO6jtZ4ue1CAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGb2v66d0wM8Yt2uS4MMhU6PP02h8CKwKjinasO6jtZ4ue1CAQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 21, 2019 at 05:57:57PM +0800, Chen-Yu Tsai wrote:
> On Mon, Jan 21, 2019 at 5:50 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> >
> > Hi,
> >
> > I'm a bit late to the party, sorry for that.
> >
> > On Sat, Jan 12, 2019 at 09:56:11AM +0800, Chen-Yu Tsai wrote:
> > > On Sat, Jan 12, 2019 at 1:30 AM Jernej Skrabec <jernej.skrabec@siol.net> wrote:
> > > >
> > > > A64 IR is compatible with A13, so add A64 compatible with A13 as a
> > > > fallback.
> > >
> > > We ask people to add the SoC-specific compatible as a contigency,
> > > in case things turn out to be not so "compatible".
> > >
> > > To be consistent with all the other SoCs and other peripherals,
> > > unless you already spotted a "compatible" difference in the
> > > hardware, i.e. the hardware isn't completely the same, this
> > > patch isn't needed. On the other hand, if you did, please mention
> > > the differences in the commit log.
> >
> > Even if we don't spot things, since we have the stable DT now, if we
> > ever had that compatible in the DT from day 1, it's much easier to
> > deal with.
> >
> > I'd really like to have that pattern for all the IPs even if we didn't
> > spot any issue, since we can't really say that the datasheet are
> > complete, and one can always make a mistake and overlook something.
> >
> > I'm fine with this version, and can apply it as is if we all agree.
> 
> I'm OK with having the fallback compatible. I'm just pointing out
> that there are and will be a whole bunch of them, and we don't need
> to document all of them unless we are actually doing something to
> support them.

Yes, you do. Otherwise, how will we validate what is and isn't a valid 
set of compatible strings? It's not required yet, but bindings are 
moving to json-schema.

Rob
