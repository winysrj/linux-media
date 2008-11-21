Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from portal.beam.ltd.uk ([62.49.82.227] helo=beam.beamnet)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <terry1@beam.ltd.uk>) id 1L3Tct-00022y-E7
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 11:52:40 +0100
Message-ID: <492692D2.2000009@beam.ltd.uk>
Date: Fri, 21 Nov 2008 10:52:02 +0000
From: Terry Barnaby <terry1@beam.ltd.uk>
MIME-Version: 1.0
To: Terry Barnaby <terry1@beam.ltd.uk>
References: <492568A2.4030100@beam.ltd.uk> <492691B9.1080809@beam.ltd.uk>
In-Reply-To: <492691B9.1080809@beam.ltd.uk>
Content-Type: multipart/mixed; boundary="------------030308020104080607060007"
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] Take 2: Re: Twinhan VisionPlus DVB-T Card not
 working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------030308020104080607060007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Terry Barnaby wrote:
> Terry Barnaby wrote:
>> Hi,
>>
>> I am having a problem with the latest DVB drivers.
>> I have a Twinhan VisionPlus DVB-T card (and other DVB cards) in my
>> MythTv server running Fedora 8. This is running fine
>> with the Fedora stock kernel: 2.6.26.6-49.fc8.
>>
>> However, I have now added a Hauppauge DVB-S2 and so have been
>> trying the latest DVB Mercurial DVB tree.
>> This compiles and installs fine and the two DVB-T cards and the
>> new DVB-S card are recognised and has /dev/dvb entries.
>> The first DVB-T card, a Twinhan based on the SAA7133/SAA7135
>> works fine but the Twinhan VisionPlus, which is Bt878 will not
>> tune in.
>>
>> Any ideas ?
>> Has there been any recent changes to the Bt878 driver that could
>> have caused this ?
>>
> 
> I have tracked this down to a bug in the bt8xx/dst frontend.
> It appears that the front end tuning algorithm number as used in
> dvb_frontend.c has changed format but the default setting in
> bt8xx/dst has not been updated to match.
> 
> This patch sets the default algorithm to be software tuning as,
> I believe, was the original setting. However, I wonder if
> it should be set to use hardware tuning by default ...
> 
> 
> Cheers
> 
> 
> Terry
> 
This is a better patch as it describes the integer values
that can be used as options.

Cheers


Terry

--------------030308020104080607060007
Content-Type: text/x-patch;
 name="v4l-dvb.beam.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="v4l-dvb.beam.patch"

diff -r 5dc4a6b381f6 linux/drivers/media/dvb/bt8xx/dst.c
--- a/linux/drivers/media/dvb/bt8xx/dst.c	Wed Nov 19 13:01:33 2008 -0200
+++ b/linux/drivers/media/dvb/bt8xx/dst.c	Fri Nov 21 10:50:00 2008 +0000
@@ -38,9 +38,9 @@ module_param(dst_addons, int, 0644);
 module_param(dst_addons, int, 0644);
 MODULE_PARM_DESC(dst_addons, "CA daughterboard, default is 0 (No addons)");
 
-static unsigned int dst_algo;
+static unsigned int dst_algo = DVBFE_ALGO_SW;
 module_param(dst_algo, int, 0644);
-MODULE_PARM_DESC(dst_algo, "tuning algo: default is 0=(SW), 1=(HW)");
+MODULE_PARM_DESC(dst_algo, "tuning algo: default is 2=DVBFE_ALGO_SW (options: 1=DVBFE_ALGO_HW)");
 
 #define HAS_LOCK		1
 #define ATTEMPT_TUNE		2

--------------030308020104080607060007
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------030308020104080607060007--
