Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from kfpc.de ([91.194.85.127] ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@mockies.de>) id 1JLyEQ-00016G-TW
	for linux-dvb@linuxtv.org; Mon, 04 Feb 2008 11:07:18 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by kfpc.de (Postfix) with ESMTP id EC4102A9
	for <linux-dvb@linuxtv.org>; Mon,  4 Feb 2008 11:06:09 +0100 (CET)
Received: from kfpc.de ([127.0.0.1])
	by localhost (server167147 [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 28753-04 for <linux-dvb@linuxtv.org>;
	Mon, 4 Feb 2008 11:06:05 +0100 (CET)
Received: from localhost (dslb-088-068-124-070.pools.arcor-ip.net
	[88.68.124.70]) by kfpc.de (Postfix) with ESMTP id 270AB28A
	for <linux-dvb@linuxtv.org>; Mon,  4 Feb 2008 11:06:05 +0100 (CET)
From: Christoph Mockenhaupt <linux-dvb@mockies.de>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 4 Feb 2008 11:05:51 +0100
Message-Id: <200802041105.53095.linux-dvb@mockies.de>
Subject: [linux-dvb] Terratec Cinergy DT XS Diversity remote
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi list,

I have problems with the remote control of a Terratec DT XS Diversity. 
Video works fine, though.

I had a look at the code and the problem seems to be that no toggle bit is 
wrong or the whole detection of the rc query is wrong somehow (or the data 
which is sent by the device).

I'm using the modul build from the actual code from hg and kernel-2.6.22 with 
the option dvb_usb_dib0700_ir_proto=0.
This seems to be the right mode for this remote. At least the received custom 
and data bits are correct (comparing the values to the key codes that are 
used for this receiver). 

This the log output I get when dvb-usb-dib0700 is loaded with debug=8 
(stripped of the data receive request ">>> 04 00"):

Feb  4 00:11:29 [kernel] input: IR-receiver inside an USB DVB receiver 
as /class/input/input23
Feb  4 00:11:29 [kernel] dvb-usb: schedule remote query interval to 150 msecs.
Feb  4 00:11:29 [kernel] power control: 0
Feb  4 00:11:29 [kernel] dvb-usb: Terratec Cinergy DT XS Diversity 
successfully initialized and connected.
Feb  4 00:11:29 [kernel] usbcore: registered new interface driver 
dvb_usb_dib0700
Feb  4 00:11:30 [kernel] <<< 00 00 00 00
Feb  4 00:11:30 [kernel] <<< 00 00 00 00
Feb  4 00:11:30 [kernel] <<< 00 00 00 00 
Feb  4 00:11:30 [kernel] <<< 00 00 00 00 
Feb  4 00:11:30 [kernel] <<< 00 00 00 00 
Feb  4 00:11:30 [kernel] <<< 00 00 00 00 
Feb  4 00:11:31 [kernel] <<< 00 00 00 00 
Feb  4 00:11:31 [kernel] <<< 00 00 00 00 
Feb  4 00:11:31 [kernel] <<< 00 00 00 00
...
(pressing a key once)
Feb  4 00:12:27 [kernel] <<< 14 eb 14 00 
Feb  4 00:12:27 [kernel] key pressed
Feb  4 00:12:27 [kernel] key repeated
Feb  4 00:12:27 [kernel] <<< 14 eb 14 ff 
Feb  4 00:12:27 [kernel] <<< 14 eb 14 ff 
Feb  4 00:12:28 [kernel] <<< 14 eb 14 ff 
Feb  4 00:12:28 [kernel] <<< 14 eb 14 ff 
Feb  4 00:12:28 [kernel] <<< 14 eb 14 ff
Feb  4 00:12:28 [kernel] <<< 14 eb 14 ff
(pressing the same key rapidely)
Feb  4 00:12:45 [kernel] <<< 14 eb 14 ff 
Feb  4 00:12:45 [kernel] <<< 00 00 00 00 
Feb  4 00:12:45 [kernel] <<< 00 00 00 00 
Feb  4 00:12:45 [kernel] <<< 14 eb 14 00 
Feb  4 00:12:45 [kernel] <<< 14 eb 14 00 
Feb  4 00:12:45 [kernel] <<< 14 eb 14 00 
Feb  4 00:12:45 [kernel] <<< 14 eb 14 00 
Feb  4 00:12:46 [kernel] <<< 14 eb 14 00 
Feb  4 00:12:46 [kernel] <<< 14 eb 14 ff 
Feb  4 00:12:46 [kernel] <<< 14 eb 14 ff 
Feb  4 00:12:46 [kernel] <<< 14 eb 14 ff 
(pressing another key)
Feb  4 00:12:46 [kernel] <<< 13 eb 14 ff 
Feb  4 00:12:46 [kernel] <<< 00 00 00 00 
Feb  4 00:12:47 [kernel] <<< 13 eb 14 ff
Feb  4 00:12:47 [kernel] <<< 13 eb 14 ff 
Feb  4 00:12:47 [kernel] <<< 13 eb 14 ff 
Feb  4 00:12:47 [kernel] <<< 13 eb 14 ff 
Feb  4 00:12:47 [kernel] <<< 13 eb 14 ff 
Feb  4 00:12:47 [kernel] <<< 13 eb 14 ff


Definitely the toggle bit is not "key[2]" which is always 0x14.
The result is that a keypress is recognized only once.
It seems that "key[3]" is some kind of "key was pressed" indicator. 

I changed dib0700_devices.c to:
static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
{
	...
	if (key[3] == 0) {
		for (i=0;i<d->props.rc_key_map_size; i++) {
			if (keymap[i].custom == key[3-2] && keymap[i].data == key[3-3]) {
				*event = keymap[i].event;
				*state = REMOTE_KEY_PRESSED;
				//st->rc_toggle=key[3-1];
				return 0;
			}
		}
		err("Unknown remote controller key : %2X %2X",(int)key[3-2],(int)key[3-3]);
	}
	return 0;
}

Unfortunately this does not have the desired effect. The problem is that 
sometimes just "00 00 00 00" is received, sometimes the last bit _is_ toggled 
and staying at "00" or key[3] does not change to 0 at all even if a key is 
pressed.

Could this be a problem of the firmware? Currently I'm using 
dvb-usb-dib0700-1.10.fw
This seems to be the latest one available. Unfortunately the "generate 
firmware" function on Patricks webpages does not work (or at least I don't 
know which file to upload) and www.thadathil.net is down. Is there any way I 
can extract the firmware myself?
Is anybody using this receiver along with the remote successfully?
Any idea?
-- 
 Christoph


p.s.: erverything works fine under XP, so the hardware should be ok
unfortunaltely, XP is not on the same box as linux to try the firmware loaded 
with XP under linux :(


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
