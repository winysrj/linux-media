Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:60511 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbZK2MPf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 07:15:35 -0500
Message-ID: <4B1265E9.1040505@freemail.hu>
Date: Sun, 29 Nov 2009 13:15:37 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca sunplus: propagate error for higher level
References: <4B093DDD.5@freemail.hu>	<4B10CD81.7060909@freemail.hu> <20091128191717.5164a003@tele>
In-Reply-To: <20091128191717.5164a003@tele>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> On Sat, 28 Nov 2009 08:13:05 +0100
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> what do you think about this patch?
> 
> Hi Márton,
> 
> There are many other drivers where the usb_control_msg() errors are not
> tested nor propagated to higher levels. Generally, this does not matter:
> the errors are signalled at the lowest level, and they seldom occur.
> Thus, I don't think your patch is useful...

I think that the return value of the usb_control_msg() is to be evaluated.
If other drivers also not evaluating the usb_control_msg() *they* has to
be fixed.

The benefit would be that the userspace program can recognise error condition
faster and react accordingly. For example the USB device can be unplugged any
time. In this case there is no use to continue sending URBs. Otherwise the user
program thinks that everything went on correctly and the user will be surprised
how come that he or she unplugged a device and it is still working.

Regards,

	Márton Németh

