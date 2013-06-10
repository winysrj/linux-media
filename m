Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55461 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3FJJsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 05:48:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] mt9p031: Use bulk regulator API
Date: Mon, 10 Jun 2013 11:48:30 +0200
Message-ID: <15234200.VFxHPLf0eZ@avalon>
In-Reply-To: <CAOMZO5DQyeUYVdK0X0OsG51MkGjbN8d_51DW_zhVBZOHLptOQw@mail.gmail.com>
References: <1370678120-24278-1-git-send-email-laurent.pinchart@ideasonboard.com> <CAOMZO5DQyeUYVdK0X0OsG51MkGjbN8d_51DW_zhVBZOHLptOQw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On Saturday 08 June 2013 10:20:42 Fabio Estevam wrote:
> On Sat, Jun 8, 2013 at 4:55 AM, Laurent Pinchart wrote:
> > -       if (IS_ERR(mt9p031->vaa) || IS_ERR(mt9p031->vdd) ||
> > -           IS_ERR(mt9p031->vdd_io)) {
> > +       ret = devm_regulator_bulk_get(&client->dev, 3,
> > mt9p031->regulators); +       if (ret < 0) {
> > 
> >                 dev_err(&client->dev, "Unable to get regulators\n");
> >                 return -ENODEV;
> 
> You should do a 'return ret' here instead.

Good point, I'll fix that.

-- 
Regards,

Laurent Pinchart

