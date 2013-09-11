Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:52203 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3IKI3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 04:29:14 -0400
Received: by mail-oa0-f44.google.com with SMTP id l17so8944155oag.17
        for <linux-media@vger.kernel.org>; Wed, 11 Sep 2013 01:29:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130910223507.GF2057@valkosipuli.retiisi.org.uk>
References: <CAPybu_0J63XVEv=EPHbarn8EH9H5okEBbihaiZSOdwggkvV5xQ@mail.gmail.com>
 <5228FB2E.5050503@gmail.com> <CAPybu_2_kyqcmV0zh42X0LG+QvTDmFMJ_ywUsoe5WGh2k71S3Q@mail.gmail.com>
 <20130910223507.GF2057@valkosipuli.retiisi.org.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 11 Sep 2013 10:28:53 +0200
Message-ID: <CAPybu_3cOLztceJoNwyZQGuC8maNYKuunbxJRHt7X6nQHmCyhw@mail.gmail.com>
Subject: Re: RFC> multi-crop (was: Multiple Rectangle cropping)
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari

On Wed, Sep 11, 2013 at 12:35 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Ricardo,
>
> On Fri, Sep 06, 2013 at 10:30:18AM +0200, Ricardo Ribalda Delgado wrote:
>> Any comment on this? Of course the names should be better chosen, this
>> is just a declaration of intentions.
>
> I forgot to ask one question: what's the behaviour of cropping on different
> regions? Are the regions located on particular line or what?

The purpose of this is to increase the framerate on high speed cameras.

Lets say you are controlling the speed on a highway. You have a camera
looking at the road. The fps will determine the accuracy of your
meassurement. If you could skip the reservation between both lanes you
could increase the fps.

Also imaging a high speed ballistics camera. You have a reference
plate on rows 1-10, and you are studing a sample on rows 400-500. You
dont want to read rows 11-399, because you will reduce your framerate

Finally If you have an scenario where you want to process a specific
part of the image at 1mm per pixel and the rest at 10mm per pixel.

>
> Contrary to the case with AF rectaangles, I see fewer possibilities for
> standardising the behaviour of multiple crop rectanges which decreases the
> value of a generic interface: even if the interface is generic but you have
> no idea what it'd actually do you wouldn't gain much.
>
> For this reason it might also make sense to use a private IOCTL (and not a
> control) to support the functionality. Or private selections (which we don't
> have yet).

I like the idea of adding an id field to the selection api, and then a
private control with a bitmask selection with selections are active.

If we can agree on the value of this we could define a standard
control. If not, we leave the door open to the drivers to define their
own.


Thanks for you feedback!

-- 
Ricardo Ribalda
