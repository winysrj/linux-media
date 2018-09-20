Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35866 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387773AbeIUAcv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 20:32:51 -0400
MIME-Version: 1.0
References: <20180920161912.17063-1-ricardo.ribalda@gmail.com>
 <20180920161912.17063-2-ricardo.ribalda@gmail.com> <20180920184054.lbd77a3w56cflfym@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180920184054.lbd77a3w56cflfym@valkosipuli.retiisi.org.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 20 Sep 2018 20:47:42 +0200
Message-ID: <CAPybu_2teux1qHpL2F+-uojMP+GDVMOaH87vLB1DCmC+gQKTTQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] [media] ad5820: Add support for enable pin
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari

On Thu, Sep 20, 2018 at 8:40 PM Sakari Ailus <sakari.ailus@iki.fi> wrote:
>
> Hi Ricardo,
>
> Thanks for the set! A few comments below...
>
> On Thu, Sep 20, 2018 at 06:19:10PM +0200, Ricardo Ribalda Delgado wrote:
> > This patch adds support for a programmable enable pin. It can be used in
> > situations where the ANA-vcc is not configurable (dummy-regulator), or
> > just to have a more fine control of the power saving.
> >
> > The use of the enable pin is optional
>
> Missing period at the end of the sentence.
>

Thanks for the superfast response.

I have just sent a patch with your comments and also resend 4/4. I was
missing a comma.

Thanks!
> >
