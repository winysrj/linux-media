Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54510
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753449AbdIDLqX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 07:46:23 -0400
Date: Mon, 4 Sep 2017 08:46:16 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Honza =?UTF-8?B?UGV0cm91xaE=?= <jpetrous@gmail.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 00/26] Improve DVB documentation and reduce its gap
Message-ID: <20170904084309.7382864a@recife.lan>
In-Reply-To: <CAJbz7-24qJ8Qz9V_KArhn4uf_3fJwaDcGS399JCZ7nz2O_oBGQ@mail.gmail.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
        <CAJbz7-29pV9u0UZUC+sUtncsCbqbjNToA-yANJ7hExLRFw_tiQ@mail.gmail.com>
        <20170903215404.425af4aa@vento.lan>
        <CAJbz7-2EBp0U=jdQ6QyFmkNS=PSVNDrKGj1_H0RAEMmJsoxa8Q@mail.gmail.com>
        <20170904060629.2f8feeab@vento.lan>
        <CAJbz7-24qJ8Qz9V_KArhn4uf_3fJwaDcGS399JCZ7nz2O_oBGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 4 Sep 2017 11:40:59 +0200
Honza Petrouš <jpetrous@gmail.com> escreveu:

> > So, IMHO, the interface is broken by design. Perhaps that's
> > the reason why no upstream driver uses it.  
> 
> I have the same feeling regarding brokenness.
> 
> >
> > What seems to be a much better design would be to use the demux
> > set filter ioctls and route the PIDs to the right CA.
> >  
> 
> I don't have access to any programmer reference documentation
> for any modern DVB-enabled SoC, but I see two possible scenario
> of connecting descramblers to the demuxes (most of modern SoCs
> have more then one demux) - static one, when every demux has
> predefined descramblers already connected to it and dynamic ones,
> when any descrambler can be connected to the any demux.

I don't have access to the documentation either, but I know
some designs that have multiple demods that are dynamically set.
Some hardware even allow to dynamically change the maximum amount
of filters per demod at runtime.

> From that reason I vote to have some descrambler specific ioctl,
> which allow more flexibility then if we add it to the filter set ioctl.

I suspect that doing it at the demod does a lot more sense.

Anyway, someone should come with a driver requiring it upstream
for us to discuss and find the better alternatives to support.

Thanks,
Mauro
