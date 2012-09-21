Return-path: <linux-media-owner@vger.kernel.org>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:37097 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932724Ab2IUTEp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 15:04:45 -0400
Message-ID: <505CBA40.5010903@hoogenraad.net>
Date: Fri, 21 Sep 2012 21:04:32 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: media_build directory error after patch dvb_frontend: implement
 suspend / resume
References: <20120819195423.8011935E0224@alastor.dyndns.org> <CAJL_dMuF1iDZ8vAXu7a0OFfozzKj31UOc-n6ZWWQGBxjTciTXQ@mail.gmail.com> <503149FC.5030501@iki.fi> <505C9388.8090500@hoogenraad.net> <505CA956.4040009@iki.fi>
In-Reply-To: <505CA956.4040009@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Antti:

Maybe the media_build could clean out the linux subdirectories (e.g.
drivers   include  sound) before the tar x command.

Your rtl28xxu driver immediately works, even on this old system !
Thanks for that as well.

I will remove the very outdated info I put onto the Wiki pages:
http://linuxtv.org/wiki/index.php/Realtek_RTL2831U

http://linuxtv.org/wiki/index.php/DVB-T_USB_Devices
http://linuxtv.org/wiki/index.php/DVB-T_USB_Devices#Freecom_rev_4_DVB-T_USB_2.0_tuner


Antti Palosaari wrote:
> On 09/21/2012 07:19 PM, Jan Hoogenraad wrote:
>> I try to compile the media_build on an old Ubuntu Lucid system.
>> 2.6.32-42-generic-pae #96-Ubuntu SMP Wed Aug 15 19:12:17 UTC 2012 i686
>> GNU/Linux
>>
>> The make job stops with
>>
>> /home/jhh/dvb/media_build/v4l/dvb_usb_core.c: In function
>> 'dvb_usb_data_complete_raw':
>> /home/jhh/dvb/media_build/v4l/dvb_usb_core.c:224: error: implicit
>> declaration of function 'dvb_dmx_swfilter_raw'
>> /home/jhh/dvb/media_build/v4l/dvb_usb_core.c: In function
>> 'dvb_usbv2_suspend':
>> /home/jhh/dvb/media_build/v4l/dvb_usb_core.c:975: error: implicit
>> declaration of function 'dvb_frontend_suspend'
>> /home/jhh/dvb/media_build/v4l/dvb_usb_core.c: In function
>> 'dvb_usbv2_resume_common':
>> /home/jhh/dvb/media_build/v4l/dvb_usb_core.c:994: error: implicit
>> declaration of function 'dvb_frontend_resume'
>>
>> This probably started after
>> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/52430/match=dvb_frontend_resume
>>
>>
>> The media_build tree is confused with too many files with the same name:
>>
>> find linux -name \*front\* -ls
>> 54788964   24 -rw-r--r--   1 jhh      jhh         12642 Aug 16 05:45
>> linux/drivers/media/dvb-core/dvb_frontend.h
>> 54788973   80 -rw-r--r--   1 jhh      jhh         71787 Sep 14 05:45
>> linux/drivers/media/dvb-core/dvb_frontend.c
>> 54397078   20 -rw-r--r--   1 jhh      jhh         12056 Sep 16 20:20
>> linux/drivers/media/dvb/dvb-core/dvb_frontend.h
>> 54397083   68 -rw-r--r--   1 jhh      jhh         60558 Jun  8  2011
>> linux/drivers/media/dvb/dvb-core/dvb_frontend.c
>> 54397777   24 -rw-r--r--   1 jhh      jhh         13012 Aug 14 05:45
>> linux/include/linux/dvb/frontend.h
>>
>> The frontend.h and .c chosen in the build are older ones
>>   find v4l -name \*front\* -ls
>>
>> 54135379   76 -rw-r--r--   1 jhh      jhh         67636 Sep 21 17:47
>> v4l/.dvb_frontend.o.cmd
>> 54133920    0 lrwxrwxrwx   1 jhh      jhh            50 Sep 21 18:13
>> v4l/dvb_frontend.h -> ../linux/drivers/media/dvb/dvb-core/dvb_frontend.h
>> 54133927    0 lrwxrwxrwx   1 jhh      jhh            50 Sep 21 18:13
>> v4l/dvb_frontend.c -> ../linux/drivers/media/dvb/dvb-core/dvb_frontend.c
>> 54136025  184 -rw-r--r--   1 jhh      jhh        179558 Sep 21 17:47
>> v4l/dvb_frontend.o
>>
>> Do you know what to do about this situation ?
> 
> All that is due to drivers/media directory structure re-organization.
> Could you use clean directory for media_build.git? If you want use
> exiting media_build.git you should remove manually those old directories.
> 
> regards
> Antti
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
