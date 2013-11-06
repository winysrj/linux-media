Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:34957 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab3KFP4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 10:56:32 -0500
Received: by mail-oa0-f43.google.com with SMTP id m1so10522718oag.30
        for <linux-media@vger.kernel.org>; Wed, 06 Nov 2013 07:56:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131106155347.GG24988@valkosipuli.retiisi.org.uk>
References: <1383752584-25962-1-git-send-email-ricardo.ribalda@gmail.com> <20131106155347.GG24988@valkosipuli.retiisi.org.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 6 Nov 2013 16:56:12 +0100
Message-ID: <CAPybu_11w06dFksNoRKHr8ujgd=UBsfE3g1=1+qPaKTSoAstWg@mail.gmail.com>
Subject: Re: [PATCH v2] videodev2: Set vb2_rect's width and height as unsigned
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

Hello Sakai

It has to be done in the same patch? or  on a separated patch just
changing the xml file?

Thanks!

On Wed, Nov 6, 2013 at 4:53 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Wed, Nov 06, 2013 at 04:43:04PM +0100, Ricardo Ribalda Delgado wrote:
>> As addressed on the media summit 2013, there is no reason for the width
>> and height to be signed.
>>
>> Therefore this patch is an attempt to convert those fields into unsigned.
>>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>
> For smiapp:
>
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
>
> How about documenting that change in struct v4l2_rect in
> Documentation/DocBook/media/v4l/compat.xml?
>
> --
> Regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk



-- 
Ricardo Ribalda
