Return-path: <mchehab@pedra>
Received: from blu0-omc2-s25.blu0.hotmail.com ([65.55.111.100]:4136 "EHLO
	blu0-omc2-s25.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863Ab1BIO1d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Feb 2011 09:27:33 -0500
Message-ID: <BLU0-SMTP189BC146CA0C06A78D05845D8ED0@phx.gbl>
From: Tuxoholic <tuxoholic@hotmail.de>
To: linux-media@vger.kernel.org
Subject: dibusb device with lock problems
Date: Wed, 9 Feb 2011 15:21:16 +0100
CC: patrick.boettcher@desy.de, pb@linuxtv.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi list,

Hello Patrick,

About 22 months ago a patch was introduced in the dibusb tree of v4l to avoid 
inappropriate/dangerous access to the device eeprom (r/w mixup) - see: [1] at 
the -EOF-

This patch caused lock problems with the Twinhan Hama USB 1 series [2]. 
Patrick was able to track it down to inappropriate calls in dibusb_i2c_xfer 
(read-without-write-i2caccess). A second patch [3] was released then, fixing 
the locking problems.

Apparently I still do have problems to lock with my dibusb device: I 
successfully lock 1 out of 5 times to a channel.

I use v4l-dvb rev 15160, both patches to dibusb-common.c are present. With a 
small kernel printkey I was able to make sure the eeprom protection is 
executed once, when I attach the device. While tuning, the xfer master 
function stays in the first if condition for most of the time, switching to 
the second condition while retuning or when tuning stops:

Here's the concerned code snippet from dibusb-common.c, note the printkeys:

===snip===


/*
 * I2C master xfer function
 */
static int dibusb_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msg[],int 
num)
{
	struct dvb_usb_device *d = i2c_get_adapdata(adap);
	int i;

	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
		return -EAGAIN;

	for (i = 0; i < num; i++) {
		/* write/read request */
		if (i+1 < num && (msg[i].flags & I2C_M_RD) == 0
					  && (msg[i+1].flags & I2C_M_RD)) {
		  		printk(KERN_ERR "----- hello I2C access in cond1 ----\n");
			if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,
						msg[i+1].buf,msg[i+1].len) < 0)
				break;
			i++;
		} else if ((msg[i].flags & I2C_M_RD) == 0) {
		  		printk(KERN_ERR "----- hello I2C access in cond2 ----\n");
		if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,NULL,0) < 0)
				break;
		} else if (msg[i].addr != 0x50) {
		 printk(KERN_ERR "----- hello I2C doing the eeprom protection----\n");
		  /* 0x50 is the address of the eeprom - we need to protect it
			 * from dibusb's bad i2c implementation: reads without
			 * writing the offset before are forbidden */
			if (dibusb_i2c_msg(d, msg[i].addr, NULL, 0, msg[i].buf, 
msg[i].len) < 0)
				break;
		}
	}

	mutex_unlock(&d->i2c_mutex);
	return i;
}


===snap===


dmesg on device plugin-in:

dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T 
device' in cold state, will try to load a firmware                                               
usb 2-4: firmware: requesting dvb-usb-dibusb-5.0.0.11.fw                                                                                                                       
dvb-usb: downloading firmware from file 'dvb-usb-dibusb-5.0.0.11.fw'                                                                                                           
usbcore: registered new interface driver dvb_usb_dibusb_mb                                                                                                                     
usb 2-4: USB disconnect, address 3                                                                                                                                             
dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
usb 2-4: new full speed USB device using ohci_hcd and address 4
usb 2-4: configuration #1 chosen from 1 choice
dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T 
device' in warm state.
dvb-usb: will use the device's hardware PID filter (table count: 16).
DVB: registering new adapter (TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA 
USB1.1 DVB-T device)
----- hello I2C access in cond1 ----
----- hello I2C access in cond1 ----
DVB: registering adapter 0 frontend 0 (DiBcom 3000M-B DVB-T)...
----- hello I2C access in cond2 ----
----- hello I2C access in cond1 ----
----- hello I2C access in cond2 ----
dibusb: This device has the Thomson Cable onboard. Which is default.
----- hello I2C access in cond2 ----
----- hello I2C doing the eeprom protection ----
----- hello I2C access in cond2 ----
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device 
successfully initialized and connected.


