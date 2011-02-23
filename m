Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33620 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab1BWWi4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 17:38:56 -0500
Received: by qyk7 with SMTP id 7so4364584qyk.19
        for <linux-media@vger.kernel.org>; Wed, 23 Feb 2011 14:38:55 -0800 (PST)
Message-ID: <4D658C78.2080907@gmail.com>
Date: Wed, 23 Feb 2011 19:38:48 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Vivek Periaraj <vivek.periaraj@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge WinTV USB 2
References: <201102240116.18770.Vivek.Periaraj@gmail.com>	<AANLkTi=ipU6gqoQZ4T25ErCGapvoT-Q8vx+mriQj=tji@mail.gmail.com>	<201102240255.00946.Vivek.Periaraj@gmail.com> <AANLkTikNiEKZNVs1DGDvuLR0r+XTWLgi03nbk=272fqj@mail.gmail.com>
In-Reply-To: <AANLkTikNiEKZNVs1DGDvuLR0r+XTWLgi03nbk=272fqj@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-02-2011 18:26, Devin Heitmueller escreveu:
> On Wed, Feb 23, 2011 at 4:25 PM, Vivek Periaraj
> <vivek.periaraj@gmail.com> wrote:
>> Hi Devin,
>>
>> Thanks for the reply!
>>
>> Like you advised, I took the latest code and started building it as mentioned
>> in this link --> http://linuxtv.org/wiki/index.php/Trident_TM6000 but getting
>> this error:

The information at the wiki page for this device is outdated. Support is now upstream.

Although I know that some Hauppauge devices are supported by tm6010, I'm not sure 
if someone added the tm6010 USB ID's for The model you have to the tm6000 driver.

>>
>> /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-core.c: In function
>> 'tm6000_init_analog_mode':
>> /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-core.c:339: warning: ISO C90
>> forbids mixed declarations and code
>>  CC [M]  /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-i2c.o
>>  CC [M]  /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.o
>> /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.c: In function
>> 'tm6000_uninit_isoc':
>> /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.c:522: error: implicit
>> declaration of function 'usb_free_coherent'
>> /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.c: In function
>> 'tm6000_prepare_isoc':
>> /mnt/share1/Debian/Hauppauge/v4l-dvb/v4l/tm6000-video.c:612: error: implicit
>> declaration of function 'usb_alloc_coherent'
> <snip>
> 
> Questions like this should be directed to the mailing list and not me
> personally, where any number of people can help you out with basic
> build problems.
> 
> Regards,
> 
> Devin
> 

