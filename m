Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:64306 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbbCHUiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 16:38:21 -0400
Date: Sun, 8 Mar 2015 21:38:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?B?QXloYW4gS8Ocw4fDnEtNQU7EsFNB?=
	<ayhan.kucukmanisa@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Aptina MT9V024
In-Reply-To: <CAF-NajsBJGtC2RCgzyX6=f8BkYtzFEcLu4q9XOhiE+Lgd+ux+Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1503082133240.7485@axis700.grange>
References: <CAF-NajsBJGtC2RCgzyX6=f8BkYtzFEcLu4q9XOhiE+Lgd+ux+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sun, 8 Mar 2015, Ayhan K�~\�~G�~\KMANİSA wrote:

> Hi Guennadi,
> 
> Previously i asked you a problem about accesing camera i2c bus. I solved
> camera i2c detect problem. Now i can get images using mplayer and v4l2 lib.
> But i couldnt get right images. I try to get test pattern but when i get
> image that in attachment. Could you give an advice about this problem?

The first problem, that appears in your image is geometry. There seem to 
be more pixels in the image than you think there are. Also, I don't know 
what your test image should look like, but I doubt it should be that pink. 
So, looks like you also wrongly decode pixels. Maybe these two problems 
are related - your bytes-per-pixel is wrong, so the width is wrong and the 
pixel format too.

Thanks
Guennadi

> 
> Thanks.
> 
> 
> 
> ---------------------------------------------------------------------------------------------------
> Arş. Gör. Ayhan KÜÇÜKMANİSA
> Kocaeli Üniversitesi, Gömülü Sistemler ve Görüntüleme Sistemleri
> Laboratuvarı
> 
> Res. Asst. Ayhan KÜÇÜKMANİSA
> Kocaeli University, Laboratory of Embedded and Vision Systems
> 
