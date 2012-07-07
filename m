Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54014 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2GGAAf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 20:00:35 -0400
Message-ID: <4FF77C1B.50406@iki.fi>
Date: Sat, 07 Jul 2012 03:00:27 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marx <acc.for.news@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: pctv452e
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl> <4FF5A350.9070509@iki.fi> <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl> <4FF6B121.6010105@iki.fi> <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl> <835kc9-7p4.ln1@wuwek.kopernik.gliwice.pl>
In-Reply-To: <835kc9-7p4.ln1@wuwek.kopernik.gliwice.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2012 01:23 AM, Marx wrote:
> Driver doesn't work good.
> I've took out the second card, so there is only pctv452e connected.
> It worked the same way as usually.
> At first driver was playing some SD channels (encrypted and FTA - no
> matter), it even played one HD channel for the first time ever, but
> after it it refused to play any more channels. I've restarted computer,
> but it didn't help.

Sounds bad. It should be always enough just remove device, boot and plug 
device back.

> Jul  6 18:22:42 wuwek kernel: [   73.801143] I2C error -121; AA AE  CC
> 00 01 -> 55 AE  CC 00 00.

>
>
> HD channels desire better signal, but i'm sure signal is ok because it's
> twin setup and on second port I have traditional tuner which works ok
> with all channels.
>
> Original problem - it's rather long story. To say it short: I have 4 DVB
> tuners and none of them works reliable. I'm able to make each of them
> recognized, scan channels etc. To concentrate on pctv452e: it works from
> the beginning the same way as I've written above. It outputs endlessly
> i2c errors, usually allows to switch 4-5 times channels and then it
> stops working. What is strange - scan works, szap2 works on some
> channels, on others doesn't work.

Those I2C errors coming from the bug I explained earlier. It could be 
also reason of all problems.

> Let's get for example FTA channel Mango 24.
> Mango 24;TVN:11393:v:S13.0E:27500:517=2:700=pol@4:581:0:4316:318:1000:0
>
> wuwek:~# szap -n 51 -r
> reading channels from file '/root/.szap/channels.conf'
> zapping to 51 'Mango 24;TVN':
> sat 0, frequency = 11393 MHz V, symbolrate 27500000, vpid = 0x0205, apid
> = 0x02bc sid = 0x0245
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 1f | signal 01c6 | snr 0095 | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK
> status 1f | signal 01c6 | snr 0094 | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK
> status 1f | signal 01c6 | snr 0095 | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK
> status 1f | signal 01c6 | snr 0094 | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK

Seems to work fine.

> but it doesn't now play in VDR.

You can use it only from application at the time. It is used by szap so 
vdr could not use it.

> Unplug and plug again USB cable:
> Jul  7 00:05:53 wuwek kernel: [20664.576589] pctv452e_power_ctrl: 0
> Jul  7 00:06:08 wuwek kernel: [20679.752198] usb 1-4: USB disconnect,
> device number 2
> Jul  7 00:06:08 wuwek kernel: [20679.752728] usb 1-4: dvb_usbv2:
> usb_bulk_msg() failed=-19
> Jul  7 00:06:08 wuwek kernel: [20679.752779] I2C error -19; AA E6  10 04
> 00 -> AA E6  10 04 00.
> Jul  7 00:06:08 wuwek kernel: [20679.752876] usb 1-4: dvb_usbv2:
> usb_bulk_msg() failed=-19
> Jul  7 00:06:08 wuwek kernel: [20679.752909] I2C error -19; AA E7  D0 03
> 00 -> AA E7  D0 03 00.

Nothing special, device is removed and ongoing control commands fails 
because no device.

