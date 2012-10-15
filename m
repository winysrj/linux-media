Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34381 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2JOU6q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 16:58:46 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq12so2639307wib.1
        for <linux-media@vger.kernel.org>; Mon, 15 Oct 2012 13:58:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121015205055.GH21261@valkosipuli.retiisi.org.uk>
References: <CAPybu_1z8kam1e6ArT9gyX+qybW+6s1K1VdJikuWoYPMjA3q2Q@mail.gmail.com>
 <20121011223252.GR14107@valkosipuli.retiisi.org.uk> <CAPybu_1HiH69Cf1ORDaEHWWaeTFUMvntLGqa__JS4fE4=B67NQ@mail.gmail.com>
 <20121015205055.GH21261@valkosipuli.retiisi.org.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 15 Oct 2012 22:58:05 +0200
Message-ID: <CAPybu_3yPYFwiMv2VkvUxmwQj5FT6b06aZdPjRgVuc+Vg6SCmQ@mail.gmail.com>
Subject: Re: Multiple Rectangle cropping
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari

I get the two areas sticked together. Of course both areas of interest
have the save width.

Kind Regards :)

On Mon, Oct 15, 2012 at 10:50 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Ricardo,
>
> On Fri, Oct 12, 2012 at 09:18:42AM +0200, Ricardo Ribalda Delgado wrote:
>> In fact, is the sensor, the one that supports multiple Areas of
>> Interest. Unfortunatelly the userland v4l2 api only supports one area
>> of interest for doing croping (or that is what I believe).
>>
>> Is there any plan to support multiple AOI? or I have to make my own ioctl?
>
> As a result, do you get two separate streams out of the device, or something
> else? This is what I'd assume to get if I had two cropping rectangles.
>
> Kind regards,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk



-- 
Ricardo Ribalda
