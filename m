Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JnzDg-0004Sx-O1
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 18:50:21 +0200
Received: by wr-out-0506.google.com with SMTP id c30so867984wra.14
	for <linux-dvb@linuxtv.org>; Mon, 21 Apr 2008 09:50:15 -0700 (PDT)
Message-ID: <d9def9db0804210950v17f8f885vcfbbda4f0c8b4663@mail.gmail.com>
Date: Mon, 21 Apr 2008 18:50:14 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "allan k" <sonofzev@iinet.net.au>
In-Reply-To: <1208794528.9790.10.camel@media1>
MIME-Version: 1.0
Content-Disposition: inline
References: <1208794528.9790.10.camel@media1>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] help with dvico usb remote on gentoo
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

Hi,

On 4/21/08, allan k <sonofzev@iinet.net.au> wrote:
> Hi All
>
> While I'm waiting for help with the dvico dual express. I have been
> trying to get the dvico usb remote working on gentoo.
>
> I've followed the couple of how-tos for gentoo and lirc and come up with
> the same problem every time.
>
> I get stuck where it asks to load the module......
>
> After running emerge lirc, I find there is no lirc_dvico module, as all
> the instructions mention. as such I don't end up with an lirc device in
> my /dev/ directory.
>
> I tried issuing the config-kernel --allow-writeable=yes but my system
> has no such command and I can't find which package it belongs to.
>
> I'm pretty sure I'm missing something simple, so any advice will be
> appreciated.
>

can you see such an inputdevice in /proc/bus/input/devices?

$ cat /proc/bus/input/devices
I: Bus=0003 Vendor=0000 Product=0000 Version=0000
N: Name="em2880/em2870 remote control"
...
H: Handlers=kbd event5
...

this is the remote control interface of my device (note the event[n] entry)

if something related to the dvico device shows up there then you have
to select the devinput driver in the lirc menu, this doesn't require
any kernelmodule.

/etc/lirc/hardware.conf should contain following lines:
DRIVER="dev/input"  <- this is the devinput driver
DEVICE="/dev/input/event5" (here you have to put your corresponding event[n]

Hope this helps.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
