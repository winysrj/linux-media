Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33701 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbcCKLDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 06:03:22 -0500
Received: by mail-lb0-f172.google.com with SMTP id k15so152052400lbg.0
        for <linux-media@vger.kernel.org>; Fri, 11 Mar 2016 03:03:21 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 11 Mar 2016 12:03:18 +0100
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	ulrich.hecht@gmail.com, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCHv2] [media] rcar-vin: add Renesas R-Car VIN driver
Message-ID: <20160311110318.GD1111@bigcity.dyn.berto.se>
References: <1456282709-13861-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
 <56D414D9.4090303@xs4all.nl>
 <56E28148.1030508@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56E28148.1030508@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 2016-03-11 09:26:48 +0100, Hans Verkuil wrote:
> Hi Niklas,
> 
> On 02/29/2016 10:52 AM, Hans Verkuil wrote:
> > Hi Niklas,
> > 
> > Thanks for your patch! Much appreciated.
> > 
> > I have more comments for the v2, but nothing really big :-)
> > 
> 
> Just checking, you are working on a v3, right? I'd really like to get this in
> for kernel 4.7.

Yes I had to switch focus for a bit but now I'm back working on this 
again today.

I have some trouble getting NV16 to work. I can't get it to work using 
soc_camera driver either, or more accurate I get the same output broken 
rendering in qv4l2. What would you say is better drop NV16 support form 
the driver or keep it as is since it is compatible with the soc_camera 
drivers implementation? I would like to keep it in the driver for now 
since it at least works as good as in soc_camera.

-- 
Regards,
Niklas S�derlund
