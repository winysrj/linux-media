Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm11-vm0.bullet.mail.ird.yahoo.com ([77.238.189.218]:40063 "HELO
	nm11-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757090Ab2CTNU2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 09:20:28 -0400
References: <1329761467-14417-1-git-send-email-festevam@gmail.com> <Pine.LNX.4.64.1202201916410.2836@axis700.grange> <CAOMZO5AAeqHZFqpZYB_riSCQvCRSjQtR2EqpZvC5V3TRyzuWJQ@mail.gmail.com> <4F67E4FD.2070709@redhat.com> <Pine.LNX.4.64.1203200851300.20315@axis700.grange> <CAOMZO5CJHkb1JrAd+DYvYP-DrV6XsqO3wtoxJGe_s9sE1tQktw@mail.gmail.com> <Pine.LNX.4.64.1203201340300.21870@axis700.grange> <CAOMZO5B=0LMqi-v-KwJkvsBEqUU+Bj8TRo08i7zGSv97jnZpVQ@mail.gmail.com>
Message-ID: <1332249626.50777.YahooMailNeo@web171406.mail.ir2.yahoo.com>
Date: Tue, 20 Mar 2012 13:20:26 +0000 (GMT)
From: Sril <willy_the_cat@yahoo.com>
Reply-To: Sril <willy_the_cat@yahoo.com>
Subject: AverTV Volar HD PRO : a return case.
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <CAOMZO5B=0LMqi-v-KwJkvsBEqUU+Bj8TRo08i7zGSv97jnZpVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>





Hi,
I acquire this usb stick 07ca:a835 and it's still does not work properly.

Now, with the af9035 patch from 
http://openpli.git.sourceforge.net/git/gitweb.cgi?p=openpli/openembedded;a=blob_plain;f=recipes/linux/linux-etxx00/dvb-usb-af9035.patch;hb=HEAD

the tv interface is recognize but have trouble with kaffeine, tvtime and gnome-dvb-daemon.

Here's a trace from gnome : "af9033: I2C read failed reg:0047".
>From kaffeine : "kaffeine(3817) DvbDevice::frontendEvent: tuning failed".
>From tvtime, nothing card doesn't appear : probably missing conf, it's ok.

This message try to follow Andrej Podzimekand Gianluca Gennari's messages on 02/07/2012.

Does someone got ideas about what to do to correct this ?

kernel : 3.2.11 with patch noticed. No externe v4l at all during construct. Compile fine :

Mar 18 16:09:43 localhost kernel: [  305.726981] dvb-usb: found a 'Avermedia AverTV Volar HD & HD PRO (A835)' in cold state, will try to load a firmware
Mar 18 16:09:43 localhost kernel: [  305.742050] dvb-usb: downloading firmware from file 'dvb-usb-af9035-01.fw'
Mar 18 16:09:43 localhost kernel: [  306.039886] dvb-usb: found a 'Avermedia AverTV Volar HD & HD PRO (A835)' in warm state.
Mar 18 16:09:43 localhost kernel: [  306.040032] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Mar 18 16:09:43 localhost kernel: [  306.040406] DVB: registering new adapter (Avermedia AverTV Volar HD & HD PRO (A835))
Mar 18 16:09:43 localhost kernel: [  306.078104] af9033: firmware version: LINK:11.15.10.0 OFDM:5.48.10.0
Mar 18 16:09:43 localhost kernel: [  306.080355] DVB: registering adapter 0 frontend 0 (Afatech AF9033 DVB-T)...
Mar 18 16:09:43 localhost kernel: [  306.129981] tda18218: NXP TDA18218HN successfully identified.
Mar 18 16:09:43 localhost kernel: [  306.131483] dvb-usb: Avermedia AverTV Volar HD & HD PRO (A835) successfully initialized and connected.
Mar 18 16:09:43 localhost kernel: [  306.140531] usbcore: registered new interface driver dvb_usb_af9035

Best regards.
See ya.

