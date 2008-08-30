Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stephen.hocking@gmail.com>) id 1KZHno-00038z-Ox
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 06:11:11 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1116693rvf.41
	for <linux-dvb@linuxtv.org>; Fri, 29 Aug 2008 21:11:03 -0700 (PDT)
Message-ID: <6300771b0808292111i3e460c73ob0e5f9b9883cf1de@mail.gmail.com>
Date: Sat, 30 Aug 2008 14:11:03 +1000
From: "Stephen Hocking" <stephen.hocking@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Asus U 3000 (dib0700) only tuning to UHF frequencies
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Recent updates (not sure how long ago, but I suspect a couple of
months) have broken the U3000's ability to tune to VHF frequencies. I
see messages like this :

shocking@pilgrim:~$ dmesg | grep -i dvb
[  322.174042] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner'
in cold state, will try to load a firmware
[  322.184665] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
[  322.892190] dvb-usb: found a 'ASUS My Cinema U3000 Mini DVBT Tuner'
in warm state.
[  322.892328] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[  322.894108] DVB: registering new adapter (ASUS My Cinema U3000 Mini
DVBT Tuner)
[  323.151985] DVB: registering frontend 0 (DiBcom 7000PC)...
[  323.420811] dvb-usb: ASUS My Cinema U3000 Mini DVBT Tuner
successfully initialized and connected.
[  323.421763] usbcore: registered new interface driver dvb_usb_dib0700
[  405.279877] DVB: frontend 0 frequency 205625000 out of range
(470000000..860000000)
[  719.878759] DVB: frontend 0 frequency 205625000 out of range
(470000000..860000000)

Any ideas?


    Stephen

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
