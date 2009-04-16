Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.228])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tutuyu@usc.edu>) id 1LubUy-0004QV-Aa
	for linux-dvb@linuxtv.org; Fri, 17 Apr 2009 02:00:05 +0200
Received: by rv-out-0506.google.com with SMTP id k40so541480rvb.41
	for <linux-dvb@linuxtv.org>; Thu, 16 Apr 2009 16:59:58 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 16 Apr 2009 16:59:57 -0700
Message-ID: <cae4ceb0904161659q50808ff8p965b3b1b46f14ab1@mail.gmail.com>
From: Tu-Tu Yu <tutuyu@usc.edu>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] About HVR1250 cant load the driver
Reply-To: linux-media@vger.kernel.org
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

Dear Sirs:
I have tried to install HVR 1200 in my machine...
I follow the step on the website. But it seems like i didn't load the
driver. Could somebody tell me which step i did wrong?
Thank you so much!!!!
Audrey


   1. Change into the v4l-dvb directory:

      cd v4l-dvb

   2. Build the modules:

      make

   3. Install the modules:

      make install

   4. Download the files from http://steventoth.net/linux/hvr1200/ and
follow the instructions in the readme.txt
   (on this step i do sh extract.sh on one machine and then copy those
3 files to both /lib/firmware and /lib/firmware/2.6.26, because the
machine i am using now doesn't support unzip)

   5. add this line to /etc/modules.d/dvb:
   (on this step because there is no modules.d/dvb file in my machine
so i create it by mkdir)

after i reboot, and scan, it shows:

     scanning /usr/share/dvb/dvb-t/uk-Oxford
     using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
     initial transponder 578000000 0 3 9 1 0 0 0
     initial transponder 850000000 0 2 9 3 0 0 0
     initial transponder 713833000 0 2 9 3 0 0 0
     initial transponder 721833000 0 3 9 1 0 0 0
     initial transponder 690000000 0 3 9 1 0 0 0
     initial transponder 538000000 0 3 9 1 0 0 0
      >>> tune to:
578000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
     WARNING: >>> tuning failed!!!
     >>> tune to:
578000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
(tuning failed)
     WARNING: >>> tuning failed!!!

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
