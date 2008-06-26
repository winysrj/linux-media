Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n23.bullet.mail.mud.yahoo.com ([68.142.206.162])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KBwvl-0002bU-TV
	for linux-dvb@linuxtv.org; Thu, 26 Jun 2008 21:14:57 +0200
Date: Thu, 26 Jun 2008 12:14:17 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <447173.66914.qm@web46104.mail.sp1.yahoo.com>
Subject: [linux-dvb] But which is better, bulk or isochronous data transfers?
Reply-To: free_beer_for_all@yahoo.com
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

There's only one way to find out...  CODE!!@!

(Excuse me.  Sorry.  My apologies.)


[If you get a sense of deja vu, I posted this to linux-kernel
 when I wasn't able to post to this list, so you can ignore this]


All seriousness aside, at the time when the
drivers/media/dvb/dvb-usb/cxusb.c code (used by, amongst others,
the Medion MD95700 which this message concerns in particular)
was introduced to the Linux kernel, it made use of an isochronous
endpoint by default.

There was a major problem here.  At that time, while one could
successfully connect a device with an isochronous datastream
output directly to a USB port, as soon as one connected a USB
hub between the device and the port, the datastream got hopelessly
mangled.  My other two isoc devices suffered the same problem
and therefore needed to be attached directly to the computer,
but additionally could not be on the same controller.

This problem with mangled isochronous transfers through USB hubs
was apparently resolved sometime before the 2.6.18 kernels, and
since then, I've used that transfer mode from my cxusb device (as the
kernel hacks are simpler and I haven't seen any clear difference).

The reason this Medion device was affected is that it has a built-in
USB hub (to which are connected the DVB-T receiver, a remote control
receiver, and an available USB port on the box) and so, in earlier
kernels, isochronous transfers from this device were garbled
beyond recognition.

However, at the time of the earlier kernels, I noted that in addition
to the used isochronous endpoint, there was also an alternate
interface with bulk endpoint available, and by hacking the code to
use that one as a bulk data interface, I got a usable picture and
listenable sound.

Bring on the later kernels, and the code is now changed so this
originally isoc endpoint is now handled as bulk (in spite of it
still being an isoc endpoint on my particular device).  But now
I can revert to handling it an isochronous endpoint in the code
as it was long ago, and finally I also get proper picture and sound
that way as well.

I've made recordings from both the bulk and the isochronous data
without problems.  Conversely, I also have recordings that I've
made from both bulk and isoc devices in which there have been
unexplained problems.  Which brings me to my first question:

Is there a good theoretical or practical reason(s) why I should
choose one of bulk or isochronous via USB in preference to the other,
given that both are available from my device, and given that I need
to patch the kernel to use either?  In particular, robustness on
a not-idle system, other USB traffic, and such that might cause
data loss, particularly with higher bandwidth Transport Streams.


Secondly I'm wondering if my (and other unmodded) devices can
coexist in the code with other devices which deliver bulk data
at the endpoint where mine delivers isochronous data.  I guess
I'd want to see the details of the modded device interfaces,
then see if I can dust off my hacking to try and distinguish
'twixt the two.


For reference, here are the endpoints of my device, in short
summarized form (major snippage) :
Number of Configurations: 1
Config Number: 1
        Number of Interfaces: 1
        Interface Number: 0
                Alternate Number: 0
                Number of Endpoints: 3

                        Endpoint Address: 82
                        Direction: in
                        Attribute: 2
                        Type: Bulk
                        Max Packet Size: 512
                        Interval: 0ms

(This is the bulk endpoint I've been able to use successfully)

                Alternate Number: 1
                        Endpoint Address: 82
                        Type: Isoc
                        Max Packet Size: 3030
                Alternate Number: 2
                        Endpoint Address: 82
                        Type: Isoc
                        Max Packet Size: 2175
                Alternate Number: 3
                        Endpoint Address: 82
                        Type: Isoc
                        Max Packet Size: 2055
                Alternate Number: 4
                        Endpoint Address: 82
                        Type: Isoc
                        Max Packet Size: 2910
                Alternate Number: 5
                        Endpoint Address: 82
                        Type: Isoc
                        Max Packet Size: 2049
                Alternate Number: 6
                        Endpoint Address: 82
                        Direction: in
                        Attribute: 1
                        Type: Isoc
                        Max Packet Size: 2820
                        Interval: 125us

(This is the endpoint which I can now use as isochronous, but
which modded devices present as, and the present kernel code
expects to be, bulk)



For little more than amusement value, I'll show what abuses I've
committed to the 2.6.18-ish code to allow me to choose either
the above bulk-0 or isoc-6 endpoint.  Don't apply this hack.
It will break the boxes which are currently functioning with
recent kernels, and hopefully it won't even apply.  The original
hack was stumbled upon during a time when I had no real Internet
access to research, and knew nothing about the availability of
alternate firmware that I discovered much later.

--- /mnt/usr/local/src/linux-2.6.18/linux-2.6/drivers/media/dvb/dvb-usb/cxusb.c-DIST    2006-09-28 21:57:18.000000000 +0200
+++ /mnt/usr/local/src/linux-2.6.18/linux-2.6/drivers/media/dvb/dvb-usb/cxusb.c2007-12-05 17:42:03.000000000 +0100
@@ -404,8 +404,36 @@
 static int cxusb_cx22702_frontend_attach(struct dvb_usb_device *d)
 {
        u8 b;
+/* XXX HACK  see comment below */
+#if 1  /* 1=iso, 0=bulk */
        if (usb_set_interface(d->udev,0,6) < 0)
                err("set interface failed");
+/* XXX isn't alt setting 6 an isoc?
+       try setting 0 as it's the only bulk... */
+#else
+       if (usb_set_interface(d->udev,0,0) < 0)
+               err("set alt0 bulk interface failed");
+#endif  /* XXX HACK */
+/* XXX if this doesn't work, looks like we have to stick with type isoc.
+                       apparent problem is that there's a built-in cypress
+                       usb2 hub in the box, and it seems that isoc data
+                       through a usb2 hub gets garbled.  I've seen this
+                       through a transaction translator with a usb1 box
+                       isoc'ing into a usb2 hub, and put that down to the
+                       TT instead.  Worst case, we need to see if we can
+                       bypass the internal hub.   or better, a much more
+                       recent kernel will have isoc transfers successfully
+                       running through a usb2 hub and all our isoc problems
+                       will be solved, yeah right.  (why was this changed
+                       from half-functioning isoc in 2.6.13 to non-functioning
+                       bulk in 2.6.14-16 anyway?)   */
+
+/* XXX later news:  as of at least 2.6.18-release, it appears that isoc
+       data through hubs/TTs now passes intact.  That means we can choose
+       between ISOC data from endpoint 6, or BULK data from endpoint 0,
+       whichever is better.  I don't know which is better.  Bulk works,
+       so why not try iso here to see if it's as good?  So, new hacks...  */
+

        cxusb_ctrl_msg(d,CMD_DIGITAL, NULL, 0, &b, 1);

@@ -531,6 +559,21 @@

        .generic_bulk_ctrl_endpoint = 0x01,
        /* parameter for the MPEG2-data transfer */
+#if 1 /* XXX  HACK  use iso; see above  */
+       .urb = {
+               .type = DVB_USB_ISOC,
+               .count = 5,
+               .endpoint = 0x02,
+               .u = {
+                       .isoc = {
+                               .framesperurb = 32,
+                               .framesize = 940,
+                               .interval = 5,
+                       }
+               }
+       },
+
+#else
        .urb = {
                .type = DVB_USB_BULK,
                .count = 5,
@@ -541,6 +584,7 @@
                        }
                }
        },
+#endif  /* XXX  */

        .num_device_descs = 1,
        .devices = {

 ==>  THE ABOVE IS NOT A PATCH TO BE APPLIED, DANGER, GO AWAY


BOUWSMA Barry


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
