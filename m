Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58667 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbZIBQqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Sep 2009 12:46:01 -0400
Received: by fxm17 with SMTP id 17so923163fxm.37
        for <linux-media@vger.kernel.org>; Wed, 02 Sep 2009 09:46:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54953.1251891572@rokamp.dk>
References: <54953.1251891572@rokamp.dk>
Date: Wed, 2 Sep 2009 18:46:01 +0200
Message-ID: <8ad9209c0909020946o9c4dc0fu2c12a326fc86a8a4@mail.gmail.com>
Subject: Re: [linux-dvb] Problems with Hauppauge Nova-T USB2
From: Patrik Hansson <patrik@wintergatan.com>
To: linux-media@vger.kernel.org, thomas@rokamp.dk
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not sure but on pci version you have to enable the builtin amp. Check
linuxtv.org for modprobe instructions. (lna activation)

2009/9/2 Thomas Rokamp <thomas@rokamp.dk>:
> (sorry if you already got this mail, I think I had sent it to the wrong list to begin with)
>
> Hi
>
> I have found my old Hauppauge Nova-T USB2 box. It's the old revision, with and USB ID 9301.
> I'm struggling to get it to work correctly under linux (Ubuntu Intrepid 2.6.27-11-server). So far all I have read and tried has been without success.
>
> I'm running the latest checked out v4l-dvb drivers (using hg).
>
> I have tested the box on the same location using windows, and "everything works fine".
>
> My setup is a bit odd though. I have TV supplied from my local cable company, yet they have decided to supply the DVB signal using DVB-T. I guess it's because most of the TV's where I live supports DVB-T only. The signal is provided through the same plu in the wall as the old analog signal, though this should not be a problem, it works in windows.
>
> I have tried various tools from dvb-apps, the output supplied further down...
>
> dmesg | grep dvb:
> (I'm quite sure the MAC address it suggest is random upon each boot, which sounds like trouble to me)
>
> dvb-usb: found a 'Hauppauge WinTV-NOVA-T usb2' in cold state, will try to load a firmware
> firmware: requesting dvb-usb-nova-t-usb2-02.fw
> dvb-usb: downloading firmware from file 'dvb-usb-nova-t-usb2-02.fw'
> usbcore: registered new interface driver dvb_usb_nova_t_usb2
> dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
> dvb-usb: found a 'Hauppauge WinTV-NOVA-T usb2' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> dvb-usb: MAC address: f5c9c8e4
> dvb-usb: schedule remote query interval to 100 msecs.
> dvb-usb: Hauppauge WinTV-NOVA-T usb2 successfully initialized and connected.
>
> Using 'scan' I have come to a channel.conf file, out of which I have added just one line to channels.conf:
> X:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:513:644:905
>
> Using the above channels.conf file as input to tzap, I get the following lines:
>
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '.tzap/channels.conf'
> tuning to 722000000 Hz
> video pid 0x0201, audio pid 0x0284
> status 1f | signal 7bd3 | snr 0000 | ber 001fffff | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 7b94 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 7b7d | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 7b77 | snr 0000 | ber 00000090 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 7b79 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 7b70 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>
> As you can see from above, the signal-to-noise ratio is, well... bad. I was hoping (according to my readings) a value much higher.
>
> Trying to record something with dvbstream:
> dvbstream -n 5 -qam 64 -gi 16 -cr 5_6 -crlp 5_6 -bw 8 -tm 2 -hy NONE -f 722000000 513 644 -o > test.mpg
> dvbstream v0.6 - (C) Dave Chapman 2001-2004
> Released under the GPL.
> Latest version available from http://www.linuxstb.org/
> Tuning to 722000000 Hz
> Using DVB card "DiBcom 3000MC/P", freq=722000000
> tuning DVB-T (in United Kingdom) to 722000000 Hz, Bandwidth: 8
> Getting frontend status
> Event: Frequency: 722000000
> Bit error rate: 2097151
> Signal strength: 31503
> SNR: 0
> UNC: 0
> FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI FE_HAS_SYNC
> dvbstream will stop after 5 seconds (0 minutes)
> Output to stdout
> Streaming 3 streams
> Caught signal 1 - closing cleanly.
>
>
> This 'test.mpg' output file, however, shows no video at all, despite it actually containing data. VLC reports 'nothing to play'.
>
>
> Any help at this point would be highly appreciated :-)
>
> Best regards,
> Thomas Rokamp
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
