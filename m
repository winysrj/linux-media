Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38345 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751088AbcIGHH5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 03:07:57 -0400
MIME-Version: 1.0
In-Reply-To: <1473207273-16446-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473207273-16446-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 7 Sep 2016 09:07:35 +0200
Message-ID: <CAPybu_2sKsLNuVbL1Av5DNHjNizw_4wUM_RaVjpvBov5aG-+JQ@mail.gmail.com>
Subject: Re: [PATCH] v4l: vsp1: Add support for capture and output in HSV formats
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

Thank you very much!

On Wed, Sep 7, 2016 at 2:14 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> Support both the HSV24 and HSV32 formats. From a hardware point of view
> pretend the formats are RGB, the RPF and WPF will just pass the data
> through without performing any processing.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
