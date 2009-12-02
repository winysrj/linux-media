Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2620 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbZLBCuN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 21:50:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: linux-media documentation fails to build
Date: Wed, 2 Dec 2009 08:18:26 +0530
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <A69FA2915331DC488A831521EAE36FE40155B76C14@dlee06.ent.ti.com> <A69FA2915331DC488A831521EAE36FE40155B76C37@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40155B76C37@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912020818.27071.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 02 December 2009 04:17:12 Karicheri, Muralidharan wrote:
> Some body removed media-spec target from v4l/Makefile.
>
> I got it working with make spec.
>
> Why to change target name like this?

I always used 'make spec'. The 'make media-spec' was probably introduced when 
the v4l and dvb docs were merged. Since I recently removed the old v4l2-spec 
and dvb-spec make targets I also removed the media-spec target since there was 
no need for it anymore. Just the 'spec' target is needed, as it always was.

Regards,

	Hans

>
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> phone: 301-407-9583
> email: m-karicheri2@ti.com
>
> >-----Original Message-----
> >From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >owner@vger.kernel.org] On Behalf Of Karicheri, Muralidharan
> >Sent: Tuesday, December 01, 2009 5:28 PM
> >To: linux-media@vger.kernel.org
> >Cc: Mauro Carvalho Chehab; Hans Verkuil
> >Subject: linux-media documentation fails to build
> >
> >Hi,
> >
> >I had downloaded the v4l2-dvb tree few days back to create my video
> > timings API documentation and it had compiled fine when I did,
> >
> >make media-spec
> >
> >I still can build using the old tar ball. But today, I downloaded v4l-dvb-
> >e0cd9a337600.tar.gz, it fails immediately after running the
> >make_myconfig.pl script with the error
> >
> >"No rule to make target 'media-spec'. Stop
> >
> >Has something changed last few days that broke the build?
> >
> >I need to make updates to video timing API documentation based on Han's
> >review comments and I am stuck at this issue now :(
> >
> >Murali Karicheri
> >Software Design Engineer
> >Texas Instruments Inc.
> >Germantown, MD 20874
> >phone: 301-407-9583
> >email: m-karicheri2@ti.com
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html

