Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s38.blu0.hotmail.com ([65.55.111.113]:59597 "EHLO
	blu0-omc2-s38.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972Ab0A1MSc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 07:18:32 -0500
Message-ID: <BLU0-SMTP88B07BE7A49501F3E7BBE2875C0@phx.gbl>
Subject: medion dvb stick 1660:1921 workaround
From: =?ISO-8859-1?Q?St=E9phane?= Elmaleh <s_elmaleh@hotmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Thu, 28 Jan 2010 13:18:28 +0100
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello,

I have a medion dvb stick (id 1660:1921) which is not supported yet.

This stick is made by creatix polymedia and is based on a dib7770 chip
(like the terratec XXS id 0ccd:00ab).

I managed to get it work this way on ubuntu 8.04 using kernel
2.6.24-26generic:

-downloaded the latest sources using mercurial

-made these changes in
~/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h :

replaced
#define USB_VID_TERRATEC 0x0ccd
with
#define USB_VID_TERRATEC 0x1660

and
#define USB_PID_TERRATEC_CINERGY_T_XXS_2 0x00ab
with
#define USB_PID_TERRATEC_CINERGY_T_XXS_2 0x1921

-downloaded firmware dvb-usb-dib0700-1.20.fw
to /lib/firmware/2.6.24-26-generic

-compiled and installed modules.

the stick works perfectly with kaffeine, me-tv and vlc (no others
software tested) on french networks, at least for viewing tv (I haven't
tested the remote function).
The only bug I found is if I unplug the stick and plug it back, it
doesn't work anymore. I have to reboot to make it work again.

It is recognized as a terratec stick, here is the dmesg output:

[ 2665.191119] usb 5-2: new high speed USB device using ehci_hcd and
address 5
[ 2665.324012] usb 5-2: configuration #1 chosen from 1 choice
[ 2665.616682] dib0700: loaded with support for 14 different
device-types
[ 2665.617381] dvb-usb: found a 'Terratec Cinergy T USB XXS (HD)/ T3' in
cold state, will try to load a firmware
[ 2665.641199] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
[ 2665.846088] dib0700: firmware started successfully.
[ 2666.040562] dvb-usb: found a 'Terratec Cinergy T USB XXS (HD)/ T3' in
warm state.
[ 2666.040696] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[ 2666.040861] DVB: registering new adapter (Terratec Cinergy T USB XXS
(HD)/ T3)
[ 2666.260525] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[ 2666.502751] DiB0070: successfully identified
[ 2666.502934] input: IR-receiver inside an USB DVB receiver
as /devices/pci0000:00/0000:00:1d.7/usb5/5-2/input/input9
[ 2666.551495] dvb-usb: schedule remote query interval to 50 msecs.
[ 2666.551512] dvb-usb: Terratec Cinergy T USB XXS (HD)/ T3 successfully
initialized and connected.
[ 2666.552601] usbcore: registered new interface driver dvb_usb_dib0700


I know this way of making it work is not really clean.

If I can do anything to help developing team to include this stick in
the list of supported ones, just ask.

Stéphane Elmaleh

