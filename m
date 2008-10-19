Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt3.poste.it ([62.241.4.129])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1KrZA8-0003Tz-1H
	for linux-dvb@linuxtv.org; Sun, 19 Oct 2008 16:21:47 +0200
Received: from geppetto.reilabs.com (78.15.163.4) by relay-pt3.poste.it
	(7.3.122) (authenticated as stefano.sabatini-lala@poste.it)
	id 48FA6AB700002D41 for linux-dvb@linuxtv.org;
	Sun, 19 Oct 2008 16:21:40 +0200
Received: from stefano by geppetto.reilabs.com with local (Exim 4.67)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1KrZ8w-0003CO-Q8
	for linux-dvb@linuxtv.org; Sun, 19 Oct 2008 16:20:30 +0200
Date: Sun, 19 Oct 2008 16:20:30 +0200
From: Stefano Sabatini <stefano.sabatini-lala@poste.it>
To: linux-dvb@linuxtv.org
Message-ID: <20081019142030.GA10261@geppetto>
References: <20081016190946.GB25806@geppetto>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081016190946.GB25806@geppetto>
Subject: [linux-dvb] v4l-dvb gspca modules conflict with standalone gspca
	module
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

On date Thursday 2008-10-16 21:09:46 +0200, Stefano Sabatini wrote:
> Hi all,
> 
> I'm having this problem when trying to compile the modules for linux
> 2.6.26 on a Debian system:
> 
> |stefano@geppetto ~/s/v4l-dvb> make 
> |make -C /home/stefano/src/v4l-dvb/v4l 
> |make[1]: Entering directory `/home/stefano/src/v4l-dvb/v4l'
> |No version yet, using 2.6.26-1-686
> |make[1]: Leaving directory `/home/stefano/src/v4l-dvb/v4l'
> |make[1]: Entering directory `/home/stefano/src/v4l-dvb/v4l'
> |scripts/make_makefile.pl
> |Updating/Creating .config
> |Preparing to compile for kernel version 2.6.26
> |
> |***WARNING:*** You do not have the full kernel sources installed.
> |This does not prevent you from building the v4l-dvb tree if you have the
> |kernel headers, but the full kernel source may be required in order to use
> |make menuconfig / xconfig / qconfig.
> |
> |If you are experiencing problems building the v4l-dvb tree, please try
> |building against a vanilla kernel before reporting a bug.
> |
> |Vanilla kernels are available at http://kernel.org.
> |On most distros, this will compile a newly downloaded kernel:
> 
> I'm on a Debian sytem with kernel and headers at version 2.6.26, so I
> suppose it should find the complete kernel tree.
> 
> |stefano@geppetto /l/modules> uname -a
> |Linux geppetto 2.6.26-1-686 #1 SMP Thu Oct 9 15:18:09 UTC 2008 i686 GNU/Linux
> |stefano@geppetto /l/modules> ls -l /lib/modules/
> |total 36
> |drwxr-xr-x 2 root root 4096 2008-10-14 20:08 2.6.21-2-686/
> |drwxr-xr-x 4 root root 4096 2008-08-23 13:04 2.6.22-2-686/
> |drwxr-xr-x 5 root root 4096 2008-10-13 08:57 2.6.22-3-486/
> |drwxr-xr-x 3 root root 4096 2008-10-13 08:57 2.6.22-3-686/
> |drwxr-xr-x 2 root root 4096 2008-09-24 20:11 2.6.24-etchnhalf.1-686/
> |drwxr-xr-x 2 root root 4096 2008-09-24 20:12 2.6.25-2-486/
> |drwxr-xr-x 3 root root 4096 2008-09-24 20:12 2.6.25-2-686/
> |drwxr-xr-x 3 root root 4096 2008-10-15 11:29 2.6.26-1-486/
> |drwxr-xr-x 4 root root 4096 2008-10-16 20:50 2.6.26-1-686/
> 
> Then when I attach a gspca webcam I get this output in dmesg:
> |[43518.309407] usb 2-2: USB disconnect, address 10
> |[43520.040151] usb 2-2: new full speed USB device using uhci_hcd and address 11
> |[43520.231991] usb 2-2: configuration #1 chosen from 1 choice
> |[43520.256243] usb 2-2: New USB device found, idVendor=046d, idProduct=08d9
> |[43520.256243] usb 2-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> |[43520.290979] Linux video capture interface: v2.00
> |[43520.292764] gspca: disagrees about version of symbol video_devdata
> |[43520.292773] gspca: Unknown symbol video_devdata
> |[43520.293829] gspca: disagrees about version of symbol video_unregister_device
> |[43520.293829] gspca: Unknown symbol video_unregister_device
> |[43520.293829] gspca: disagrees about version of symbol video_device_alloc
> |[43520.293829] gspca: Unknown symbol video_device_alloc
> |[43520.293829] gspca: disagrees about version of symbol video_register_device
> |[43520.293829] gspca: Unknown symbol video_register_device
> |[43520.293829] gspca: disagrees about version of symbol video_usercopy
> |[43520.293829] gspca: Unknown symbol video_usercopy
> |[43520.293829] gspca: disagrees about version of symbol video_device_release
> |[43520.293829] gspca: Unknown symbol video_device_release
> |[43520.301833] gspca: main v2.3.0 registered
> |[43520.301833] gspca: disagrees about version of symbol video_devdata
> |[43520.301833] gspca: Unknown symbol video_devdata
> |[43520.301833] gspca: disagrees about version of symbol video_unregister_device
> |[43520.301833] gspca: Unknown symbol video_unregister_device
> |[43520.301833] gspca: disagrees about version of symbol video_device_alloc
> |[43520.301833] gspca: Unknown symbol video_device_alloc
> |[43520.301833] gspca: disagrees about version of symbol video_register_device
> |[43520.301833] gspca: Unknown symbol video_register_device
> |[43520.301833] gspca: disagrees about version of symbol video_usercopy
> |[43520.301833] gspca: Unknown symbol video_usercopy
> |[43520.301833] gspca: disagrees about version of symbol video_device_release
> |[43520.301833] gspca: Unknown symbol video_device_release
> |[43520.307220] gspca: probing 046d:08d9
> |[43521.944222] zc3xx: probe 2wr ov vga 0x0000
> |[43521.987916] zc3xx: probe sensor -> 11
> |[43521.987916] zc3xx: Find Sensor HV7131R(c)
> |[43521.992836] gspca: probe ok
> |[43521.992836] usbcore: registered new interface driver zc3xx
> |[43521.992836] zc3xx: registered
> 
> Strangely enough I don't have the same problem when I try to load
> another module from the same v4l-dvb source.
> 
> I'm using 4vl-dvb mercurial.
> 
> I'll be grateful for any help you can provide.

The problem seems to stem from some conflicts with the previous
installation of a standalone gspca kernel already installed.

On debian I previously installed the gspca module using the usual
module-assistant procedure (m-a a-i gspca), which generetes just one
gspca.ko file.

When installing the v4l-dv package it install many gscpa related
modules, which issue the "Unknown symbol" problem if the previous
gspca modules hasn't been removed.

So removing the old gspca.ko module seems to be the right fix.

BTW I wonder why v4l-dvb includes the gspca modules, which seem to be
related more to the gspca cameras than to DVB devices

Regards.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