ls -la /dev/dvb/adapter0/

drwxr-xr-x  2 root root     120 2011-02-09 14:07 .
drwxr-xr-x  3 root root      60 2011-02-09 14:07 ..
crw-rw----+ 1 root video 212, 0 2011-02-09 14:07 demux0
crw-rw----+ 1 root video 212, 1 2011-02-09 14:07 dvr0
crw-rw----+ 1 root video 212, 3 2011-02-09 14:07 frontend0
crw-rw----+ 1 root video 212, 2 2011-02-09 14:07 net0


tuning with tzap -t 10 -c channels.conf channelname:


tune to [TSI1]
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/usr/share/dvb/channels.conf.dvbt'
tuning to 690000000 Hz
video pid 0x00a2, audio pid 0x0058
status 00 | signal a6f1 | snr 0027 | ber 001fffff | unc 0000ffff | 
status 00 | signal ffff | snr 002d | ber 001fffff | unc 0000ffff | 
status 00 | signal f4dd | snr 0026 | ber 0002e2f0 | unc 00000019 | 
status 00 | signal f4dd | snr 0024 | ber 0002e370 | unc 00000000 | 
status 00 | signal ffff | snr 0029 | ber 00031e7c | unc 00000000 | 
status 00 | signal f4dd | snr 002c | ber 00031e7c | unc 00000000 | 
status 00 | signal f4dd | snr 0021 | ber 000360f8 | unc 00000001 | 
status 00 | signal f4dd | snr 0028 | ber 0003c120 | unc 00000000 | 
status 00 | signal ffff | snr 0029 | ber 0003c120 | unc 00000000 | 
status 00 | signal ffff | snr 001f | ber 00044144 | unc 00000000 | 
status 00 | signal f4dd | snr 002a | ber 00044438 | unc 00000000 | 
tune to [SF zwei]
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/usr/share/dvb/channels.conf.dvbt'
tuning to 690000000 Hz
video pid 0x00a3, audio pid 0x005c
status 00 | signal de98 | snr 002c | ber 001fffff | unc 0000ffff | 
status 00 | signal f4dd | snr 002d | ber 001fffff | unc 0000ffff | 
status 00 | signal f4dd | snr 001b | ber 0003e590 | unc 00000012 | 
status 00 | signal f4dd | snr 0028 | ber 0003c250 | unc 00000000 | 
status 00 | signal f4dd | snr 002e | ber 00037f28 | unc 00000000 | 
status 00 | signal f4dd | snr 001b | ber 00037f28 | unc 00000000 | 
status 00 | signal f4dd | snr 0024 | ber 0002cb2c | unc 00000000 | 
status 00 | signal f4dd | snr 002b | ber 0002e0f8 | unc 00000000 | 
status 00 | signal ffff | snr 002c | ber 0002e0f8 | unc 00000000 | 
status 00 | signal ffff | snr 0033 | ber 00029654 | unc 00000000 | 
status 00 | signal f4dd | snr 001c | ber 000284d4 | unc 00000000 | 
tune to [SF 1]
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/usr/share/dvb/channels.conf.dvbt'
tuning to 690000000 Hz
video pid 0x00a0, audio pid 0x0050
status 00 | signal a6f1 | snr 002f | ber 001fffff | unc 0000ffff | 
status 00 | signal f4dd | snr 0037 | ber 001fffff | unc 0000ffff | 
status 00 | signal f4dd | snr 0018 | ber 0001f614 | unc 0000001d | 
status 00 | signal f4dd | snr 002e | ber 0001dc94 | unc 00000000 | 
status 00 | signal f4dd | snr 002d | ber 00031c94 | unc 00000000 | 
status 00 | signal f4dd | snr 0016 | ber 00031c94 | unc 00000000 | 
status 00 | signal f4dd | snr 002c | ber 000306e4 | unc 00000000 | 
status 00 | signal f4dd | snr 002c | ber 0002c7d8 | unc 00000000 | 
status 00 | signal f4dd | snr 0013 | ber 0002c7d8 | unc 00000000 | 
status 00 | signal f4dd | snr 002d | ber 0002da20 | unc 00000000 | 
status 00 | signal f4dd | snr 002e | ber 00024c58 | unc 00000000 | 
tune to [SF info]
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/usr/share/dvb/channels.conf.dvbt'
tuning to 690000000 Hz
video pid 0x00a7, audio pid 0x0066
status 1a | signal a6f1 | snr 002c | ber 001fffff | unc 0000ffff | FE_HAS_LOCK
status 1b | signal ffff | snr 002d | ber 001fffff | unc 0000ffff | FE_HAS_LOCK
status 1b | signal f4dd | snr 002c | ber 0002912c | unc 0000002a | FE_HAS_LOCK
status 1b | signal f4dd | snr 0027 | ber 00025acc | unc 00000000 | FE_HAS_LOCK
status 1b | signal f4dd | snr 0017 | ber 000263b8 | unc 00000000 | FE_HAS_LOCK
status 1b | signal f4dd | snr 0013 | ber 000263b8 | unc 00000000 | FE_HAS_LOCK
status 1b | signal f4dd | snr 002f | ber 0002eedc | unc 00000000 | FE_HAS_LOCK
status 1b | signal f4dd | snr 002d | ber 00033ad0 | unc 00000000 | FE_HAS_LOCK
status 1b | signal f4dd | snr 002c | ber 000358d4 | unc 00000000 | FE_HAS_LOCK
status 1b | signal f4dd | snr 002a | ber 000358d4 | unc 00000000 | FE_HAS_LOCK
status 1b | signal f4dd | snr 0029 | ber 0003718c | unc 00000000 | FE_HAS_LOCK
tune to [SF zwei]
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/usr/share/dvb/channels.conf.dvbt'
tuning to 690000000 Hz
video pid 0x00a3, audio pid 0x005c
status 00 | signal c856 | snr 002d | ber 001fffff | unc 0000ffff | 
status 00 | signal ffff | snr 002e | ber 001fffff | unc 0000ffff | 
status 00 | signal f4dd | snr 0029 | ber 0003492c | unc 0000001d | 
status 00 | signal f4dd | snr 001a | ber 000381c4 | unc 00000000 | 
status 00 | signal f4dd | snr 0029 | ber 000369d0 | unc 00000000 | 
status 00 | signal f4dd | snr 002c | ber 000369d0 | unc 00000000 | 
status 00 | signal ffff | snr 0017 | ber 0003d168 | unc 00000000 | 
status 00 | signal f4dd | snr 0021 | ber 0004ac10 | unc 00000000 | 
status 00 | signal f4dd | snr 002c | ber 0004ac10 | unc 00000000 | 
status 00 | signal f4dd | snr 0013 | ber 000697b4 | unc 0000000a | 
status 00 | signal ffff | snr 0017 | ber 000752f8 | unc 00000007 | 


@Patrick: Any idea what could be responsible for the unreliable locking?

The signal quality is not the best on my successful lock - I can get rid of 
BER completely and improve the signal level to ffff (maximum) when I place the 
device somewhere with better reception. So signal quality is not responsible 
for the locking problem.


Regards, Tuxoholic

[1] http://linuxtv.org/hg/v4l-dvb/rev/671d1acc757c
[2] http://www.spinics.net/lists/linux-media/msg12532.html
[3] http://linuxtv.org/hg/v4l-dvb/rev/b9f55b663aa4
