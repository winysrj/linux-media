Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52338 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbcIGHJP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 03:09:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Subject: Re: [PATCH] v4l: vsp1: Add support for capture and output in HSV formats
Date: Wed, 07 Sep 2016 10:09:44 +0300
Message-ID: <3631828.PadezLxMAk@avalon>
In-Reply-To: <CAPybu_2sKsLNuVbL1Av5DNHjNizw_4wUM_RaVjpvBov5aG-+JQ@mail.gmail.com>
References: <1473207273-16446-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CAPybu_2sKsLNuVbL1Av5DNHjNizw_4wUM_RaVjpvBov5aG-+JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Wednesday 07 Sep 2016 09:07:35 Ricardo Ribalda Delgado wrote:
> Hi Laurent
> 
> Thank you very much!

You're welcome.

> On Wed, Sep 7, 2016 at 2:14 AM, Laurent Pinchart wrote:
> > Support both the HSV24 and HSV32 formats. From a hardware point of view
> > pretend the formats are RGB, the RPF and WPF will just pass the data
> > through without performing any processing.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Do you mean Acked-by ?

Feel free to take the patch in your tree to get it merged along with the HSV 
series.

-- 
Regards,

Laurent Pinchart

