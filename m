Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33206 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbZJPV5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 17:57:50 -0400
Received: by fxm18 with SMTP id 18so2958285fxm.37
        for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 14:57:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AD8E987.8090609@schirrms.net>
References: <4AD8E987.8090609@schirrms.net>
Date: Fri, 16 Oct 2009 17:57:54 -0400
Message-ID: <829197380910161457w2158a69fyc9fbe1afd1c567d0@mail.gmail.com>
Subject: Re: New member, trying to setup a Pinnacle Quatro stick
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: ps1 <ps1@schirrms.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 16, 2009 at 5:45 PM, ps1 <ps1@schirrms.net> wrote:
> Hi,
>
> I recenly own a Pinnacle (or Pctv now) Quatro Stick (also known as  510e)
> The product is a small USB stick, able to receive Analog TV, DVB-T TV,
> Analog Radio and also DVB-C TV (That is, cable TV).
>
> The product is running under windows (even if I'm not so impressed by the
> analog TV reception, but this is another story).
>
> Under Linux (I'm using a Mandriva 2009 spring distro, with a 2.6.29-6
> kernel), the system says nothing about the stick.
>
> More exactly : the stick is recognized via lsusb, but nothing happend whem I
> plug the device (I don't know if the system should ask for a firmware file,
> but there is no new device in /dev after plugging the device).
>
> I just compile the current version of v4l-dvb, as explained on the Wiki,
> (had some trouble to remove the kernel's drivers witch are gziped), but a
> grep in em28xx-card.c let me think that my device is not supported. The VID
> PID are 2304:0242
>
> I think that the EMPIA chipset is an em2885 chip, and I didn't find any
> information about this chip, too.
>
> Here are the other informations that I was able to gatter :
> When I plug the device, I got theses messages in /usr/adm/messages :
> -------------------------
> Oct 16 23:27:31 p4c2400 klogd: usb 5-6: new high speed USB device using
> ehci_hcd and address 75
> Oct 16 23:27:31 p4c2400 klogd: usb 5-6: New USB device found, idVendor=2304,
> idProduct=0242
> Oct 16 23:27:31 p4c2400 klogd: usb 5-6: New USB device strings: Mfr=1,
> Product=2, SerialNumber=3
> Oct 16 23:27:31 p4c2400 klogd: usb 5-6: Product: PCTV 510e
> Oct 16 23:27:31 p4c2400 klogd: usb 5-6: Manufacturer: Pinnacle Systems
> Oct 16 23:27:31 p4c2400 klogd: usb 5-6: SerialNumber: 123456789012
> Oct 16 23:27:31 p4c2400 klogd: usb 5-6: configuration #1 chosen from 1
> choice
> Oct 16 23:27:31 p4c2400 pulseaudio[2723]: alsa-sink.c: ALSA woke us up to
> write new data to the device, but there was actually nothing to write!
> Oct 16 23:27:31 p4c2400 pulseaudio[2723]: alsa-sink.c: Most likely this is a
> bug in the ALSA driver 'snd_hda_intel'. Please report this issue to the ALSA
> developers.
> Oct 16 23:27:31 p4c2400 pulseaudio[2723]: alsa-sink.c: We were woken up with
> POLLOUT set -- however a subsequent snd_pcm_avail() returned 0 or another
> value < min_avail.
> --------------------------------
>
> i can manually load em28xx, but there's no device creation at this moment.
>
> Any ideas ? Any more tests I can do ?
>
> Thanks,
> Pascal

Hello Pascal,

The em2885 isn't the problem - all of the devices I have seen that
have the em2885 also have the drx-k demodulator chip, which is
completely unsupported.

If you want to open it up and find out what other chips it contains,
we can see if it can be supported.  If it uses the Micronas drx-k,
then you are out of luck.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