> Device isn't recognized. Again the same:
>
> Jul  7 00:09:29 wuwek kernel: [20880.538582] INFO: task khubd:83 blocked
> for more than 120 seconds.
> Jul  7 00:09:29 wuwek kernel: [20880.538624] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jul  7 00:09:29 wuwek kernel: [20880.538669] khubd           D f72fe064
>      0    83      2 0x00000000
> Jul  7 00:09:29 wuwek kernel: [20880.538683]  f5bf4180 00000046 00000000
> f72fe064 c1115e10 f6e13208 c14989c0 c14989c0
> Jul  7 00:09:29 wuwek kernel: [20880.538704]  f6d774c0 f71b1600 f6d774c0
> f71b1608 f6d774c0 00000282 f6cbe1e0 f71b1600
> Jul  7 00:09:29 wuwek kernel: [20880.538723]  f6cbe1e0 f6d77540 00000246
> c12d22a6 00000246 00000246 c104408a 00000002
> Jul  7 00:09:29 wuwek kernel: [20880.538742] Call Trace:
> Jul  7 00:09:29 wuwek kernel: [20880.538763]  [<c1115e10>] ?
> remove_dir+0x20/0x25
> Jul  7 00:09:29 wuwek kernel: [20880.538780]  [<c12d22a6>] ?
> _raw_spin_lock_irqsave+0x11/0x30
> Jul  7 00:09:29 wuwek kernel: [20880.538797]  [<c104408a>] ?
> prepare_to_wait+0x57/0x5f
> Jul  7 00:09:29 wuwek kernel: [20880.538880]  [<f8542751>] ?
> dvb_dmxdev_release+0x5a/0xf0 [dvb_core]
> Jul  7 00:09:29 wuwek kernel: [20880.538895]  [<c1043f3e>] ?
> bit_waitqueue+0x47/0x47
> Jul  7 00:09:29 wuwek kernel: [20880.538926]  [<f84b46c1>] ?
> dvb_usb_adapter_dvb_exit+0x31/0x48 [dvb_usbv2]
> Jul  7 00:09:29 wuwek kernel: [20880.538956]  [<f84b5055>] ?
> dvb_usbv2_disconnect+0xc9/0x128 [dvb_usbv2]
> Jul  7 00:09:29 wuwek kernel: [20880.539025]  [<c1206845>] ?
> rpm_suspend+0x3ed/0x3ed
> Jul  7 00:09:29 wuwek kernel: [20880.539038]  [<c120721b>] ?
> pm_schedule_suspend+0x8e/0x8e
> Jul  7 00:09:29 wuwek kernel: [20880.539113]  [<f82564da>] ?
> usb_unbind_interface+0x46/0x106 [usbcore]
> Jul  7 00:09:29 wuwek kernel: [20880.539147]  [<c120070f>] ?
> __device_release_driver+0x60/0x97
> Jul  7 00:09:29 wuwek kernel: [20880.539160]  [<c120075b>] ?
> device_release_driver+0x15/0x1e
> Jul  7 00:09:29 wuwek kernel: [20880.539173]  [<c120020b>] ?
> bus_remove_device+0xa1/0xb0
> Jul  7 00:09:29 wuwek kernel: [20880.539185]  [<c11feb9a>] ?
> device_del+0xe6/0x130
> Jul  7 00:09:29 wuwek kernel: [20880.539236]  [<f8254d02>] ?
> usb_disable_device+0x56/0x13a [usbcore]
> Jul  7 00:09:29 wuwek kernel: [20880.539283]  [<f824f99d>] ?
> usb_disconnect+0x61/0xb2 [usbcore]
> Jul  7 00:09:29 wuwek kernel: [20880.539331]  [<f8250e2e>] ?
> hub_thread+0x4bd/0xc72 [usbcore]
> Jul  7 00:09:29 wuwek kernel: [20880.539346]  [<c1043f3e>] ?
> bit_waitqueue+0x47/0x47
> Jul  7 00:09:29 wuwek kernel: [20880.539393]  [<f8250971>] ?
> usb_remote_wakeup+0x25/0x25 [usbcore]
> Jul  7 00:09:29 wuwek kernel: [20880.539406]  [<c1043cb9>] ?
> kthread+0x69/0x6e
> Jul  7 00:09:29 wuwek kernel: [20880.539420]  [<c1043c50>] ?
> kthread_worker_fn+0x106/0x106
> Jul  7 00:09:29 wuwek kernel: [20880.539433]  [<c12d70fe>] ?
> kernel_thread_helper+0x6/0x10

This should not happen. I suspect you removed device while it was in use?

> Reboot doesn't help either. While device registered correctly, it still
> doesnt work in VDR. I was trying to disconnect USB and power from
> device, and then reconnect - didn't help.
> So while it was working at the morning for a while, I didn't change
> anything important and now it doesn't work at all.
> I suspect that if I disconnect device for a longer time, reboot, it will
> work for a few minutes as usually.
>
> I don't know what can i do next.

Get the rid of vdr and use only szap/vlc/mplayer only to see if it works.

And install latest patch from here:
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/pctv452e

it just ignores the I2C error coming from wrong I2C address used which 
could have some effect for STB6100 driver.


regards
Antti

-- 
http://palosaari.fi/


