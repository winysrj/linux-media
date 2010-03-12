Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab0CLIG4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 03:06:56 -0500
Message-ID: <4B99F63A.2050501@redhat.com>
Date: Fri, 12 Mar 2010 09:07:22 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>, moinejf@free.fr,
	m-karicheri2@ti.com, g.liakhovetski@gmx.de, pboettcher@dibcom.fr,
	tobias.lorenz@gmx.net, awalls@radix.net, khali@linux-fr.org,
	abraham.manu@gmail.com, hverkuil@xs4all.nl, crope@iki.fi,
	davidtlwong@gmail.com, henrik@kurelid.se, stoth@kernellabs.com
Subject: Re: Status of the patches under review (45 patches)
References: <4B969C08.2030807@redhat.com>
In-Reply-To: <4B969C08.2030807@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> 		== Gspca patches - Waiting Hans de Goede<hdegoede@redhat.com>  submission/review ==
>
> Jan,29 2010: [gspca_jf,tree] gspca zc3xx: signal when unknown packet received       http://patchwork.kernel.org/patch/75837

I nacked this one, as the zc3xx sends many non button press interrupt packets per second which this patch would all
log to dmesg as being unknown.

> Mar, 8 2010: [1/1] gspca-stv06xx: Remove the 046d:08da usb id from linking to the   http://patchwork.kernel.org/patch/84145
>

I acked this one, this should go in through Erik Andren's own tree.

Regards,

Hans
