Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55570 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715Ab2J2L2l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 07:28:41 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so6338604iea.19
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2012 04:28:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <508E6644.4040104@samsung.com>
References: <1351506118-2385-1-git-send-email-mchehab@redhat.com>
	<508E6644.4040104@samsung.com>
Date: Mon, 29 Oct 2012 08:28:40 -0300
Message-ID: <CALF0-+WKxg=k8BeUfCf5qhYGOviKw_8+D=WXvPCaR0fVJuyONw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix a few more warnings
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 29, 2012 at 8:19 AM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 10/29/2012 11:21 AM, Mauro Carvalho Chehab wrote:
>> Hans Verkuil yesterday's build still got two warnings at the
>> generic drivers:
>>         http://hverkuil.home.xs4all.nl/logs/Sunday.log
>>
>> They didn't appear at i386 build probably because of some
>> optimization done there.
>>
>> Anyway, fixing them are trivial, so let's do it.
>>
>> After applying those patches, the only drivers left producing
>> warnings are the following platform drivers:
>>
>> drivers/media/platform/davinci/dm355_ccdc.c
>> drivers/media/platform/davinci/dm644x_ccdc.c
>> drivers/media/platform/davinci/vpbe_osd.c
>> drivers/media/platform/omap3isp/ispccdc.c
>> drivers/media/platform/omap3isp/isph3a_aewb.c
>> drivers/media/platform/omap3isp/isph3a_af.c
>> drivers/media/platform/omap3isp/isphist.c
>> drivers/media/platform/omap3isp/ispqueue.c
>> drivers/media/platform/omap3isp/ispvideo.c
>> drivers/media/platform/omap/omap_vout.c
>> drivers/media/platform/s5p-fimc/fimc-capture.c
>> drivers/media/platform/s5p-fimc/fimc-lite.c
>
> For these two files I've sent already a pull request [1], which
> includes a fixup patch
> s5p-fimc: Don't ignore return value of vb2_queue_init()
>
> BTW, shouldn't things like these be taken care when someone does
> a change at the core code ? I'm not having issues in this case at all,
> but if there is many people doing constantly changes at the core it
> might imply for driver authors/maintainers wasting much of their time
> for fixing issues resulting from constant changes at the base code.
>

Indeed. When I changed vb2_queue_init() to return something,
I went and fix every user. I don't know why I missed those.

My bad,

    Ezequiel
