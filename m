Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50539 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab2JLHTX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 03:19:23 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so411731wib.1
        for <linux-media@vger.kernel.org>; Fri, 12 Oct 2012 00:19:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121011223252.GR14107@valkosipuli.retiisi.org.uk>
References: <CAPybu_1z8kam1e6ArT9gyX+qybW+6s1K1VdJikuWoYPMjA3q2Q@mail.gmail.com>
 <20121011223252.GR14107@valkosipuli.retiisi.org.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 12 Oct 2012 09:18:42 +0200
Message-ID: <CAPybu_1HiH69Cf1ORDaEHWWaeTFUMvntLGqa__JS4fE4=B67NQ@mail.gmail.com>
Subject: Re: Multiple Rectangle cropping
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

In fact, is the sensor, the one that supports multiple Areas of
Interest. Unfortunatelly the userland v4l2 api only supports one area
of interest for doing croping (or that is what I believe).

Is there any plan to support multiple AOI? or I have to make my own ioctl?


Regards

On Fri, Oct 12, 2012 at 12:32 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Ricardo,
>
> On Thu, Oct 11, 2012 at 12:40:03PM +0200, Ricardo Ribalda Delgado wrote:
>> I want to port an old driver for an fpga based camera to the new media
>> infrastructure.
>>
>> By reading the doc. I think it has almost all the capabilities needed.
>> The only one I am missing is the habilty to select multiple rectangles
>> from the sensor. ie: I have a 100x50 sensor and I want a 100x20 image
>> with the pixels from 0,0->100,10 and then 0,40->100,50
>>
>> Any suggestion about how to implement this with the media api?
>
> I suppose your FPGA does the cropping. You can use the V4L2 subdev selection
> interface and crop on the source pads. Each will then have a link to a
> capture video device.
>
> <URL:http://hverkuil.home.xs4all.nl/spec/media.html#subdev>
>
> Kind regards,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk



-- 
Ricardo Ribalda
