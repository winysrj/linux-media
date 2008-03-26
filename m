Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from omta05ps.mx.bigpond.com ([144.140.83.195])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ptay1685@Bigpond.net.au>) id 1JeKab-0004F8-UT
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 02:38:13 +0100
Received: from oaamta03ps.mx.bigpond.com ([58.172.153.185])
	by omta05ps.mx.bigpond.com with ESMTP id
	<20080326013723.QEAV28762.omta05ps.mx.bigpond.com@oaamta03ps.mx.bigpond.com>
	for <linux-dvb@linuxtv.org>; Wed, 26 Mar 2008 01:37:23 +0000
Message-ID: <001501c88ee1$f0466470$6e00a8c0@barny1e59e583e>
From: "ptay1685" <ptay1685@Bigpond.net.au>
To: "Antti Palosaari" <crope@iki.fi>
References: <007201c88ce2$5909c850$6e00a8c0@barny1e59e583e>
	<47E6DD2D.9040204@iki.fi>
Date: Wed, 26 Mar 2008 12:37:22 +1100
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] leadtek dtv dongle
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

How do I tell the usb-id? Tried to do a lsusb -v but the command is 
unrecognised.

Note that the Leadtek device is not actually recognised by the kernel (shown 
via dmesg).

The following is from a previous conversation on this mailing list and might 
give you the info you need:
_______________________________________________________________________________

Hi,

How do I get a patch incorporated into the dvb kernel section ?

After recently purchasing a LeadTek WinFast DTV Dongle I rapidly
discovered it was the variant that was not recognized in the kernel

i.e. as previously reported at:
http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022373.html
http://www.linuxtv.org/pipermail/linux-dvb/2008-January/023175.html

its device ids are: (lsusb)
ID 0413:6f01 Leadtek Research, Inc.

Rather than make the changes suggested by previous posters I set about
making a script and associated kernel patches to automatically do this.
My motivation was simple: I use a laptop with an ATI graphics card and
fedora 8. I find the best drivers for this card are currently from Livna
and are updated monthly (and changes are significant at the moment i.e.
see the phoronix forum). So I would need to do this repeatedly.

In my patch I add an identifier (USB_PID_WINFAST_DTV_DONGLE_STK7700P_B)
and modify the table appropriately

When I plug it in I now see in my messages log
kernel: usb 1-4: new high speed USB device using ehci_hcd and address 9
kernel: usb 1-4: configuration #1 chosen from 1 choice
kernel: dib0700: loaded with support for 2 different device-types
kernel: dvb-usb: found a 'Leadtek Winfast DTV Dongle B (STK7700P based)'
in cold state, will try to load a firmware
kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-01.fw'
kernel: dib0700: firmware started successfully.
kernel: dvb-usb: found a 'Leadtek Winfast DTV Dongle B (STK7700P based)'
in warm state.
kernel: dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
kernel: DVB: registering new adapter (Leadtek Winfast DTV Dongle B
(STK7700P based))
kernel: DVB: registering frontend 0 (DiBcom 7000PC)...
kernel: MT2060: successfully identified (IF1 = 1220)
kernel: dvb-usb: Leadtek Winfast DTV Dongle B (STK7700P based)
successfully initialized and connected.
kernel: usbcore: registered new interface driver dvb_usb_dib0700


My kernel patch ( other scripts to patch the Fedora 8 src rpm's
available on request)
----------------
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c       2008-02-13
10:05:13.000000000 +1100
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c       2008-02-13
10:22:16.000000000 +1100
@@ -280,6 +280,7 @@ struct usb_device_id dib0700_usb_id_tabl
                { USB_DEVICE(USB_VID_LEADTEK,
USB_PID_WINFAST_DTV_DONGLE_STK7700P) },
                { USB_DEVICE(USB_VID_HAUPPAUGE,
USB_PID_HAUPPAUGE_NOVA_T_STICK_2) },
                { USB_DEVICE(USB_VID_AVERMEDIA,
USB_PID_AVERMEDIA_VOLAR_2) },
+               { USB_DEVICE(USB_VID_LEADTEK,
USB_PID_WINFAST_DTV_DONGLE_STK7700P_B) },
                { }             /* Terminating entry */
};
MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -321,7 +322,7 @@ struct dvb_usb_device_properties dib0700
                        },
                },

-               .num_device_descs = 6,
+               .num_device_descs = 7,
                .devices = {
                        {   "DiBcom STK7700P reference design",
                                { &dib0700_usb_id_table[0],
&dib0700_usb_id_table[1] },
@@ -346,6 +347,10 @@ struct dvb_usb_device_properties dib0700
                        {   "Leadtek Winfast DTV Dongle (STK7700P
based)",
                                { &dib0700_usb_id_table[8], NULL },
                                { NULL },
+                       },
+                       {   "Leadtek Winfast DTV Dongle B (STK7700P
based)",
+                               { &dib0700_usb_id_table[11], NULL },
+                               { NULL },
                        }
                }
        }, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h   2008-02-13
10:05:13.000000000 +1100
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h   2008-02-13
10:18:00.000000000 +1100
@@ -148,6 +148,7 @@
#define USB_PID_WINFAST_DTV_DONGLE_COLD                        0x6025
#define USB_PID_WINFAST_DTV_DONGLE_WARM                        0x6026
#define USB_PID_WINFAST_DTV_DONGLE_STK7700P            0x6f00
+#define USB_PID_WINFAST_DTV_DONGLE_STK7700P_B          0x6f01
#define USB_PID_GENPIX_8PSK_COLD                       0x0200
#define USB_PID_GENPIX_8PSK_WARM                       0x0201
#define USB_PID_SIGMATEK_DVB_110                       0x6610



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

----- Original Message ----- 
From: "Antti Palosaari" <crope@iki.fi>
To: "ptay1685" <ptay1685@Bigpond.net.au>
Cc: <linux-dvb@linuxtv.org>
Sent: Monday, March 24, 2008 9:43 AM
Subject: Re: [linux-dvb] leadtek dtv dongle


> ptay1685 wrote:
>>
>> Any news about the new version of the dtv dongle? Still does not work
>> with the latest v4l sources. Anyone know whats happening?
>>
>> Many thanks,
>>
>> Phil T.
>
> Can you say what is usb-id of your device? Also lsusb -v could be nice
> to see.
>
> regards
> Antti
> -- 
> http://palosaari.fi/
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
