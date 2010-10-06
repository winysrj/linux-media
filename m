Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:49685 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab0JFTlm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Oct 2010 15:41:42 -0400
Message-ID: <4CACD0F3.6030203@iki.fi>
Date: Wed, 06 Oct 2010 22:41:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Paul Gover <pmw.gover@yahoo.co.uk>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] [bug] AF9015 message "WARNING: >>> tuning failed!!!"
References: <201010061456.19573.pmw.gover@yahoo.co.uk>
In-Reply-To: <201010061456.19573.pmw.gover@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It is QT1010 tuner driver issue. None is working for that currently or 
in near future. Feel free to fix :]

Antti

On 10/06/2010 04:56 PM, Paul Gover wrote:
> I've a cheap USB DVB key that won't work with Kaffeine.
> It identifies itself as KWorld USB DVB-T TV Stick II (VS-DVB-T 395U).
> It shows up on Kaffeine's "Configure Television" dialog,
> but scanning for channels finds nothing,
> and tuning using an old channel list gives "Sorry - no available device found"
>
> I had Kaffeine working OK with a different USB TV key.
>
> dvbscan produces "WARNING:>>>  tuning failed!!!" messages.
>
> The key works on XP using KWorld's HyperMedia Center.
> Rebooting from there to Linux with warm USB key shows it contains 4.95.0
> firmware.
> At one point, such a warm reboot enabled Kaffeine to show TV.
> That was with one of the early KDE4 Kaffeine candidates,
> and an older linux kernel (sorry, I forget which).
>
> Now using kernel modules in Linux version 2.6.34-gentoo-r6.
> Kaffeine 1.0, KDE 4.4.5.  linuxtv-dvb-apps 1.1.1.20080317
> on an ASUS EeePC 1000HE (Intel Atom processor).
>
> Diagnostic stuff
>
> lsusb -v :
>
> Bus 001 Device 023: ID 1b80:e396 Afatech
> Device Descriptor:
>    bLength                18
>    bDescriptorType         1
>    bcdUSB               2.00
>    bDeviceClass            0 (Defined at Interface level)
>    bDeviceSubClass         0
>    bDeviceProtocol         0
>    bMaxPacketSize0        64
>    idVendor           0x1b80 Afatech
>    idProduct          0xe396
>    bcdDevice            2.00
>    iManufacturer           1 Afatech
>    iProduct                2 DVB-T 2
>    iSerial                 0
>    bNumConfigurations      1
>    Configuration Descriptor:
>      bLength                 9
>      bDescriptorType         2
>      wTotalLength           46
>      bNumInterfaces          1
>      bConfigurationValue     1
>      iConfiguration          0
>      bmAttributes         0x80
>        (Bus Powered)
>      MaxPower              500mA
>      Interface Descriptor:
>        bLength                 9
>        bDescriptorType         4
>        bInterfaceNumber        0
>        bAlternateSetting       0
>        bNumEndpoints           4
>        bInterfaceClass       255 Vendor Specific Class
>        bInterfaceSubClass      0
>        bInterfaceProtocol      0
>        iInterface              0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x81  EP 1 IN
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x02  EP 2 OUT
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x84  EP 4 IN
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x85  EP 5 IN
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               0
> Device Qualifier (for other device speed):
>    bLength                10
>    bDescriptorType         6
>    bcdUSB               2.00
>    bDeviceClass            0 (Defined at Interface level)
>    bDeviceSubClass         0
>    bDeviceProtocol         0
>    bMaxPacketSize0        64
>    bNumConfigurations      1
> Device Status:     0x0000
>    (Bus Powered)
>
> lsmod :
>
> Module                  Size  Used by
> ppp_deflate             3156  0
> zlib_deflate           17980  1 ppp_deflate
> zlib_inflate           14197  1 ppp_deflate
> bsd_comp                4568  0
> ppp_async               6283  1
> crc_ccitt               1023  1 ppp_async
> ppp_generic            14958  7 ppp_deflate,bsd_comp,ppp_async
> slhc                    4431  1 ppp_generic
> sr_mod                 10825  0
> cdrom                  29800  1 sr_mod
> option                 18224  1
> usbserial              24352  4 option
> snd_seq_oss            23625  0
> snd_seq_midi_event      4280  1 snd_seq_oss
> snd_seq                39723  4 snd_seq_oss,snd_seq_midi_event
> snd_seq_device          4109  2 snd_seq_oss,snd_seq
> snd_pcm_oss            30331  0
> snd_mixer_oss          12481  1 snd_pcm_oss
> snd_hda_codec_realtek   187652  1
> qt1010                  4461  1
> snd_hda_intel          16732  2
> af9013                 17817  1
> snd_hda_codec          42659  2 snd_hda_codec_realtek,snd_hda_intel
> snd_pcm                50564  3 snd_pcm_oss,snd_hda_intel,snd_hda_codec
> dvb_usb_af9015         24963  0
> snd_timer              14785  2 snd_seq,snd_pcm
> snd                    39369  14
> snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_pcm,snd_timer
> dvb_usb                15353  1 dvb_usb_af9015
> dvb_core               72670  1 dvb_usb
> snd_page_alloc          5445  2 snd_hda_intel,snd_pcm
>
> Syslog when connecting cold device (debug level 3) :
>
> usb 1-3: new high speed USB device using ehci_hcd and address 22
> af9015_usb_probe: interface:0
> af9015_eeprom_hash: eeprom sum=37ec4ddf
> af9015_read_config: IR mode:4
> af9015_read_config: TS mode:0
> af9015_read_config: [0] xtal:2 set adc_clock:28000
> af9015_read_config: [0] IF1:36125
> af9015_read_config: [0] MT2060 IF1:5888
> af9015_read_config: [0] tuner id:134
> af9015_identify_state: reply:01
> af9015_download_firmware:
> dvb-usb: found a 'KWorld USB DVB-T TV Stick II (VS-DVB-T 395U)' in cold state,
> will try to load a firmware
> usb 1-3: firmware: requesting dvb-usb-af9015.fw
> dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> dvb-usb: found a 'KWorld USB DVB-T TV Stick II (VS-DVB-T 395U)' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (KWorld USB DVB-T TV Stick II (VS-DVB-T 395U))
> af9013: firmware version:4.95.0
> af9015_af9013_frontend_attach: init I2C
> af9015_i2c_init:
> Quantek QT1010 successfully identified.
> input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-3/input/input12
> dvb-usb: schedule remote query interval to 150 msecs.
> dvb-usb: KWorld USB DVB-T TV Stick II (VS-DVB-T 395U) successfully initialized
> and connected.
> DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
> af9015_tuner_attach:
> af9015_init:
> af9015_init_endpoint: USB speed:3
> af9015_download_ir_table:
>
> and on disconnection:
>
> usb 1-3: USB disconnect, address 22
> dvb-usb: KWorld USB DVB-T TV Stick II (VS-DVB-T 395U) successfully
> deinitialized and disconnected.
> af9015_usb_device_exit:
> af9015_i2c_exit:
> input device has been disconnected
>
> ls -l  /dev/dvb/adapter0/ :
>
> total 0
> crw-rw---- 1 root video 212, 4 Oct  6 12:43 demux0
> crw-rw---- 1 root video 212, 5 Oct  6 12:43 dvr0
> crw-rw---- 1 root video 212, 3 Oct  6 12:43 frontend0
> crw-rw---- 1 root video 212, 7 Oct  6 12:43 net0
>
> dvbscan -uvvt1 /usr/share/dvb/dvb-t/uk-Rowridge :
>
> scanning /usr/share/dvb/dvb-t/uk-Rowridge
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 489833000 0 3 9 1 0 0 0
> initial transponder 530000000 0 2 9 3 0 0 0
> initial transponder 545833000 0 2 9 3 0 0 0
> initial transponder 562167000 0 3 9 1 0 0 0
> initial transponder 513833000 0 3 9 1 0 0 0
> initial transponder 570167000 0 3 9 1 0 0 0
>>>> tune to:
> 489833000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
> WARNING:>>>  tuning failed!!!
>>>> tune to:
> 489833000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> (tuning failed)
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
>>>> tuning status == 0x03
> WARNING:>>>  tuning failed!!!
>
>   ... repeated for each frequency
>
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
>
> Thanks for any help.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
