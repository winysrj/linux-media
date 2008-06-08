Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.okg-computer.de ([85.131.254.125])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@okg-computer.de>) id 1K5Fsp-0007bM-Gv
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 10:04:12 +0200
Message-ID: <484B9279.4030600@okg-computer.de>
Date: Sun, 08 Jun 2008 10:04:09 +0200
From: =?ISO-8859-15?Q?Jens_Krehbiel-Gr=E4ther?=
 <linux-dvb@okg-computer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org, =?ISO-8859-15?Q?Michael_Sch=F6ller?=
	<michael.schoeller@schoeller-soft.net>
References: <484709F3.7020003@schoeller-soft.net>	<854d46170806060249h1aec73e4s645462a123371c29@mail.gmail.com>	<48497340.3050602@schoeller-soft.net>	<200806070018.16103.dkuhlen@gmx.net>
	<484A584B.9010901@schoeller-soft.net>
In-Reply-To: <484A584B.9010901@schoeller-soft.net>
Content-Type: multipart/mixed; boundary="------------040008090506070908030602"
Subject: Re: [linux-dvb] How to get a PCTV Sat HDTC Pro USB (452e) running?
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
--------------040008090506070908030602
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

>
> Ok I can tell that my problem is Distribution independent 
> </search?hl=de&sa=X&oi=spell&resnum=0&ct=result&cd=1&q=independent&spell=1>. 
> On Fedora it's a bit harder to get multiproto running (/dev/dvb 
> appears) but the error with scan and szap is the same ("ioctl 
> DVBFE_GET_INFO failed: Invalid Argument").
>
> This time I tried these steps (based on the hints in previous posts)
> 1. hg clone http://www.jusst.de/hg/multiproto
> 2. cd into multiproto and run "patch -p1 < 
> patch_add_pctv452e_tt_s2_36x0.diff" (the fixed one from Jens Message 
> at 22:09) -> no errors
> 3. run "make" and "make install" -> well gives compile errors so I 
> followed Faruks instructions
> 3b) cd to multiproto/linux/drivers/media/video
>  and rename the Makefile to like Makefile_
> after this i won't compile any analog drivers and it will compile dvb
> and radio drivers.
> 3c) 3. run "make clean", "make" and "make install" ->works now
> 4. hg clone http://linuxtv.org/hg/dvb-apps
> 5. cd into dvb-apps and run "patch -p1 < patch_sca_szap.diff" 
> (attached in the message) -> no errors
>  6. copy version.h and frontend.h -> Well that one was tricky I found 
> out that the place where the include files are in 
> /usr/include/linux/dvb is that correct. However after copy them to 
> this location make in the scan and szap directory works. And make in 
> the dvb-apps now gives an error that Fields are already defined. Well 
> however thats not in the steps so I do..
> 7. cd into dvb-apps/util/<scan,szap> and run "make" -> well that 
> works....to compile
> ioctl DVBFE_GET_INFO failed: Invalid Argument...I'm starting to hate 
> that words...


What error occurs in step 3?? My tip is that you use a 2.6.24 kernel 
version? If this is true, you have to apply another patch to the hg-tree 
(attached).
Then it should compile without errors.

Jens


--------------040008090506070908030602
Content-Type: text/x-patch;
 name="patch_compat_2_6_24.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch_compat_2_6_24.diff"

--- a/v4l/compat.h	2008-06-05 08:38:46.000000000 +0200
+++ b/v4l/compat.h	2008-05-18 18:25:08.000000000 +0200
@@ -15,7 +15,7 @@
 #endif
 
 /* To allow alsa code to work */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 24)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 25)
 #include <sound/driver.h>
 #endif
 

--------------040008090506070908030602
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------040008090506070908030602--
