Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBR0SZOs009504
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 19:28:35 -0500
Received: from ws6-6.us4.outblaze.com (ws6-6.us4.outblaze.com [205.158.62.215])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBR0SVOQ014110
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 19:28:32 -0500
Message-ID: <495576AB.7020800@bigpond.net.au>
Date: Sat, 27 Dec 2008 11:28:27 +1100
From: Trevor Campbell <tca42186@bigpond.net.au>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <495564E3.4070702@bigpond.net.au>
In-Reply-To: <495564E3.4070702@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: em28xx: new board id [1b80:e302]
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

The model number is KB401-1W

Trevor Campbell wrote:
> Hi,
>
> I have a Kiaser Baas Video to DVD maker.  It is a USB analog capture 
> device.  It doesn't sem to have an actual model number.
>
> idVendor=1b80, idProduct=e302
>
> Tested with
> # uname -r
> 2.6.27.9-1mdvsmp
> # modprobe em28xx
> # modprobe em28xx-dvb
> # modprobe em28xx-alsa
>
> # lsmod | grep em28
> em28xx_alsa            11784  0
> em28xx_dvb             11012  0
> dvb_core               77312  1 em28xx_dvb
> em28xx                 63400  2 em28xx_alsa,em28xx_dvb
> videodev               35840  1 em28xx
> compat_ioctl32          5120  1 em28xx
> videobuf_vmalloc       10244  1 em28xx
> videobuf_core          19844  2 em28xx,videobuf_vmalloc
> ir_common              39044  1 em28xx
> tveeprom               15876  1 em28xx
> snd_pcm                72324  3 em28xx_alsa,snd_hda_intel,snd_usb_audio
> i2c_core               24212  3 em28xx,tveeprom,i2c_i801
> snd                    52644  10 
> em28xx_alsa,snd_hda_intel,snd_usb_audio,snd_pcm,snd_timer,snd_rawmidi,snd_seq_device,snd_hwdep 
>
> usbcore               138096  11 
> em28xx_alsa,em28xx_dvb,em28xx,snd_usb_audio,btusb,snd_usb_lib,usbhid,uhci_hcd,ohci_hcd,ehci_hcd 
>
>
>
> lsusb output is attached:
>
> Relevant dmesg output seems to be:
> usb 1-1: new high speed USB device using ehci_hcd and address 11
> usb 1-1: configuration #1 chosen from 1 choice
> usb 1-1: New USB device found, idVendor=1b80, idProduct=e302
> usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> usb 1-1: Product: USB 2861 Device
> Linux video capture interface: v2.00
> em28xx v4l2 driver version 0.1.0 loaded
> usbcore: registered new interface driver em28xx
> Em28xx: Initialized (Em28xx dvb Extension) extension
> Em28xx: Initialized (Em28xx Audio Extension) extension
>
> Nothing worked.  There is no device /dev/video0 or similar that I can 
> find.
>
> Trevor
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
