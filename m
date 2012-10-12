Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43543 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933826Ab2JLKSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 06:18:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: Multiple Rectangle cropping
Date: Fri, 12 Oct 2012 12:19:33 +0200
Message-ID: <2102289.5KH0601vIh@avalon>
In-Reply-To: <CAPybu_1HiH69Cf1ORDaEHWWaeTFUMvntLGqa__JS4fE4=B67NQ@mail.gmail.com>
References: <CAPybu_1z8kam1e6ArT9gyX+qybW+6s1K1VdJikuWoYPMjA3q2Q@mail.gmail.com> <20121011223252.GR14107@valkosipuli.retiisi.org.uk> <CAPybu_1HiH69Cf1ORDaEHWWaeTFUMvntLGqa__JS4fE4=B67NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 October 2012 09:18:42 Ricardo Ribalda Delgado wrote:
> Hello
> 
> In fact, is the sensor, the one that supports multiple Areas of
> Interest. Unfortunatelly the userland v4l2 api only supports one area
> of interest for doing croping (or that is what I believe).
> 
> Is there any plan to support multiple AOI? or I have to make my own ioctl?

You should use the selection API (VIDIOC_SUBDEV_G_SELECTION and 
VIDIOC_SUBDEV_S_SELECTION). As a quick hack you can create custom selection 
rectangle types, but it might be worth creating new standard types.

-- 
Regards,

Laurent Pinchart

