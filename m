Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm2.telefonica.net ([213.4.138.2]:60578 "EHLO
	IMPaqm2.telefonica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab0AMNur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 08:50:47 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: Problem with gspca and zc3xx
Date: Wed, 13 Jan 2010 14:50:44 +0100
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
References: <201001090015.31357.jareguero@telefonica.net> <20100112093635.66aa9d57@tele> <201001121557.10312.jareguero@telefonica.net>
In-Reply-To: <201001121557.10312.jareguero@telefonica.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001131450.44689.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El Martes, 12 de Enero de 2010, Jose Alberto Reguero escribió:
> El Martes, 12 de Enero de 2010, Jean-Francois Moine escribió:
> > On Mon, 11 Jan 2010 15:49:55 +0100
> >
> > Jose Alberto Reguero <jareguero@telefonica.net> wrote:
> > > I take another image with 640x480 and the bad bottom lines are 8. The
> > > right side look right this time. The good sizes are:
> > > 320x240->320x232
> > > 640x480->640x472
> >
> > Hi Jose Alberto and Hans,
> >
> > Hans, I modified a bit your patch to handle the 2 resolutions (also, the
> > problem with pas202b does not exist anymore). May you sign or ack it?
> >
> > Jose Alberto, the attached patch is to be applied to the last version
> > of the gspca in my test repository at LinuxTv.org
> > 	http://linuxtv.org/hg/~jfrancois/gspca
> > May you try it?
> >
> > Regards.
> 
>  The patch works well.
> There is another problem. When autogain is on(default), the image is bad.
>  It is possible to put autogain off by default?
> 
> Thanks.
> Jose Alberto

Autogain works well again. I can't reproduce the problem. Perhaps the debug 
messages. (Now I have debug off).

Thanks.
Jose Alberto
