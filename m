Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1NG4MF-000299-3Q
	for linux-dvb@linuxtv.org; Thu, 03 Dec 2009 06:36:04 +0100
Received: by ewy19 with SMTP id 19so1106862ewy.1
	for <linux-dvb@linuxtv.org>; Wed, 02 Dec 2009 21:35:29 -0800 (PST)
Date: Thu, 3 Dec 2009 06:30:09 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Luca Olivetti <luca@ventoso.org>
In-Reply-To: <4B14CC1E.7030102@ventoso.org>
Message-ID: <alpine.DEB.2.01.0912030540570.4548@ybpnyubfg.ybpnyqbznva>
References: <4B14CC1E.7030102@ventoso.org>
MIME-Version: 1.0
Cc: Linux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] siano firmware and behaviour after resuming power
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Sorry for not composing this reply sooner...

On Tue, 1 Dec 2009, Luca Olivetti wrote:

> [Since linux-media silently discards my email --leaving through the stray
> viagra message anyway, yay-- I'm trying the old list and I hope that someone

And as linux-media hijacks the Reply-To: header so that my mailer
won't send you a copy without uncomfortable gymnastics, I have to
ignore it in order to make sure that you, or anyone else, actually
gets a reply even if you've promptly `UNSUSCIRBE'd upon receiving
that chastising bounce.

Similarly, as I'm not subscribed to linux-media, please include
me in any replies that you want me to see immediately, lest I
overlook them in the flood of developer mails there -- though
since you can't post there, you'll probably have to keep your
replies here.  So this is meant for anyone who pipes up but
does what is wanted by moving the conversation elsewhere.




> The dealextreme lottery gave me a siano sms1xxx based device, usb id
> 187f:0201.
> In the latest mercurial repository, this device requires the firmware
> dvb_nova_12mhz_b0.inp but it's nowhere to be found.

I have the following in a source directory:

ls -lart  /home/beer/src/siano/firmware/
total 428
-rw-rw-r-- 1 beer besoffen 84164 2008-12-31 16:22 isdbt_nova_12mhz_b0.inp
-rw-rw-r-- 1 beer besoffen 71428 2008-12-31 16:22 tdmb_nova_12mhz_b0.inp
-rw-rw-r-- 1 beer besoffen 93624 2008-12-31 16:22 dvb_nova_12mhz_b0.inp
-rw-rw-r-- 1 beer besoffen 38428 2008-12-31 16:26 tdmb_stellar_usb_12mhz_downld.inp
-rw-rw-r-- 1 beer besoffen 38720 2008-12-31 16:26 tdmb_stellar_usb_12mhz_eeprom_a2.brn
-rw-rw-r-- 1 beer besoffen 40348 2008-12-31 16:28 dvbh_stellar_usb_12mhz_downld.inp
-rw-rw-r-- 1 beer besoffen 39676 2008-12-31 16:28 dvbt_stellar_usb_12mhz_downld.inp

This is from a URL provided by Siano in the archives of this list
which can probably be found by searching for keywords like DAB
or their host library.

Interestingly, in this older kernel which I use, I have the
firmware to be loaded

-r-xr-xr-x  1 beer drunkards  40096 2007-05-17 14:38 tdmb_stellar_usb.inp

which does not correspond in size to the above, so I can't
remember how I got it without finding an older system disk
from which I copied this -- on which the other non-DAB/DMB
mode firmwares would be found for size/checksum comparisons.
Presumably this was from the accompanying CD-ROM, wherever
that might be these days -- wait, I should be able to dig a
second one from the packaging if I can find that, should you
be particularly interested.


In my source code at hand I find
        { USB_DEVICE(0x187f, 0x0201),
                .driver_info = SMS1XXX_BOARD_SIANO_NOVA_B },
for your device (capable of more than mine) and the corresponding
firmware named as
        [SMS1XXX_BOARD_SIANO_NOVA_B] = {
                .name   = "Siano Nova B Digital Receiver",
                .type   = SMS_NOVA_B0,
                .fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-b-dvbt-01.fw",
        },


Within another file I see some alternative names for the
firmwares for my `stellar' device; in your case of a `nova'
product a table can be found in the source file smscoreapi.c:

static char *smscore_fw_lkup[][SMS_NUM_OF_DEVICE_TYPES] = {
        /*Stellar               NOVA A0         Nova B0         VEGA*/
        /*DVBT*/
        {"none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none"},
        /*DVBH*/
        {"none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none"},
        /*TDMB*/
        {"none", "tdmb_nova_12mhz.inp", "none", "none"},
        /*DABIP*/
        {"none", "none", "none", "none"},
        /*BDA*/
        {"none", "dvb_nova_12mhz.inp", "dvb_nova_12mhz_b0.inp", "none"},
        /*ISDBT*/
        {"none", "isdbt_nova_12mhz.inp", "dvb_nova_12mhz.inp", "none"},
        /*ISDBTBDA*/
        {"none", "isdbt_nova_12mhz.inp", "isdbt_nova_12mhz_b0.inp", "none"},
        /*CMMB*/
        {"none", "none", "none", "cmmb_vega_12mhz.inp"}
};


Looks like your device isn't capable of DAB/DAB+/DMB, and
I'm puzzled to see the difference in firmwares between the
ISDBT modes, but I'm unfamiliar with that operation.




> I found some forum posting suggesting to use
> http://www.steventoth.net/linux/sms1xxx/sms1xxx-hcw-55xxx-dvbt-01.fw
> (renaming it to the name required by the driver), and I did and it worked.
> Then, out of curiosity, I also tried the 03 revision
> http://www.steventoth.net/linux/sms1xxx/sms1xxx-hcw-55xxx-dvbt-03.fw and
> it also worked.
> Since these firmwares are for hauppauge devices, I wonder if using them
> will have some undesirable side-effect or there's no problem.

In looking at the sms-cards.c source file, these Hauppauge
rebrandings seem to be a change of the USB IDs, but the
same firmwares are listed as are used by the Siano-sourced
devices.

In other words, there shouldn't be a problem, and they may well
be identical.  However, to set your mind at ease, I'd have to
dig out my other copy of the firmwares to list file sizes and
md5sums in order that you can see whether they match.



> Oh, when I turn off the pc the stick is attached to (a vdr machine), it
> still supplies 5v to the usb ports, and when I turn it on again the
> stick fails. I have to unplug and replug it to make it work.

As I managed to kill off my workstation, more than once, I
see the same problem with other USB devices that get power
through other means.  I'd be inclined to believe this may be
a problem in the USB stack, where it's not issuing a proper
reset to restore the devices -- if this is possible with
power supplied.

Specifically, with one USB WLAN stick which receives external
power, I have to re-plug it if I've brought it up to load
the firmware.  The other two USB WLAN sticks, one of similar
type and one somewhat different but also similar, are the
same, though they're powered from the machine -- after a cold
boot, they work fine; after a warm reboot if they've loaded
the firmware, they fail to respond properly to the attempt
to firmware load or possibly to enumerate -- I'd have to
actually reboot again to see where.

I can't remember if the Siano USB device is the same way.
For two other USB-attached DVB devices, one of which requires
firmware loading, the other which doesn't, but both of which
have their own power supplies, there's no problem.

Another device which seems to have this problem is one external
hard drive, which I've had to power externally, and it seems
that after these reboots or crashes, it fails to get back to
a useful state without replugging and reset.  Another drive
is fine, but may be getting its power switched by a USB hub.


Those are just my observations -- as to whether this is a
more general USB stack problem, or whether each driver for
all these devices needs to be rewritten to handle this case
of a device in a warm state, I don't know as I'm unfamiliar
with the internal workings of USB or the devices.  But this
seems to be a common enough problem, particularly annoying
with my USB WLAN sticks, that it should be tackled -- either
a complete power cycle or re-plug cycle is needed after a
normal reboot, which is painful.  Particularly if done
remotely.



> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org


thanks,
barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
