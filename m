Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1KS7ak-0000sE-PQ
	for linux-dvb@linuxtv.org; Sun, 10 Aug 2008 11:52:03 +0200
Received: by py-out-1112.google.com with SMTP id a29so844859pyi.0
	for <linux-dvb@linuxtv.org>; Sun, 10 Aug 2008 02:51:58 -0700 (PDT)
Message-ID: <ea4209750808100251j3d027cable1e5cd81ceb4995@mail.gmail.com>
Date: Sun, 10 Aug 2008 11:51:57 +0200
From: "Albert Comerma" <albert.comerma@gmail.com>
To: zePh7r <zeph7r@gmail.com>
In-Reply-To: <489CCD82.5030406@gmail.com>
MIME-Version: 1.0
References: <ea4209750808080532h950d84fud047c135551e1ff1@mail.gmail.com>
	<489CCD82.5030406@gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Support for Asus My-Cinema U3000Hybrid?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1220021292=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1220021292==
Content-Type: multipart/alternative;
	boundary="----=_Part_28492_10909925.1218361917754"

------=_Part_28492_10909925.1218361917754
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Sorry, I didn't explained much... it also took some time to me to understand
how it's working... Since xc2028 is the tunner it has no Id information on
the code. The id's are on the usb bridge code. You should add your deviece
id's at;
/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h and then insert your
device at
/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c    first the
device descriptors (at arround line 1120) and then the device itself, I
would try it around line 1418. This last file, has already the include to
the xc2028 code and calls the tunner funcions. Looking the code around this
lines I guess you will understand how it works.

Albert

2008/8/9 zePh7r <zeph7r@gmail.com>

> Albert Comerma escreveu:
>
>  Just to clarify things...
>>
>> Xceive chips are just tunners, RF chips, mostly analogue with some digital
>> interface, they don't do anything with usb or comunication with the
>> computer, for this reason you need the dibcom chip, it's a usb bridge +
>> decoder + something else...
>> To start to develop something you must first be sure of what chips it's
>> using.
>> If not you can try blindly if modifying the code for the U3000-Mini works
>> or Pinnacle 320cx (dibcom 7700 + xceive2028) work (you just need to add your
>> device usb id's).
>>
>> Albert
>>
> Thank you for replying Albert.
> I've been exploring the files downloaded through the mercurial repository
> and though I have found files which seem like they relate to that purpose in
> /v4l-dvb/linux/drivers/media/common/tuners (which are tuner-xc2028.c ,
> tuner-xc2028.h and tuner-xc2028-types.h) I can't find any section in the
> above files with some sort of list of device ID's so as to resemble them.
> There should be something like an xc2028-cards.c right?
> This must seem a noob question but this whole process looks like something
> someone who's not deeply into this project couldn't do easily..
>

------=_Part_28492_10909925.1218361917754
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Sorry, I didn&#39;t explained much... it also took some time to me to understand how it&#39;s working... Since xc2028 is the tunner it has no Id information on the code. The id&#39;s are on the usb bridge code. You should add your deviece id&#39;s at;<br>
/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h and then insert your device at <br>/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c &nbsp;&nbsp; first the device descriptors (at arround line 1120) and then the device itself, I would try it around line 1418. This last file, has already the include to the xc2028 code and calls the tunner funcions. Looking the code around this lines I guess you will understand how it works.<br>
<br>Albert<br><br><div class="gmail_quote">2008/8/9 zePh7r <span dir="ltr">&lt;<a href="mailto:zeph7r@gmail.com">zeph7r@gmail.com</a>&gt;</span><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Albert Comerma escreveu:<div><div></div><div class="Wj3C7c"><br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Just to clarify things...<br>
<br>
Xceive chips are just tunners, RF chips, mostly analogue with some digital interface, they don&#39;t do anything with usb or comunication with the computer, for this reason you need the dibcom chip, it&#39;s a usb bridge + decoder + something else...<br>

To start to develop something you must first be sure of what chips it&#39;s using.<br>
If not you can try blindly if modifying the code for the U3000-Mini works or Pinnacle 320cx (dibcom 7700 + xceive2028) work (you just need to add your device usb id&#39;s).<br>
<br>
Albert<br>
</blockquote></div></div>
Thank you for replying Albert.<br>
I&#39;ve been exploring the files downloaded through the mercurial repository and though I have found files which seem like they relate to that purpose in /v4l-dvb/linux/drivers/media/common/tuners (which are tuner-xc2028.c , tuner-xc2028.h and tuner-xc2028-types.h) I can&#39;t find any section in the above files with some sort of list of device ID&#39;s so as to resemble them. There should be something like an xc2028-cards.c right?<br>

This must seem a noob question but this whole process looks like something someone who&#39;s not deeply into this project couldn&#39;t do easily..<br>
</blockquote></div><br></div>

------=_Part_28492_10909925.1218361917754--


--===============1220021292==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1220021292==--
