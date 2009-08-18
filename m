Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from tricon.hu ([195.70.57.4])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <don@tricon.hu>) id 1MdQJE-0000aT-7W
	for linux-dvb@linuxtv.org; Tue, 18 Aug 2009 17:09:13 +0200
Received: from axe.evosoft.hu (shell.vz [192.168.10.70])
	by tricon.hu (Postfix) with ESMTP id F3A2481A101
	for <linux-dvb@linuxtv.org>; Tue, 18 Aug 2009 17:08:09 +0200 (CEST)
Date: Tue, 18 Aug 2009 17:08:20 +0200
From: =?ISO-8859-2?Q?P=E1sztor_Szil=E1rd?= <don@tricon.hu>
To: linux-dvb@linuxtv.org
Message-Id: <20090818170820.3d999fb9.don@tricon.hu>
Mime-Version: 1.0
Subject: [linux-dvb] Anysee E30 C Plus + MPEG-4?
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

I recently got the USB DVB-C tuner mentioned in the subject.
Everything seems to work fine, except that the MPEG-4 HD channels have no
video, only sound. Regular SD channels broadcasted in MPEG-2 are flawless.

The tuner can receive MPEG-4 streams; decoder is not built in but Mplayer
would do the job if it could get the data. I have also tried in Window$ and HD
channels are working properly.

I used w_scan to scan through the channels and it found almost everything that
the Win scanner did (one block is missing in linux though, probably due to
different scanning parameters needed but the win one is dumb and won't tell me
any useful information).

My kernel: 2.6.30.5

Excerpt from dmesg:
dvb-usb: found a 'Anysee DVB USB2.0' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Anysee DVB USB2.0)
anysee: firmware version:0.1.2 hardware id:15
DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
input: IR-receiver inside an USB DVB receiver as /class/input/input3
dvb-usb: schedule remote query interval to 200 msecs.
dvb-usb: Anysee DVB USB2.0 successfully initialized and connected.

Any ideas on how I could start with my investigations? I took a quick peek
into the driver source but no story of mpeg 2/4 differences there.

regards,
s.

        ---------------------------------------------------------------
        |  Make it idiot proof and someone will make a better idiot.  |
        ---------------------------------------------------------------

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
