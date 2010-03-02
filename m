Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab0CBVXg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Mar 2010 16:23:36 -0500
Message-ID: <4B8D81CE.4070201@redhat.com>
Date: Tue, 02 Mar 2010 18:23:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: How do private controls actually work?
References: <829197381002281856o749e3e9al36334b8b42b34562@mail.gmail.com>	 <49ae9be6ffaaac102dc02f94f2fd047c.squirrel@webmail.xs4all.nl>	 <829197381003010220w57248cb2l636a75d5bf4b19c1@mail.gmail.com>	 <201003022128.06210.hverkuil@xs4all.nl> <829197381003021242p1ae9d91ek68e2c063024d316@mail.gmail.com>
In-Reply-To: <829197381003021242p1ae9d91ek68e2c063024d316@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Tue, Mar 2, 2010 at 3:28 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

> I had some extended discussion with Mauro on this yesterday on
> #linuxtv, and he is now in favor of introducing a standard user
                      ===
> control for chroma gain, as opposed to doing a private control at all.

To be clear: I was never against ;)

It is worthy to summarize the discussions we have and the rationale to
create another control for it.

I've checked the datasheets of some chipsets, and the chroma gain is
different than the saturation control: the gain control (chroma or luma)
are applied at the analog input (or analog input samples) before the color
decoding, while the saturation is applied to the U/V output levels (some
datasheets call it as U/V output gain - causing some mess on the interpretation
of this value).

Also, saa7134 code as already some code to control the chroma gain. The driver
currently just puts some default value there, enabling AGC for PAL/NTSC and
disabling it for SECAM - but - as we have already troubles with AGC with cx88
and saa711x, I don't doubt that we may need to add the control logic there
to solve the same kind of trouble with composite/svideo inputs and some sources
that has a very high gain at the U/V level.

So, this control is not private to saa711x chipsets, but this control is also
present on other devices as well.

The API spec patch should clearly state that Saturation is for the U/V output
level, while gain is for the analog input gain.

-- 

Cheers,
Mauro
