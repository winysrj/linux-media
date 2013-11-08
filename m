Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f53.google.com ([209.85.128.53]:50155 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab3KHNl6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Nov 2013 08:41:58 -0500
Received: by mail-qe0-f53.google.com with SMTP id cy11so1832108qeb.40
        for <linux-media@vger.kernel.org>; Fri, 08 Nov 2013 05:41:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131108103921.GB25342@valkosipuli.retiisi.org.uk>
References: <1383763336-5822-1-git-send-email-ricardo.ribalda@gmail.com>
 <3183788.gODlx1VQRn@avalon> <CAPybu_1qCzDO15d1X2RAfqip9WepMQ88A=YYRWwJPDf1OxhsDA@mail.gmail.com>
 <20131108103921.GB25342@valkosipuli.retiisi.org.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 8 Nov 2013 14:41:36 +0100
Message-ID: <CAPybu_3GCT2joBHM4_yBAKXj=VQHy67J3sd5+oMVujj9aQV3eQ@mail.gmail.com>
Subject: Re: [PATCH v5] videodev2: Set vb2_rect's width and height as unsigned
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	=?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	"open list:MT9M032 APTINA SE..." <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari

On Fri, Nov 8, 2013 at 11:39 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Fri, Nov 08, 2013 at 11:12:54AM +0100, Ricardo Ribalda Delgado wrote:
> ...
>> Also I am not aware of a reason why clamp_t is better than clamp (I am
>> probably wrong here....). If there is a good reason for not using
>> clamp_t I have no problem in reviewing again the patch and use
>> unsigned constants.
>
> clamp_t() should only be used if you need to force a type for the clamping
> operation. It's always better if you don't have to, and all the arguments
> are of the same type: type casting can have an effect on the end result and
> bugs related to that can be difficult to find.
>

But IMHO in these case, we will cause much more castings in other
places. I find more descriptive a casting via clamp_t, than via ().

Regards!

> --
> Kind regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk



-- 
Ricardo Ribalda
