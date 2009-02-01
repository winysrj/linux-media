Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp801.mail.ird.yahoo.com ([217.146.188.61]:23558 "HELO
	smtp801.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750914AbZBAMWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 07:22:13 -0500
Subject: LinuxTv issue with Hauppauge WinTV-NOVA-TD-Stick - very near (but
	not quite ) working]
From: Colin Thomas <ColinThomas@olneybucks.freeserve.co.uk>
Reply-To: ColinThomas@dunelm.org.uk
To: linux-media@vger.kernel.org
Cc: ColinThomas@dunelm.org.uk
Content-Type: text/plain
Date: Sun, 01 Feb 2009 12:19:24 +0000
Message-Id: <1233490764.3355.25.camel@gallifrey>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have been following the good instructions for getting the above work
with my fedora 9 64bit machine from :

        http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-TD-Stick#Firmware

It is very nearly working, and I seem to have a bug which is manifesting
itself in 2 ways.

1. If I try :
        scandvb /usr/share/doc/dvb-apps-1.1.1/channels.conf-dvbt-sandy_heath
  
I get the following ERROR which I can not locate on the web:

        scanning /usr/share/doc/dvb-apps-1.1.1/channels.conf-dvbt-sandy_heath
        using '/dev/dvb/adapter0/frontend0' and
        '/dev/dvb/adapter0/demux0'
        ERROR: cannot
        parse'BBC-Choice:641833334:INVERSION_OFF:BANDWIDTH_8_MHZ:FEC_2_3:FEC_NONE:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:620:621
        '
2. When I enter kaffeine, I can scan the dvb device and all of the
channels appear in the menu. But I can not get any to display (audio or
video) , when selected.

If I run Kaffeine from the command line, I get:

        kaffeine
        /dev/dvb/adapter0/frontend0 : opened ( DiBcom 7000PC )
        /dev/dvb/adapter1/frontend0 : opened ( DiBcom 7000PC )
        0 EPG plugins loaded for device 0:0.
        0 EPG plugins loaded for device 1:0.
        Loaded epg data : 0 events (0 msecs)

The when I select a channel from the kaffeine menu I get on the command
line

        Tuning to: BBC ONE / autocount: 0
        Using DVB device 0:0 "DiBcom 7000PC"
        tuning DVB-T to 642000000 Hz
        inv:2 bw:3 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
        ...............
        
        Not able to lock to the signal on the given frequency
        Frontend closed
        Tuning delay: 2688 ms
The dvb-app have been installed, along with the firmaware and the
modprobe.d/options file have been created with the LNA option as
required.

If I run
        dmesg | grep dvb
I am getting
        dvb-usb: found a 'Hauppauge Nova-TD Stick/Elgato Eye-TV
        Diversity' in warm state.
        dvb-usb: will pass the complete MPEG2 transport stream to the
        software demuxer.
        dvb-usb: will pass the complete MPEG2 transport stream to the
        software demuxer.
        dvb-usb: Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity
        successfully initialized and connected.
        usbcore: registered new interface driver dvb_usb_dib0700

I amn running the NOVA device with an external aerial cable: with good
signal and S/N ratios, so am not using their mini aerial

Any thoughts to the missing piece of the jigsaw would be most welcome.

Best regards

Colin Thomas



