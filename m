Return-path: <mchehab@pedra>
Received: from web25403.mail.ukl.yahoo.com ([217.12.10.137]:46809 "HELO
	web25403.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755183Ab0JYLvd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 07:51:33 -0400
Message-ID: <355911.61281.qm@web25403.mail.ukl.yahoo.com>
References: <AANLkTint2Xw3bJuGh2voUpncWderrbUgbeOaPdp1-yNm@mail.gmail.com> <201010242055.30799.albin.kauffmann@gmail.com> <AANLkTinwb_7ErteoWcO2VC1nu9uNqUwu6N+HEhrDwwg-@mail.gmail.com> <AANLkTinVas23b2ZMuBxzdY6PUP-4JEMchNup9nSpxsf3@mail.gmail.com> <130335.5569.qm@web25404.mail.ukl.yahoo.com> <AANLkTi=na1Rs6GmKzVUPZ9FrqVt8F-H-gi=JO0+7WW6K@mail.gmail.com> <575680.5975.qm@web25406.mail.ukl.yahoo.com> <AANLkTimf5Y6GybqDiEDdVo7OJ_f2X0Rxz1HxFEk7kHxj@mail.gmail.com> <AANLkTi=FtLUinJ_pmGK-Ygr=_ZOTZrcatXzg2zOq+LSz@mail.gmail.com>
Date: Mon, 25 Oct 2010 12:51:30 +0100 (BST)
From: fabio tirapelle <ftirapelle@yahoo.it>
Subject: Re: Wintv-HVR-1120 woes
To: Albin Kauffmann <albin.kauffmann@gmail.com>,
	Sasha Sirotkin <demiurg@femtolinux.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTi=FtLUinJ_pmGK-Ygr=_ZOTZrcatXzg2zOq+LSz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> Da: Albin Kauffmann <albin.kauffmann@gmail.com>
> A: Sasha Sirotkin <demiurg@femtolinux.com>
> Cc: fabio tirapelle <ftirapelle@yahoo.it>; linux-media@vger.kernel.org
> Inviato: Lun 25 ottobre 2010, 13:20:13
> Oggetto: Re: Wintv-HVR-1120 woes
> 
> On Mon, Oct 25, 2010 at 9:46 AM, Sasha Sirotkin <demiurg@femtolinux.com>  
>wrote:
> > On Mon, Oct 25, 2010 at 9:24 AM, fabio tirapelle <ftirapelle@yahoo.it>  
>wrote:
> >>
> >>
> >>> Da: Sasha Sirotkin <demiurg@femtolinux.com>
> >>>  A: fabio tirapelle <ftirapelle@yahoo.it>
> >>>  Cc: Albin Kauffmann <albin.kauffmann@gmail.com>; 
>linux-media@vger.kernel.org
> >>>  Inviato: Lun 25 ottobre 2010, 09:18:28
> >>> Oggetto: Re:  Wintv-HVR-1120 woes
> >>>
> >>> On Mon, Oct 25, 2010 at 8:16  AM, fabio tirapelle <ftirapelle@yahoo.it>  
>wrote:
> >>> > My  WinTV-HVR-1120 works if I delete  dvb-fe-tda10048-1.0.fw and
> >>> > rename  dvb-fe-tda10046.fw in  dvb-fe-tda10048-1.0.fw
> >>> > (see cf "Hauppauge   WinTV-HVR-1120  on Unbuntu 10.04" thread).
> >>> > After reboot my  WinTV-HVR-1120  works. Ubuntu recognizes that the 
>firmware
> >>>isn't
> >>>  > correct  and doesn't load the firmware.
> >>>
> >>> How  come it works without the firmware !?  Is it possible that you
> >>>  booted into Windows before that and there is a  correct firmware
> >>>  already running in the card ?
> >>
> >> No my mediacenter works  only on Ubuntu
> >
> > This is weird. I will try this workaround  tonight.
> 
> Actually, I think that the dvb-fe-tda10048-1.0.fw firmware is  still
> loaded in the TV card and that this scenario has not changed  anything.
> 
> Fabio, have you tried to reboot several times in order to see  if the
> problem is really fixed?
> And are you still getting some ERROR  messages in `dmesg`? If not, this
> is good but I don't understand  :)

Yes, if "several times" means 3 times. But I think this isn't a good practice.
So I have bought another card (NOVA-T-Stick) and I wait for a real solution.

As I have written, the WinTV-1120 did work correctly with Ubunt 9.10. I haven't
had problems with this version of Ubuntu. But the linux-firmware-nonfree package 

for Ubuntu 9.10 (karmic) didn't contain the dvb-fe-tda10048-1.0.fw 
(see http://packages.ubuntu.com/karmic/all/linux-firmware-nonfree/filelist)
The dvb-fe-tda10048-1.0.fw was introduced with lucid 
(see http://packages.ubuntu.com/lucid/all/linux-firmware-nonfree/filelist).
And now the question. Why without dvb-fe-tda10048-1.0.fw I haven't had problems
and now with Ubuntu 10.04 I have problem exactly with this firmware?

So I have renamed the dvb-fe-tda10046.fw in  dvb-fe-tda10048-1.0.fw but
I have seen that Ubuntu checks if the firmware is consistent.

In the next two days I cannot post my dmesg, as I cannot access to my
mediacenter. Tuesday night I will post it.

What you think about my consideration about Ubuntu 9.10 and 10.04?


> 
> Cheers,
> 
> -- 
> Albin Kauffmann
> 


      
