Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40930 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932163AbcJQSuc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 14:50:32 -0400
Date: Mon, 17 Oct 2016 20:50:25 +0100
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 54/57] [media] platform: don't break long lines
Message-ID: <20161017195025.GC21569@stationary.pb.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
 <3227277.L9jDJkdF0E@avalon>
 <20161017193945.GA21569@stationary.pb.com>
 <1555833.ll1z87MvFR@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1555833.ll1z87MvFR@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 17, 2016 at 09:44:19PM +0300, Laurent Pinchart wrote:
> Hi Andrey,
> 
> On Monday 17 Oct 2016 20:39:45 Andrey Utkin wrote:
> > Maybe the remaining manual work may be outsourced to seekers of janitor
> > tasks?
> 
> I'm fine with that, but we should rework the original patches, not merge fixes 
> on top of them.

I haven't meant that :) What I had in mind was a singular patchset with
combination of automated and manual work, just as you say, I just didn't
state it clearly.
