Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:23710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab1BOT1L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 14:27:11 -0500
Message-ID: <4D5AD451.2020102@redhat.com>
Date: Tue, 15 Feb 2011 20:30:25 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l-utils: Add the JPEG Lite decoding function
References: <20110215102626.3e8e83d3@tele>
In-Reply-To: <20110215102626.3e8e83d3@tele>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 02/15/2011 10:26 AM, Jean-Francois Moine wrote:
> Hi Hans,
>
> I got the permission to relicense the JPEG Lite decoding to the LGPL.
>

Ah, good, patch applied and pushed to git.

> If you want to test the nw80x driver, get the gspca tarball from my web
> page (2.12.12). I added your webcam which should directly work (p35u -
> chip nw801).

I've tested it and it works :) I also tested the JPGL -> YUV path.

I did find 2 bugs, the "if (gspca_dev->curr_mode)" test in sd_start,
needs to be inverted. In general it is a good idea to do a test
on gspca_dev->width, rather then curr_mode IMHO, it is more
readable and less error prone.

Talking about readability, I also found the

         if (sd->bridge == BRIDGE_NW800) {
		...
	} else {
		...
		if (sd->bridge == BRIDGE_NW802) {
			...
		} else {
			...
		}
	}

part in sd_init a bit hard to grok, can this be changed
to a switch case on sd->bridge ?

The other bug was a divide by zero -> kernel panic, in
do_autogain when sd->ae_res == 0, note this was when I was
messing around with the driver a bit (before I found the
issue with the inverted curr_mode check), but I think this
could happen in real life to depending on register values
and we should protect against this.

Regards,

Hans
