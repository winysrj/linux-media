Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:48251 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZFSDO2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 23:14:28 -0400
Received: by gxk10 with SMTP id 10so2455724gxk.13
        for <linux-media@vger.kernel.org>; Thu, 18 Jun 2009 20:14:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52243.62.70.2.252.1245227586.squirrel@webmail.xs4all.nl>
References: <52243.62.70.2.252.1245227586.squirrel@webmail.xs4all.nl>
Date: Fri, 19 Jun 2009 12:14:31 +0900
Message-ID: <aec7e5c30906182014h3888a4dbt5ee8bf12b92fbc8c@mail.gmail.com>
Subject: Re: [PATCH] adding support for setting bus parameters in sub device
From: Magnus Damm <magnus.damm@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 17, 2009 at 5:33 PM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
>> I think automatic negotiation is a good thing if it is implemented
>> correctly.
>>
>> Actually, i think modelling software after hardware is a good thing
>> and from that perspective the soc_camera was (and still is) a very
>> good fit for our on-chip SoC. Apart from host/sensor separation, the
>> main benefits in my mind are autonegotiation and separate
>> configuration for camera sensor, capture interface and board.
>>
>> I don't mind doing the same outside soc_camera, and I agree with Hans
>> that in some cases it's nice to hard code and skip the "magic"
>> negotiation. I'm however pretty sure the soc_camera allows hard coding
>> though, so in that case you get the best of two worlds.
>
> It is my strong opinion that while autonegotiation is easy to use, it is
> not a wise choice to make. Filling in a single struct with the bus
> settings to use for each board-subdev combination (usually there is only
> one) is simple, straight-forward and unambiguous. And I really don't see
> why that should take much time at all. And I consider it a very good point
> that the programmer is forced to think about this for a bit.

I agree that it's good to force the programmer to think. In this case
I assume you are talking about the board support engineer or at least
the person writing software to attach a camera sensor with capture
hardware.

You are not against letting drivers export their capabilites at least?
I'd like to see drivers that exports capabilites about which signals
that are supported and which states that are valid. So for instance,
the SuperH CEU driver supports both active high and active low HSYNC
and VSYNC signals. I'd like to make sure that the driver writers are
forced to think and export a bitmap of capabilites describing all
valid pin states. A little bit in the same way that i2c drivers use
->functionality() to export a bitmap of capabilites. Then if the
assignment of the pin states is automatic or hard coded I don't care
about.

Cheers,

/ magnus
