Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9OINu9Q028819
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 14:23:56 -0400
Received: from smtp0.lie-comtel.li (smtp0.lie-comtel.li [217.173.238.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9OIMAX4008474
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 14:22:11 -0400
Message-ID: <49021251.8020402@kaiser-linux.li>
Date: Fri, 24 Oct 2008 20:22:09 +0200
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
References: <4900DA6B.4050902@kaiser-linux.li>
	<1224831699.1761.13.camel@localhost>
In-Reply-To: <1224831699.1761.13.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: gspca, what do I am wrong?
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

Hello Jean-Francois

Thanks for you comments. More from me inline.

Jean-Francois Moine wrote:
--- snip ---
> You may copy the /boot/config to <hg root>/vl4/ and do a make menuconfig
> (but this will not work without the kernel sources).

I did, but shouldn't it be possible to just download the the v4l-dvb 
source and compile and install without fiddling around with the 
distribution's config file?

I could compile everything just with the kernel-headers. The complete 
kernel source was not required.

Now some logs after copy the config-2.6.24-21-generic to v4l/.config and 
do a new compile and install. I rebooted after this was done:

kernel log after reboot:
thomas@LAPI01:~$ tail -f /var/log/kern.log
Oct 24 19:01:48 LAPI01 kernel: [   91.928973] NET: Registered protocol 
family 17
Oct 24 19:01:49 LAPI01 kernel: [   92.987881] wlan0: Initial auth_alg=0
Oct 24 19:01:49 LAPI01 kernel: [   92.987911] wlan0: authenticate with 
AP 00:18:9b:4d:71:06
Oct 24 19:01:49 LAPI01 kernel: [   92.990154] wlan0: RX authentication 
from 00:18:9b:4d:71:06 (alg=0 transaction=2 status=0)
Oct 24 19:01:49 LAPI01 kernel: [   92.990179] wlan0: authenticated
Oct 24 19:01:49 LAPI01 kernel: [   92.990183] wlan0: associate with AP 
00:18:9b:4d:71:06
Oct 24 19:01:49 LAPI01 kernel: [   92.992507] wlan0: RX AssocResp from 
00:18:9b:4d:71:06 (capab=0x1 status=0 aid=1)
Oct 24 19:01:49 LAPI01 kernel: [   92.992532] wlan0: associated
Oct 24 19:01:49 LAPI01 kernel: [   92.993633] ADDRCONF(NETDEV_CHANGE): 
wlan0: link becomes ready
Oct 24 19:02:05 LAPI01 kernel: [  111.931267] wlan0: no IPv6 routers present

Then check loaded modules:
thomas@LAPI01:~$ lsmod
Module                  Size  Used by
af_packet              23812  4
i915                   32512  2
drm                    82452  3 i915
rfcomm                 41744  2
l2cap                  25728  13 rfcomm
bluetooth              61156  4 rfcomm,l2cap
rfkill_input            5760  0
ppdev                  10372  0
ipv6                  267780  10
speedstep_lib           6532  0
cpufreq_powersave       2688  0
cpufreq_conservative     8712  0
cpufreq_ondemand        9740  0
cpufreq_stats           7104  0
freq_table              5536  2 cpufreq_ondemand,cpufreq_stats
cpufreq_userspace       5284  0
dock                   11280  0
sbs                    15112  0
container               5632  0
sbshc                   7680  1 sbs
iptable_filter          3840  0
ip_tables              14820  1 iptable_filter
x_tables               16132  1 ip_tables
parport_pc             36260  0
lp                     12324  0
parport                37832  3 ppdev,parport_pc,lp
joydev                 13120  0
pcmcia                 40876  0
evdev                  13056  8
arc4                    2944  2
dcdbas                  9504  0
ecb                     4480  2
blkcipher               8324  1 ecb
snd_intel8x0           35356  3
snd_ac97_codec        101028  1 snd_intel8x0
ac97_bus                3072  1 snd_ac97_codec
snd_pcm_oss            42144  0
snd_mixer_oss          17920  1 snd_pcm_oss
serio_raw               7940  0
snd_pcm                78596  3 snd_intel8x0,snd_ac97_codec,snd_pcm_oss
pcspkr                  4224  0
psmouse                40336  0
b43                   144548  0
rfkill                  8596  3 rfkill_input,b43
mac80211              165652  1 b43
cfg80211               15112  1 mac80211
led_class               6020  1 b43
input_polldev           5896  1 b43
snd_seq_dummy           4868  0
video                  19856  0
output                  4736  1 video
snd_seq_oss            35584  0
snd_seq_midi            9376  0
snd_rawmidi            25760  1 snd_seq_midi
yenta_socket           27276  1
rsrc_nonstatic         13696  1 yenta_socket
pcmcia_core            40596  3 pcmcia,yenta_socket,rsrc_nonstatic
snd_seq_midi_event      8320  2 snd_seq_oss,snd_seq_midi
snd_seq                54224  6 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              24836  2 snd_pcm,snd_seq
snd_seq_device          9612  5 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
button                  9232  0
snd                    56996  17 
snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_dummy,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
battery                14212  0
ac                      6916  0
soundcore               8800  1 snd
snd_page_alloc         11400  2 snd_intel8x0,snd_pcm
iTCO_wdt               13092  0
iTCO_vendor_support     4868  1 iTCO_wdt
shpchp                 34452  0
pci_hotplug            30880  1 shpchp
intel_agp              25492  1
agpgart                34760  3 drm,intel_agp
ext3                  136840  2
jbd                    48404  1 ext3
mbcache                 9600  1 ext3
sg                     36880  0
sd_mod                 30720  4
sr_mod                 17956  0
cdrom                  37408  1 sr_mod
pata_acpi               8320  0
b44                    28432  0
ata_piix               19588  3
ata_generic             8324  0
ssb                    34308  2 b43,b44
libata                159344  3 pata_acpi,ata_piix,ata_generic
ehci_hcd               37900  0
mii                     6400  1 b44
uhci_hcd               27024  0
scsi_mod              151436  4 sg,sd_mod,sr_mod,libata
usbcore               146412  3 ehci_hcd,uhci_hcd
thermal                16796  0
processor              37384  2 thermal
fan                     5636  0
fbcon                  42912  0
tileblit                3456  1 fbcon
font                    9472  1 fbcon
bitblit                 6784  1 fbcon
softcursor              3072  1 bitblit
fuse                   50708  3

thomas@LAPI01:~$ lsmod |grep vi
video                  19856  0
output                  4736  1 video
snd_seq_device          9612  5 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
snd                    56996  17 
snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_dummy,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device 


After I plug the cam I got the following in the kernel log:

Oct 24 19:12:59 LAPI01 kernel: [  766.468483] usb 1-1: new full speed 
USB device using uhci_hcd and address 2
Oct 24 19:12:59 LAPI01 kernel: [  766.638907] usb 1-1: configuration #1 
chosen from 1 choice
Oct 24 19:13:00 LAPI01 kernel: [  766.814457] Linux video capture 
interface: v2.00
Oct 24 19:13:00 LAPI01 kernel: [  766.839641] gspca: main v2.3.0 registered
Oct 24 19:13:00 LAPI01 kernel: [  766.858908] gspca: probing 041e:401c
Oct 24 19:13:00 LAPI01 kernel: [  767.091713] zc3xx: probe sif 0x0007
Oct 24 19:13:00 LAPI01 kernel: [  767.095711] zc3xx: probe sensor -> 0f
Oct 24 19:13:00 LAPI01 kernel: [  767.095721] zc3xx: Find Sensor PAS106
Oct 24 19:13:00 LAPI01 kernel: [  767.100806] gspca: probe ok
Oct 24 19:13:00 LAPI01 kernel: [  767.100839] usbcore: registered new 
interface driver zc3xx
Oct 24 19:13:00 LAPI01 kernel: [  767.100844] zc3xx: registered
Oct 24 19:13:00 LAPI01 kernel: [  767.189428] gspca: disagrees about 
version of symbol video_devdata
Oct 24 19:13:00 LAPI01 kernel: [  767.189444] gspca: Unknown symbol 
video_devdata
Oct 24 19:13:00 LAPI01 kernel: [  767.189906] gspca: disagrees about 
version of symbol video_unregister_device
Oct 24 19:13:00 LAPI01 kernel: [  767.189910] gspca: Unknown symbol 
video_unregister_device
Oct 24 19:13:00 LAPI01 kernel: [  767.190082] gspca: disagrees about 
version of symbol video_device_alloc
Oct 24 19:13:00 LAPI01 kernel: [  767.190085] gspca: Unknown symbol 
video_device_alloc
Oct 24 19:13:00 LAPI01 kernel: [  767.190130] gspca: disagrees about 
version of symbol video_register_device
Oct 24 19:13:00 LAPI01 kernel: [  767.190132] gspca: Unknown symbol 
video_register_device
Oct 24 19:13:00 LAPI01 kernel: [  767.190449] gspca: disagrees about 
version of symbol video_usercopy
Oct 24 19:13:00 LAPI01 kernel: [  767.190452] gspca: Unknown symbol 
video_usercopy
Oct 24 19:13:00 LAPI01 kernel: [  767.190496] gspca: disagrees about 
version of symbol video_device_release
Oct 24 19:13:00 LAPI01 kernel: [  767.190499] gspca: Unknown symbol 
video_device_release

And the loaded modules now:

thomas@LAPI01:~$ lsmod |grep vi
videodev               34304  1 gspca_main
video                  19856  0
output                  4736  1 video
snd_seq_device          9612  5 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
snd                    56996  17 
snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_dummy,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device

thomas@LAPI01:~$ lsmod |grep gs
gspca_zc3xx            48512  0
gspca_main             24448  1 gspca_zc3xx
videodev               34304  1 gspca_main
usbcore               146412  5 gspca_zc3xx,gspca_main,ehci_hcd,uhci_hcd

thomas@LAPI01:~$ lsmod |grep zc
gspca_zc3xx            48512  0
gspca_main             24448  1 gspca_zc3xx
usbcore               146412  5 gspca_zc3xx,gspca_main,ehci_hcd,uhci_hcd
thomas@LAPI01:~$

Looks like the correct modules are loaded but I still have the "Unknown 
symbol" problem.

At these times as I was contributing to the gspcaV1 project, I never had 
such kind of problems.

I have to stress this one more: It should be possible to _just_ compile 
the source downloaded from linuxtv.org!

I got some time and I would like to test the new gspca V2 v4l2 driver 
but with this issues I will get up soon :-(

I have about 20 webcams laying around which I would like to test with 
the new gspca V2 "in kernel" drive with a "stock distribution (Ubuntu)" 
kernel.

Sorry, I am a bit frustrated right now. Even I am frustrated, 
Jean-Francois, you did a great job. Hans with his v4l_lib, too :-)

Regards, Thomas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
