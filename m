Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KjH6b-0003FK-3d
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 19:27:51 +0200
Received: by nf-out-0910.google.com with SMTP id g13so435426nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 26 Sep 2008 10:27:45 -0700 (PDT)
Message-ID: <412bdbff0809261027w501b469ehd0f09d392f600fad@mail.gmail.com>
Date: Fri, 26 Sep 2008 13:27:45 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Oliver Kleinecke" <okleinecke@web.de>
In-Reply-To: <1959297291@web.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <1959297291@web.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Need help getting the remote of a Nova-T USB-Stick
	to work
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

2008/9/26 Oliver Kleinecke <okleinecke@web.de>:
> I compiled the latest stable v4l-dvb-drivers, everything worked fine, and i`m able to watch tv with kaffeine and mythtv already.
> Now i would like to get the remote to work .. the ir-receiver shows up during boot, giving the following ouput :
>
> "kernel: input: IR-receiver inside an USB DVB receiver as /class/input/input7".
>
> If i do a lsinput, the device shows up like this :
>
> /dev/input/event7
>   bustype : BUS_USB
>   vendor  : 0x2040
>   product : 0x7070
>   version : 256
>   name    : "IR-receiver inside an USB DVB re"
>   phys    : "usb-0001:10:1b.2-1/ir0"
>   bits ev : EV_SYN EV_KEY
>
>
> so i`m pretty sure i am not toooo far away from the solution.
>
> but if i press a button on the rc, it just gives me kernel messages like this :
>
> "kernel: dib0700: Unknown remote controller key: 1D  2  0  0"
>
>
> After a bit of googling, i found out, that there seems to be a solution, using a diff file, which i downloaded already, its attached to this mail.
>
> Now i need a bit of support in using this diff-file correctly, and some infos on how to continue then..

That patch looks pretty straightforward.  Where did it come from?
Have you tried it out:

cd v4l-dvb
patch -p0 < path_to_patch_file
make
make install
reboot
See if it works...

(or you might have to do "patch -p1", depending on the patch)

If it works for you, it can be checked in so others won't have to deal
with the problem in the future.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
