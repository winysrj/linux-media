Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JN9wy-00050X-1o
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 17:50:12 +0100
Received: by ug-out-1314.google.com with SMTP id o29so945071ugd.20
	for <linux-dvb@linuxtv.org>; Thu, 07 Feb 2008 08:50:11 -0800 (PST)
Message-ID: <47AB3603.20303@gmail.com>
Date: Thu, 07 Feb 2008 17:46:59 +0100
From: Eduard Huguet <eduardhc@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] How to force adaptor order when using 2 DVB cards?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,
    I currently have a media center computer set up using Gentoo 64 bit =

and a Hauppauge Nova-T 500 card (dual DVB-T receiver). Now I'm trying to =

add a new card (DVB-S), and here my problems begin: not mentioning the =

experimental state of the driver (this is a different story that doesn't =

matter now), my problem is that the new card porks the order in which =

the device nodes were created in /dev. And even worse, the actual order =

ing schema is different between a cold boot and rebooting:

Cold boot:
  =B7 DVB:0: DVB-S tuner from Avermedia A700
  =B7 DVB:1,2: DVB-T tuners from Nova-T

Reboot:
  =B7 DVB:0: 1st DVB-T tuner from Nova-T
  =B7 DVB:1: DVB-S tuner from A700
  =B7 DVB:2: 2nd DVB-T tuner from Nova-T

I guess that on a cold boot the Nova-T 500 takes longer to initialize =

(due to the firmware being loaded), so its adaptors gets both created =

later.

Is there any way to avoid this? My MythTV setup currently expects to =

find the 2 Nova-T 500 adaptors on DVB:0 and DVB:1, and In expected the =

new DVB-S adaptor to be created as DVB:2. However, it seems this is not =

the case.

Is there any way to force the numbering schema or the 2 adaptors? =BFWould =

maybe help i.e. setting RC_DEVICE_TARBALL=3D"yes" in /etc/conf.d/rc =

(currently is set to "no") with only the Nova-T connected and then =

adding te other one? I wonder is this would force its adaptors to be =

created always at the same position.

Thanks for any help you could provide.

Eduard


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
