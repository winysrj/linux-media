Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBR4urAB032032
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 23:56:53 -0500
Received: from outbound.mail.nauticom.net (outbound.mail.nauticom.net
	[72.22.18.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBR4u5Cu019278
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 23:56:06 -0500
Received: from [192.168.0.124] (27.craf1.xdsl.nauticom.net [209.195.160.60])
	(authenticated bits=0)
	by outbound.mail.nauticom.net (8.14.0/8.14.0) with ESMTP id
	mBR4u683066831
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 23:56:06 -0500 (EST)
From: Rick Bilonick <rab@nauticom.net>
To: video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <20081226174129.7c752fc6@gmail.com>
References: <1230233794.3450.33.camel@localhost.localdomain>
	<20081226010307.2c7e3b55@gmail.com>
	<1230269443.3450.48.camel@localhost.localdomain>
	<20081226174129.7c752fc6@gmail.com>
Content-Type: text/plain
Date: Fri, 26 Dec 2008 23:56:04 -0500
Message-Id: <1230353764.3450.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: Compiling v4l-dvb-kernel for Ubuntu and for F8
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


On Fri, 2008-12-26 at 17:41 -0200, Douglas Schilling Landgraf wrote:
> Hello,
> 
> On Fri, 26 Dec 2008 00:30:43 -0500
> Rick Bilonick <rab@nauticom.net> wrote:
> 
> > I don't know what you mean by "upstream" driver. In Ubuntu 8.10, I did
> > an "lsmod" and both the em28xx and em28xx_dvb modules show up.
> > "modprobe -l | grep em28" also shows these modules. Does that mean I
> > don't have to compile them from scratch? If they already exist, what
> > else do I have to do to get the HD Pro to receive broadcasts?
> 
> Upstream means "official", in this case official supported driver. 
> 
> I'd like to suggest:
> 
> Remove your device from usb before start your computer:
> 
> Clone official driver from linuxtv host:
> 
> shell> hg clone http://linuxtv.org/hg/v4l-dvb
> shell> cd v4l-dvb
> shell> make 
> shell> make install
> 
> Plug your device and try to play your favorite tv application.
> If you get any problem or sucess with drivers from v4l-dvb tree send
> your report to this mail-list with lsusb and dmesg output. 
> 
> p.s:
> There is a link at linuxtv wiki about compilation process from
> v4l-dvb tree:
> http://www.linuxtv.org/wiki/index.php/How_to_build_from_Mercurial
> 
> Cheers,
> Douglas

OK, I'm making progress. Everything seemed to compile and install OK.
Here is the initial dmesg info after plugging in the usb tuner:

> dmesg
...

[13255.448076] usb 1-2: new high speed USB device using ehci_hcd and
address 4
[13255.626448] usb 1-2: configuration #1 chosen from 1 choice
[13255.988404] dib0700: loaded with support for 8 different device-types
[13255.990635] dvb-usb: found a 'Pinnacle PCTV HD Pro USB Stick' in cold
state, will try to load a firmware
[13255.990655] firmware: requesting dvb-usb-dib0700-1.20.fw
[13256.052625] dvb-usb: did not find the firmware file.
(dvb-usb-dib0700-1.20.fw) Please see linux/Documentation/dvb/ for more
details on firmware-problems. (-2)
[13256.056699] usbcore: registered new interface driver dvb_usb_dib0700

So I found a copy of dvb-usb-dib0700-1.20.fw on the Internet, and copied
it to /lib/firmware. Then:

[14430.324062] usb 1-2: new high speed USB device using ehci_hcd and
address 6
[14430.488101] usb 1-2: configuration #1 chosen from 1 choice
[14430.489686] dvb-usb: found a 'Pinnacle PCTV HD Pro USB Stick' in cold
state, will try to load a firmware
[14430.489705] firmware: requesting dvb-usb-dib0700-1.20.fw
[14430.530911] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
[14430.770914] dib0700: firmware started successfully.
[14431.272091] dvb-usb: found a 'Pinnacle PCTV HD Pro USB Stick' in warm
state.
[14431.277385] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[14431.280117] DVB: registering new adapter (Pinnacle PCTV HD Pro USB
Stick)
[14431.921370] DVB: registering adapter 0 frontend 0 (Samsung S5H1411
QAM/8VSB Frontend)...
[14432.046721] xc5000 1-0064: creating new instance

A new device was created: /dev/dvb/adapter0. But:

[14432.049021] xc5000: Successfully identified at address 0x64
[14432.049036] xc5000: Firmware has not been loaded previously
[14432.053380] input: IR-receiver inside an USB DVB receiver
as /devices/pci0000:00/0000:00:10.4/usb1/1-2
/input/input11
[14432.084926] dvb-usb: schedule remote query interval to 50 msecs.
[14432.084959] dvb-usb: Pinnacle PCTV HD Pro USB Stick successfully
initialized and connected.
[14552.858918] xc5000: waiting for firmware upload
(dvb-fe-xc5000-1.1.fw)...
[14552.858939] firmware: requesting dvb-fe-xc5000-1.1.fw
[14552.868339] xc5000: Upload failed. (file not found?)
[14552.868364] xc5000: Unable to initialise tuner
[14552.869594] DVB: adapter 0 frontend 0 frequency 0 out of range
(54000000..858000000)
[14596.990589] xc5000: waiting for firmware upload
(dvb-fe-xc5000-1.1.fw)...
[14596.990610] firmware: requesting dvb-fe-xc5000-1.1.fw
[14596.999976] xc5000: Upload failed. (file not found?)
[14597.000064] xc5000: Unable to initialise tuner
[14933.320581] xc5000: waiting for firmware upload
(dvb-fe-xc5000-1.1.fw)...
[14933.320601] firmware: requesting dvb-fe-xc5000-1.1.fw

So far, I haven't been able to find dvb-fe-xc5000-1.1.fw. (I had
previously installed a firmware file (version 4), but apparently the
needed firmware is not in the tar file.

Thanks for the help. I'm going to continue looking for the firmware.

I'm not sure if this firmware is absolutely necessary given it appears
to be the IR receiver. I am trying to use xine (I have a channel.conf
file that I created for a different tuner in another computer) but so
far have not gotten xine to display the digital signal.

Rick B.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
