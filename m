Return-path: <linux-media-owner@vger.kernel.org>
Received: from caiajhbdcaib.dreamhost.com ([208.97.132.81]:48366 "EHLO
	homiemail-a12.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755019AbZKWSqw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 13:46:52 -0500
Date: Mon, 23 Nov 2009 15:46:53 -0300
From: Gustavo =?UTF-8?B?Q2hhw61u?= Dumit <g@0xff.cl>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: VFlip problem in gspca_pac7311
Message-ID: <20091123154653.1ddddd47@0xff.cl>
In-Reply-To: <4B0AD3F8.2010606@freemail.hu>
References: <20091123141042.47feac9e@0xff.cl>
	<4B0AD3F8.2010606@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El Mon, 23 Nov 2009 19:27:04 +0100
Németh Márton <nm127@freemail.hu> escribió:
> Hi,
> Gustavo Chaín Dumit wrote:
> > Hi
> > 
> > I'm testing a Pixart Imaging device (0x93a:0x2622)
> > Everything works fine, but vertical orientation. Image looks
> > rotated. So I wrote a little hack to prevent it.
> > [...]
> > Any one has the same problem ?
> 
> You might want to have a look to libv4l
> ( http://freshmeat.net/projects/libv4l ) and the v4lcontrol_flags[] in
> http://linuxtv.org/hg/v4l-dvb/file/2f87f537fb2b/v4l2-apps/libv4l/libv4lconvert/control/libv4lcontrol.c .
> This user space library has a list of laptops where the webcams are
> installed for example upside down.
> 
> Regards,
> 
> 	Márton Németh
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

thanks you!

-- 
Gustavo Chaín Dumit
http://0xff.cl
