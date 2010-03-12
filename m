Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:55383 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864Ab0CLITb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 03:19:31 -0500
Date: Fri, 12 Mar 2010 09:20:03 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>, m-karicheri2@ti.com,
	g.liakhovetski@gmx.de, pboettcher@dibcom.fr, tobias.lorenz@gmx.net,
	awalls@radix.net, khali@linux-fr.org, abraham.manu@gmail.com,
	hverkuil@xs4all.nl, crope@iki.fi, davidtlwong@gmail.com,
	henrik@kurelid.se, stoth@kernellabs.com
Subject: Re: Status of the patches under review (45 patches)
Message-ID: <20100312092003.63a3404d@tele>
In-Reply-To: <4B99F63A.2050501@redhat.com>
References: <4B969C08.2030807@redhat.com>
	<4B99F63A.2050501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, 12 Mar 2010 09:07:22 +0100
Hans de Goede <hdegoede@redhat.com> wrote:
> > 		== Gspca patches - Waiting Hans de
> > Goede<hdegoede@redhat.com>  submission/review ==
> >
> > Jan,29 2010: [gspca_jf,tree] gspca zc3xx: signal when unknown
> > packet received       http://patchwork.kernel.org/patch/75837
> 
> I nacked this one, as the zc3xx sends many non button press interrupt
> packets per second which this patch would all log to dmesg as being
> unknown.

Agree.

> > Mar, 8 2010: [1/1] gspca-stv06xx: Remove the 046d:08da usb id from
> > linking to the   http://patchwork.kernel.org/patch/84145
> >
> 
> I acked this one, this should go in through Erik Andren's own tree.

I already sent a pull request for this one.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
