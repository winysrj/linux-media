Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41855 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab2IURwo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 13:52:44 -0400
Message-ID: <505CA956.4040009@iki.fi>
Date: Fri, 21 Sep 2012 20:52:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: linux-media@vger.kernel.org
Subject: Re: media_build directory error after patch dvb_frontend: implement
 suspend / resume
References: <20120819195423.8011935E0224@alastor.dyndns.org> <CAJL_dMuF1iDZ8vAXu7a0OFfozzKj31UOc-n6ZWWQGBxjTciTXQ@mail.gmail.com> <503149FC.5030501@iki.fi> <505C9388.8090500@hoogenraad.net>
In-Reply-To: <505C9388.8090500@hoogenraad.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/21/2012 07:19 PM, Jan Hoogenraad wrote:
> I try to compile the media_build on an old Ubuntu Lucid system.
> 2.6.32-42-generic-pae #96-Ubuntu SMP Wed Aug 15 19:12:17 UTC 2012 i686
> GNU/Linux
>
> The make job stops with
>
> /home/jhh/dvb/media_build/v4l/dvb_usb_core.c: In function
> 'dvb_usb_data_complete_raw':
> /home/jhh/dvb/media_build/v4l/dvb_usb_core.c:224: error: implicit
> declaration of function 'dvb_dmx_swfilter_raw'
> /home/jhh/dvb/media_build/v4l/dvb_usb_core.c: In function
> 'dvb_usbv2_suspend':
> /home/jhh/dvb/media_build/v4l/dvb_usb_core.c:975: error: implicit
> declaration of function 'dvb_frontend_suspend'
> /home/jhh/dvb/media_build/v4l/dvb_usb_core.c: In function
> 'dvb_usbv2_resume_common':
> /home/jhh/dvb/media_build/v4l/dvb_usb_core.c:994: error: implicit
> declaration of function 'dvb_frontend_resume'
>
> This probably started after
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/52430/match=dvb_frontend_resume
>
> The media_build tree is confused with too many files with the same name:
>
> find linux -name \*front\* -ls
> 54788964   24 -rw-r--r--   1 jhh      jhh         12642 Aug 16 05:45
> linux/drivers/media/dvb-core/dvb_frontend.h
> 54788973   80 -rw-r--r--   1 jhh      jhh         71787 Sep 14 05:45
> linux/drivers/media/dvb-core/dvb_frontend.c
> 54397078   20 -rw-r--r--   1 jhh      jhh         12056 Sep 16 20:20
> linux/drivers/media/dvb/dvb-core/dvb_frontend.h
> 54397083   68 -rw-r--r--   1 jhh      jhh         60558 Jun  8  2011
> linux/drivers/media/dvb/dvb-core/dvb_frontend.c
> 54397777   24 -rw-r--r--   1 jhh      jhh         13012 Aug 14 05:45
> linux/include/linux/dvb/frontend.h
>
> The frontend.h and .c chosen in the build are older ones
>   find v4l -name \*front\* -ls
>
> 54135379   76 -rw-r--r--   1 jhh      jhh         67636 Sep 21 17:47
> v4l/.dvb_frontend.o.cmd
> 54133920    0 lrwxrwxrwx   1 jhh      jhh            50 Sep 21 18:13
> v4l/dvb_frontend.h -> ../linux/drivers/media/dvb/dvb-core/dvb_frontend.h
> 54133927    0 lrwxrwxrwx   1 jhh      jhh            50 Sep 21 18:13
> v4l/dvb_frontend.c -> ../linux/drivers/media/dvb/dvb-core/dvb_frontend.c
> 54136025  184 -rw-r--r--   1 jhh      jhh        179558 Sep 21 17:47
> v4l/dvb_frontend.o
>
> Do you know what to do about this situation ?

All that is due to drivers/media directory structure re-organization. 
Could you use clean directory for media_build.git? If you want use 
exiting media_build.git you should remove manually those old directories.

regards
Antti

-- 
http://palosaari.fi/
