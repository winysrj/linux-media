Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAL0OM2v027447
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 19:24:22 -0500
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAL0OBbv024165
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 19:24:12 -0500
Received: by rn-out-0910.google.com with SMTP id k32so706294rnd.7
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 16:24:11 -0800 (PST)
Message-ID: <c2fe070d0811201624m132b1a52ndf5ae34ac93c1ff4@mail.gmail.com>
Date: Thu, 20 Nov 2008 21:24:11 -0300
From: "leandro Costantino" <lcostantino@gmail.com>
To: "Jean-Francois Moine" <moinejf@free.fr>
In-Reply-To: <1227207831.1708.58.camel@localhost>
MIME-Version: 1.0
References: <200811151218.45664.m.kozlowski@tuxland.pl>
	<30353c3d0811190552y2ef78b53s833182da377a5046@mail.gmail.com>
	<492439AE.1070903@redhat.com>
	<200811192256.09361.m.kozlowski@tuxland.pl>
	<1227205179.1708.47.camel@localhost>
	<30353c3d0811201057o2244ca80of033e3bead96c779@mail.gmail.com>
	<1227207831.1708.58.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
	David Ellingsworth <david@identd.dyndns.org>, video4linux-list@redhat.com
Subject: Re: [v4l-dvb-maintainer] [BUG] zc3xx oopses on unplug: unable to
	handle kernel paging request
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

On Thu, Nov 20, 2008 at 4:03 PM, Jean-Francois Moine <moinejf@free.fr>wrote:

> On Thu, 2008-11-20 at 13:57 -0500, David Ellingsworth wrote:
> > I'm not entirely sure what's going on in the gspca driver. It seems as
> > though the module count is wrong. Unfortunately, I don't have a camera
>
> No, the module count is correct, the problem is that it is incremented /
> decremented by 2 at each open / close. Don't you have the same behaviour
> with stk-webcam?
>
> [SNIP]
>
>
Just for the record. I tested my webcam (zc3xx) usb id on logs. Kernel
2.6.27-rc6 original (gspca 2.3.x) and with lastest hg gspca.
And couldn't reproduce the bug. Worked as expected.
Could this be related to another thing?

***2.6.27-rc6 original***

gspca: main v2.3.0

[ 2903.937468] rxwebcam[23513]: segfault at b6895008 ip 0805e8d0 sp bf970d40
error 6 in rxwebcam[8048000+36000]
[ 3441.672080] wlan0: no IPv6 routers present
[ 3462.933359] ath5k phy0: bf=ed835a40 bf_skb=00000000
[ 3462.933379] wlan0: Selected IBSS BSSID 1e:dc:34:3a:83:17 based on
configured SSID
[ 3462.964934] ath5k phy0: bf=ed835a40 bf_skb=00000000
[ 3462.990417] ath5k phy0: bf=ed835a40 bf_skb=00000000
[ 4314.256080] usb 6-1: USB disconnect, address 2
[ 4314.257781] gspca: urb status: -108
[ 4314.257787] gspca: urb status: -108
[ 4314.260939] gspca: disconnect complete
[ 4345.288071] usb 6-2: new full speed USB device using uhci_hcd and address
3
[ 4345.480872] usb 6-2: configuration #1 chosen from 1 choice
[ 4345.482644] gspca: probing 0ac8:301b
[ 4347.103398] zc3xx: probe 2wr ov vga 0x0000
[ 4347.222391] zc3xx: probe 3wr vga 1 0x8000
[ 4347.227395] zc3xx: probe sensor -> 14
[ 4347.227398] zc3xx: Find Sensor CS2102K?. Chip revision 8000
[ 4347.233597] gspca: probe ok
[ 4378.492090] usb 6-2: USB disconnect, address 3
[ 4378.493391] gspca: urb status: -108
[ 4378.493398] gspca: urb status: -108
[ 4378.495599] gspca: disconnect complete

***2.6.27-rc6 + gspca-902cc23a6723  (lastest) ****

[ 4656.965493] usbcore: deregistering interface driver zc3xx
[ 4656.965615] zc3xx: deregistered
[ 4659.333068] usbcore: deregistering interface driver ALi m5602
[ 4659.333394] gspca: disconnect complete
[ 4659.333538] ALi m5602: deregistered
[ 4659.338052] gspca: main deregistered
[ 4675.576083] usb 6-2: new full speed USB device using uhci_hcd and address
4
[ 4675.768602] usb 6-2: configuration #1 chosen from 1 choice
[ 4675.783522] Linux video capture interface: v2.00
[ 4675.785721] gspca: main v2.4.0 registered
[ 4675.786911] gspca: probing 0ac8:301b
[ 4677.419313] zc3xx: probe 2wr ov vga 0x0000
[ 4677.542335] zc3xx: probe 3wr vga 1 0x8000
[ 4677.547304] zc3xx: probe sensor -> 14
[ 4677.547310] zc3xx: Find Sensor CS2102K?. Chip revision 8000
[ 4677.552456] gspca: probe ok
[ 4677.552478] usbcore: registered new interface driver zc3xx
[ 4677.552482] zc3xx: registered
[ 4704.608077] usb 6-2: USB disconnect, address 4
[ 4704.609288] gspca: urb status: -108
[ 4704.609296] gspca: urb status: -108
[ 4704.610951] gspca: disconnect complete


I will take further look later.
Best Regards.
Costantino Leandro
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
