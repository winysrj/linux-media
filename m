Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zeph7r@gmail.com>) id 1KSVUF-0000Xk-Gn
	for linux-dvb@linuxtv.org; Mon, 11 Aug 2008 13:22:56 +0200
Received: by fg-out-1718.google.com with SMTP id e21so956699fga.25
	for <linux-dvb@linuxtv.org>; Mon, 11 Aug 2008 04:22:51 -0700 (PDT)
Message-ID: <48A020FD.6000400@gmail.com>
Date: Mon, 11 Aug 2008 12:22:37 +0100
From: zePh7r <zeph7r@gmail.com>
MIME-Version: 1.0
To: Albert Comerma <albert.comerma@gmail.com>
References: <ea4209750808080532h950d84fud047c135551e1ff1@mail.gmail.com>	
	<489CCD82.5030406@gmail.com>
	<ea4209750808100251j3d027cable1e5cd81ceb4995@mail.gmail.com>
In-Reply-To: <ea4209750808100251j3d027cable1e5cd81ceb4995@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Support for Asus My-Cinema U3000Hybrid?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Albert Comerma escreveu:
> Sorry, I didn't explained much... it also took some time to me to 
> understand how it's working... Since xc2028 is the tunner it has no Id 
> information on the code. The id's are on the usb bridge code. You 
> should add your deviece id's at;
> /v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h and then insert 
> your device at
> /v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c    first 
> the device descriptors (at arround line 1120) and then the device 
> itself, I would try it around line 1418. This last file, has already 
> the include to the xc2028 code and calls the tunner funcions. Looking 
> the code around this lines I guess you will understand how it works.
>
> Albert
>
> 2008/8/9 zePh7r <zeph7r@gmail.com <mailto:zeph7r@gmail.com>>
>
>     Albert Comerma escreveu:
>
>         Just to clarify things...
>
>         Xceive chips are just tunners, RF chips, mostly analogue with
>         some digital interface, they don't do anything with usb or
>         comunication with the computer, for this reason you need the
>         dibcom chip, it's a usb bridge + decoder + something else...
>         To start to develop something you must first be sure of what
>         chips it's using.
>         If not you can try blindly if modifying the code for the
>         U3000-Mini works or Pinnacle 320cx (dibcom 7700 + xceive2028)
>         work (you just need to add your device usb id's).
>
>         Albert
>
>     Thank you for replying Albert.
>     I've been exploring the files downloaded through the mercurial
>     repository and though I have found files which seem like they
>     relate to that purpose in
>     /v4l-dvb/linux/drivers/media/common/tuners (which are
>     tuner-xc2028.c , tuner-xc2028.h and tuner-xc2028-types.h) I can't
>     find any section in the above files with some sort of list of
>     device ID's so as to resemble them. There should be something like
>     an xc2028-cards.c right?
>     This must seem a noob question but this whole process looks like
>     something someone who's not deeply into this project couldn't do
>     easily..
>
>
Thank you for being assisting me on this task Albert.
I've been exploring the files you mentioned and I'm a bit puzzled about 
this specific string: &dib0700_usb_id_table[32] (where 32 is the value 
for one of the cards). I couldn't find any correlation envolved with it. 
Is there any special place I should look at to get the proper value for 
this string?
Also, the last section seemed  the right one to add the entry for my 
device. Do you agree?

Thanks..

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
