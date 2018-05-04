Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:37326 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbeEDH0v (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 03:26:51 -0400
Received: by mail-oi0-f50.google.com with SMTP id w123-v6so9359657oia.4
        for <linux-media@vger.kernel.org>; Fri, 04 May 2018 00:26:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFwsNOECP74VKYavSo6RBzzohZ1S69=CVjSP_zYDsBXMhyxMjw@mail.gmail.com>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <20180419123244.tujbrkpazbdyows6@flea> <CAFwsNOEV0Q2HjmaoT-m-znD-+0VSfE4tJ2vCPuNpUe2M72ErAA@mail.gmail.com>
 <3075738.A80d5ULHjc@avalon> <CAFwsNOECP74VKYavSo6RBzzohZ1S69=CVjSP_zYDsBXMhyxMjw@mail.gmail.com>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Fri, 4 May 2018 09:26:10 +0200
Message-ID: <CAMZdPi9vWy1cnJ5bVeZ1ProQ_N-jiJ+AwPN3SVJT4qK9_XU80g@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] media: ov5640: Misc cleanup and improvements
To: Sam Bobrowicz <sam@elite-embedded.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> Good news, MIPI is now working on my platform. I had to make several
> changes to how the mipi clocking is calculated in order to get things
> stable, but I think I got it figured out. Maxime's changes were really
> helpful.

Great, I also try to make it work with MIPI-CSI2, If you have found
the magic formula to configure the registers, I would be pleased to
test it on my side.

>
> I will try to get some patches out today or tomorrow that should get
> you up and running.
>
> Maxime, I'd prefer to create the patches myself for the experience.
> I've read all of the submission guidelines and I understand the
> general process, but how should I submit them to the mailing list
> since they are based to your patches, which are still under review?
> Should I send the patch series to the mailing list myself and just
> mention this patch series, maybe with the In-Reply-To header? Or
> should I just post a link to them here so you can review them and add
> them to a new version of your patch series?

Yes, I think your patch(es) should be integrated in the Maxime's series.

Regards,
Loic
