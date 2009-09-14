Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:39214 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZINPS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 11:18:59 -0400
Received: by ey-out-2122.google.com with SMTP id 25so609083eya.19
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 08:19:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <64a476a80909140810j2c23a11fp994c6278ec01829a@mail.gmail.com>
References: <64a476a80909140736k159fddffle1d6ccbcaa3cecfb@mail.gmail.com>
	<64a476a80909140739h6612ce69u2819335f7ea2c758@mail.gmail.com>
	<64a476a80909140804s34ebd140r7934f46fb2150364@mail.gmail.com>
	<64a476a80909140810j2c23a11fp994c6278ec01829a@mail.gmail.com>
From: "Peter J. Olson" <peterjolson@gmail.com>
Date: Mon, 14 Sep 2009 10:18:42 -0500
Message-ID: <64a476a80909140818y7d29fb0w84f247e4de702a30@mail.gmail.com>
Subject: Compile error when I get to snd-go7007.c
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey all,

I have a Mythbuntu 8.10 system w/ a pctv 800i (pci card) and a pctv hd
stick (800e). Had both running just fine for about 8 months... then
the stick stopped working.  Or rather, it works but wont pick up a
signal.

I decided I would update my system a little and figure out what broke
my 800e. I updated my kernel and went to recompile v4l-dvb and got
this error:

  CC [M]  /home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.o

/home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.c: In function 'go7007_snd_init':

/home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.c:251: error: implicit
declaration of function 'snd_card_create'

make[3]: *** [/home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.o] Error 1

make[2]: *** [_module_/home/mythbox/Firmware/v4l-dvb/v4l] Error 2

make[2]: Leaving directory `/usr/src/linux-headers-2.6.28-15-generic'

make[1]: *** [default] Error 2

make[1]: Leaving directory `/home/mythbox/Firmware/v4l-dvb/v4l'

make: *** [all] Error 2

I was using the old copy of v4l I had so I thought it might have been
the new kernel fighting w/ the old v4l. So I updated v4l (did a pull
via hg)... same error.

I dinked w/ it for a long time and finally gave up and upgraded to
9.0.4. Same error, now neither of my cards will work (brutal!)  My
800i is acting like the 800e was.  I can see the card in mythbackend
setup but always gets no signal in mythtv.

I dont even know what the snd-go7007 would go with... I dont even have
that type of hardware (i dont think).

Anyone have any ideas?

Thanks,
Peter
