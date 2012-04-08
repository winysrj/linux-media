Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421Ab2DHOKb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Apr 2012 10:10:31 -0400
Message-ID: <4F819CD9.7070802@redhat.com>
Date: Sun, 08 Apr 2012 16:12:41 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jaime Velasco Juan <jsagarribay@gmail.com>
Subject: Re: stk webcam driver needs DMI upside down table
References: <4F7F1405.9000000@googlemail.com>
In-Reply-To: <4F7F1405.9000000@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/06/2012 06:04 PM, Gregor Jasny wrote:
> Hello,
>
> I recently received a webcam upside down report from a ASUS Z96Fm owner.
> Usually we add the USB id and DMI information to the libv4l upside down
> table. Except for webcam drivers that can flip images in hardware. By
> looking at stk-webcam.c I see both, a hflip anf vflip parameter.
>
> Some gspca drivers handle the situation by adding a DMI table to the
> webcam driver. Would this make sense for the STK driver, too?

hehe, funny I still had an upside down report for the STK driver
(for a different model laptop) on my to-do list.

WRT your question, maybe adding a dmi table to the driver makes sense,
but first we must change its behavior away from flipping the image
by default to leaving the image upright. Which should fix things for
the Z96FM laptop this thread started with, as well as for the Asus
A3H laptop for which I've a report.

If we then get bug reports after making this change, then those will be
for laptops which actually do have the sensor upside down (which I think
we will, I assume that is the reason currently the driver is flipping by
default) and we can collect dmi info from the reporters and add *those*
to a dmi table :)

So for now I'm going to send a patch upstream to change the default
to not flip.

Regards,

Hans


