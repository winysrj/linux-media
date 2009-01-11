Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from tangens-u.sinus.cz
	([89.250.251.168] helo=tangens.sinus.cz ident=root)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrol@tangens.sinus.cz>) id 1LLwkl-0005wR-M7
	for linux-dvb@linuxtv.org; Sun, 11 Jan 2009 10:37:09 +0100
Received: from tangens.sinus.cz (patrol@localhost [127.0.0.1])
	by tangens.sinus.cz (8.14.1/8.14.1) with ESMTP id n0B9b3HG021917
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Sun, 11 Jan 2009 10:37:03 +0100
Received: (from patrol@localhost)
	by tangens.sinus.cz (8.14.1/8.14.1/Submit) id n0B9b34O021916
	for linux-dvb@linuxtv.org; Sun, 11 Jan 2009 10:37:03 +0100
Date: Sun, 11 Jan 2009 10:37:03 +0100
From: Pavel Troller <patrol@sinus.cz>
To: linux-dvb@linuxtv.org
Message-ID: <20090111093703.GA20152@tangens.sinus.cz>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] S2API: Problem with 64/32bit compatibility
Reply-To: Pavel Troller <patrol@sinus.cz>
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

Hi!
  I would like to report a problem with S2API. It looks that it doesn't
maintain 64/32bit compatibility.
  It began with my attempt to run the SVN version of kaffeine on linux-2.6.28.
  My system is a 64bit GNU/Linux, but, for historical reasons, I'm still using
32bit KDE 3.5.10, so kaffeine has been compiled as a 32bit binary.
  I've found that I cannot play DVB on this combination. It's because the
FE_SET_PROPERTY ioctl is not properly handled in the kernel.
  After a lot of analysis of both kaffeine and kernel source code, I've found
that the core of the problem is in /usr/src/linux/include/linux/dvb/frontend.h,
where the ioctl is declared. There, a struct dtv_properties is declared:

struct dtv_properties {
        __u32 num;
        struct dtv_property *props;
};

  This struct is then used as a data entry in the FE_SET_PROPERTY ioctl.
  The problem is, that the pointer has different sizes on 32 and 64bit
architectures, so the whole struct differs in size too. And because the size
is passed as a part of the ioctl command code, the FE_SET_PROPERTY (and
FE_GET_PROPERTY too) command codes differ for 32/64 bit compilation of the
same include file! For example, for FE_SET_PROPERTY, its 0x40106f52 on 64bit,
but 0x40086f52 on 32bit. So, the kernel (having the 64bit code inside) cannot
recognize the 32bit code of the cmd and fails to handle it correctly.
  The second part is that these ioctls are not yet added to the 
/usr/src/linux/fs/compat_ioctl.c file, maybe just because of the problem above.

  Are there plans to fix this problem ? I think that 64/32bit compatibility
should be fully maintained, I think that my case is not so rare yet.

  With regards, Pavel Troller   

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
