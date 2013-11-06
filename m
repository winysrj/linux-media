Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:61279 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab3KFOmK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 09:42:10 -0500
MIME-Version: 1.0
In-Reply-To: <20131106141901.GD24988@valkosipuli.retiisi.org.uk>
References: <1383742165-17634-1-git-send-email-ricardo.ribalda@gmail.com> <20131106141901.GD24988@valkosipuli.retiisi.org.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 6 Nov 2013 15:41:48 +0100
Message-ID: <CAPybu_2xOkDB-F=50WKLxzh0wufG3Vb7Fz9ZPfGC3O8HfjZVUA@mail.gmail.com>
Subject: Re: [PATCH] videodev2: Set vb2_rect's width and height as unsigned
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	=?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	"open list:MT9M032 APTINA SE..." <linux-media@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari.

Thanks for your comments. I have fixed them, but I will wait some time
to get more comments, to avoid spamming the list.

Thanks!

On Wed, Nov 6, 2013 at 3:19 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Ricardo,
>
> Thanks for the patch.
>
> On Wed, Nov 06, 2013 at 01:49:25PM +0100, Ricardo Ribalda Delgado wrote:
> ...
>> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
>> index ae66d91..9036e64 100644
>> --- a/drivers/media/i2c/smiapp/smiapp-core.c
>> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
>> @@ -2028,8 +2028,8 @@ static int smiapp_set_crop(struct v4l2_subdev *subdev,
>>       sel->r.width = min(sel->r.width, src_size->width);
>>       sel->r.height = min(sel->r.height, src_size->height);
>>
>> -     sel->r.left = min(sel->r.left, src_size->width - sel->r.width);
>> -     sel->r.top = min(sel->r.top, src_size->height - sel->r.height);
>> +     sel->r.left = min(sel->r.left, (int) (src_size->width - sel->r.width));
>> +     sel->r.top = min(sel->r.top, (int) (src_size->height - sel->r.height));
>
> How about min_t(int, ... instead?
>
>>       *crops[sel->pad] = sel->r;
>>
>> @@ -2121,8 +2121,10 @@ static int smiapp_set_selection(struct v4l2_subdev *subdev,
>>
>>       sel->r.left = max(0, sel->r.left & ~1);
>>       sel->r.top = max(0, sel->r.top & ~1);
>> -     sel->r.width = max(0, SMIAPP_ALIGN_DIM(sel->r.width, sel->flags));
>> -     sel->r.height = max(0, SMIAPP_ALIGN_DIM(sel->r.height, sel->flags));
>> +     sel->r.width = max_t(unsigned int, 0,
>> +                     SMIAPP_ALIGN_DIM(sel->r.width, sel->flags));
>> +     sel->r.height = max_t(unsigned int, 0,
>> +                     SMIAPP_ALIGN_DIM(sel->r.height, sel->flags));
>
> The purpose of this check is to ensure the number is at least zero, and as
> width and height are now unsigned, max_t() won't be needed anymore. Only
> SMIAPP_ALIGN_DIM() is.
>
> I can't see any harm from that, though --- there could be redundant checks
> in other drivers, too.
>
>>       sel->r.width = max_t(unsigned int,
>>                            sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE],
>
> Do you think it'd be worth adding a note on this change to the list of V4L2
> in each kernel version in Documentation/DocBook/media/v4l/compat.xml?
>
> --
> Kind regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk



-- 
Ricardo Ribalda
