Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab2AOOYT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 09:24:19 -0500
Message-ID: <4F12E18F.3020400@redhat.com>
Date: Sun, 15 Jan 2012 12:24:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: razza lists <razzalist@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Hauppage Nova: doesn't know how to handle a DVBv3 call to delivery
 system 0
References: <008301ccd316$0be6d440$23b47cc0$@gmail.com> <4F121361.2050403@gmail.com> <CAL+xqGZ1mBttt_e5bUorGFP+cc9RX3ooCkmAa9MSEAaLJ_o=mw@mail.gmail.com> <4F12BDD1.1000306@gmail.com>
In-Reply-To: <4F12BDD1.1000306@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-01-2012 09:51, Gianluca Gennari escreveu:
> Il 15/01/2012 12:35, razza lists ha scritto:
>> On Sat, Jan 14, 2012 at 11:44 PM, Gianluca Gennari <gennarone@gmail.com> wrote:
>>>
>>> Il 15/01/2012 00:41, RazzaList ha scritto:
>>>> I have followed the build instructions for the Hauppauge MyTV.t device here
>>>> - http://linuxtv.org/wiki/index.php/Hauppauge_myTV.t and built the drivers
>>>> as detailed here -
>>>> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_D
>>>> evice_Drivers on a CentOS 6.2 i386 build.
>>>>
>>>> When I use dvbscan, nothing happens. dmesg shows "
>>>> dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to
>>>> delivery system 0"
>>>>
>>>> [root@cos6 ~]# cd /usr/bin
>>>> [root@cos6 bin]# ./dvbscan /usr/share/dvb/dvb-t/uk-Hannington >
>>>> /usr/share/dvb/dvb-t/channels.conf
>>>> [root@cos6 bin]# dmesg | grep dvb
>>>> dvb-usb: found a 'Hauppauge Nova-T MyTV.t' in warm state.
>>>> dvb-usb: will pass the complete MPEG2 transport stream to the software
>>>> demuxer.
>>>> dvb-usb: schedule remote query interval to 50 msecs.
>>>> dvb-usb: Hauppauge Nova-T MyTV.t successfully initialized and connected.
>>>> usbcore: registered new interface driver dvb_usb_dib0700
>>>> dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to
>>>> delivery system 0
>>>>
>>>> I have searched but can't locate a fix. Any pointers?
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at �http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>> Hi,
>>> this patch will likely fix your problem:
>>>
>>> http://patchwork.linuxtv.org/patch/9492/
>>>
>>> Best regards,
>>> Gianluca
>>
>> It's very likely the case I'm doing something wrong and I apologise in
>> advance! However some help/guidance would be great...
>>
>> I have downloaded the sources as described in the basic approach here
>> - http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
>>
>> In the source there is no file called "dvb_frontend.c", so I assume I
>> start the media_build/build script?
>> If I do, eventually this creates
>> media_build/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
>>
>> I then apply the patch to
>> media_build/linux/drivers/media/dvb/dvb-core/dvb_frontend.c, and I can
>> see the added elements...
>> ....
>> static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
>> {
>>         struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>>         int i;
>>        	u32 delsys;
>>
>>         delsys = c->delivery_system;
>>         memset(c, 0, sizeof(struct dtv_frontend_properties));
>>         c->delivery_system = delsys;
>>
>>         c->state = DTV_CLEAR;
>>
>>         dprintk("%s() Clearing cache for delivery system %d\n", __func__,
>>                	c->delivery_system);
>> ................
>>
>> After a reboot (as I have not got a clue about unloading modules etc.)
>> I then execute make install but I still get the same error
>> "dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to
>> delivery system 0" when I use dvbscan.
>>
> 
> You are almost there.
> After you apply the patch, you have to recompile the entire source tree.
> You can do it launching the "make" command inside the linux/ folder.
> Then reinstall the drivers giving "make install" from the media_build/
> folder, and reboot.

I've added the fixes for it today. So, tomorrow's tarballs should have this
bug fixed.

> 
> Best regards,
> Gianluca
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

