Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JMJnU-0007t1-4B
	for linux-dvb@linuxtv.org; Tue, 05 Feb 2008 10:08:56 +0100
Received: by py-out-1112.google.com with SMTP id a29so2609104pyi.0
	for <linux-dvb@linuxtv.org>; Tue, 05 Feb 2008 01:08:54 -0800 (PST)
Message-ID: <617be8890802050108q5abf2c44la66a813143da205@mail.gmail.com>
Date: Tue, 5 Feb 2008 10:08:53 +0100
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Matthias Schwarzott" <zzam@gentoo.org>
In-Reply-To: <200802042213.38495.zzam@gentoo.org>
MIME-Version: 1.0
References: <617be8890801290207t77149e2fh73c753501c39e835@mail.gmail.com>
	<617be8890801290513i31dbd438gd259dad054ee4223@mail.gmail.com>
	<617be8890801290523y14ac536dle7d26c0624cae1b5@mail.gmail.com>
	<200802042213.38495.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Patch for analog part for Avermedia A700 fails to
	apply
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1111157175=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1111157175==
Content-Type: multipart/alternative;
	boundary="----=_Part_2405_4994945.1202202533564"

------=_Part_2405_4994945.1202202533564
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
    Bad news: I've been unsuccesfully trying to apply the new patches (as
mentioned in the wiki), with the following results:

1.- analog part applies just fine:

mediacenter v4l-dvb # patch -p1 < ../1_avertv_A700_analog_part.diff
patching file linux/drivers/media/video/saa7134/saa7134-cards.c
patching file linux/drivers/media/video/saa7134/saa7134.h
patching file linux/Documentation/video4linux/CARDLIST.saa7134


2.- Your patch (ZZam's) gives some warnings:

mediacenter v4l-dvb # patch -p1 < ../2_avertv_A700_zzam.diff
patching file linux/drivers/media/video/saa7134/saa7134-cards.c
Hunk #1 succeeded at 4011 with fuzz 2 (offset 19 lines).
Hunk #2 succeeded at 4268 with fuzz 1 (offset 25 lines).
Hunk #3 succeeded at 5266 with fuzz 2 (offset 33 lines).
patching file linux/drivers/media/video/saa7134/saa7134.h
Reversed (or previously applied) patch detected!  Assume -R? [n]
Apply anyway? [n]
Skipping patch.
1 out of 1 hunk ignored -- saving rejects to file
linux/drivers/media/video/saa7134/saa7134.h.rej
patching file linux/Documentation/video4linux/CARDLIST.saa7134
Reversed (or previously applied) patch detected!  Assume -R? [n]
Apply anyway? [n]
Skipping patch.
1 out of 1 hunk ignored -- saving rejects to file
linux/Documentation/video4linux/CARDLIST.saa7134.rej
patching file linux/drivers/media/dvb/frontends/Kconfig
patching file linux/drivers/media/dvb/frontends/Makefile
patching file linux/drivers/media/dvb/frontends/zl1003x.c
patching file linux/drivers/media/dvb/frontends/zl1003x.h
patching file linux/drivers/media/dvb/frontends/mt312.c
patching file linux/drivers/media/dvb/frontends/mt312_priv.h
patching file linux/drivers/media/dvb/frontends/mt312.h
patching file linux/drivers/media/video/saa7134/Kconfig
patching file linux/drivers/media/video/saa7134/saa7134-dvb.c


At this point the patched code doens't even compile:
  ...
  CC [M]  /home/root/src/dvb/v4l-dvb/v4l/pwc-misc.o
  CC [M]  /home/root/src/dvb/v4l-dvb/v4l/pwc-ctrl.o
  CC [M]  /home/root/src/dvb/v4l-dvb/v4l/pwc-v4l.o
  CC [M]  /home/root/src/dvb/v4l-dvb/v4l/pwc-uncompress.o
  CC [M]  /home/root/src/dvb/v4l-dvb/v4l/pwc-dec1.o
  CC [M]  /home/root/src/dvb/v4l-dvb/v4l/pwc-dec23.o
  CC [M]  /home/root/src/dvb/v4l-dvb/v4l/pwc-kiara.o
  CC [M]  /home/root/src/dvb/v4l-dvb/v4l/pwc-timon.o
  CC [M]  /home/root/src/dvb/v4l-dvb/v4l/saa7134-cards.o
/home/root/src/dvb/v4l-dvb/v4l/saa7134-cards.c: In function
'saa7134_board_init1':
/home/root/src/dvb/v4l-dvb/v4l/saa7134-cards.c:5269: error: duplicate case
value
/home/root/src/dvb/v4l-dvb/v4l/saa7134-cards.c:5261: error: previously used
here
make[3]: *** [/home/root/src/dvb/v4l-dvb/v4l/saa7134-cards.o] Error 1
make[2]: *** [_module_/home/root/src/dvb/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.23-tuxonice-r8'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/root/src/dvb/v4l-dvb/v4l'
make: *** [all] Error 2

This is the offending code in  v4l/saa7134-cards.c:

        case SAA7134_BOARD_AVERMEDIA_A700:
                /* write windows gpio values */
                saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x80040100,
0x80040100);
                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x80040100,
0x00040100);
                printk("%s: %s: hybrid analog/dvb card\n"
                       "%s: Sorry, only the analog inputs are supported for
now.\n",
                        dev->name,card(dev).name, dev->name);
                break;
        case SAA7134_BOARD_AVERMEDIA_A700:
                /* write windows gpio values */
                saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x80040100,
0x80040100);
                saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x80040100,
0x00040100);

                /* reset demod */
                saa7134_set_gpio(dev, 23, 1);
                msleep(100);
                saa7134_set_gpio(dev, 23, 3); // back to tristate = input
mode

                break;


Apparently the A700 section is duplicated. I assume that the second section
is the good one, as the first gives only option for analog input. This is
probably related to the patch no aplying cleanly. I've removed the 1st
section and now it seems to compile fine.


3.- Tino's patch gets worse. It even doesn't apply:

mediacenter v4l-dvb # patch -p1 < ../3_avertv_A700_tino.diff
patching file linux/drivers/media/common/ir-keymaps.c
Hunk #1 FAILED at 1898.
1 out of 1 hunk FAILED -- saving rejects to file
linux/drivers/media/common/ir-keymaps.c.rej
patching file linux/drivers/media/dvb/frontends/Kconfig
Hunk #2 succeeded at 374 (offset 7 lines).
patching file linux/drivers/media/dvb/frontends/Makefile
Hunk #1 succeeded at 51 (offset 1 line).
patching file linux/drivers/media/dvb/frontends/zl10039.c
patching file linux/drivers/media/dvb/frontends/zl10039.h
patching file linux/drivers/media/dvb/frontends/zl10039_priv.h
The next patch would create the file
linux/drivers/media/dvb/frontends/zl1003x.c,
which already exists!  Assume -R? [n]
Apply anyway? [n] y
patching file linux/drivers/media/dvb/frontends/zl1003x.c
Patch attempted to create file linux/drivers/media/dvb/frontends/zl1003x.c,
which already exists.
Hunk #1 FAILED at 1.
1 out of 1 hunk FAILED -- saving rejects to file
linux/drivers/media/dvb/frontends/zl1003x.c.rej
The next patch would create the file
linux/drivers/media/dvb/frontends/zl1003x.h,
which already exists!  Assume -R? [n]
Apply anyway? [n] y
patching file linux/drivers/media/dvb/frontends/zl1003x.h
Patch attempted to create file linux/drivers/media/dvb/frontends/zl1003x.h,
which already exists.
Hunk #1 FAILED at 1.
1 out of 1 hunk FAILED -- saving rejects to file
linux/drivers/media/dvb/frontends/zl1003x.h.rej
patching file linux/drivers/media/dvb/frontends/zl10313.c
patching file linux/drivers/media/dvb/frontends/zl10313.h
patching file linux/drivers/media/dvb/frontends/zl10313_priv.h
patching file linux/drivers/media/video/saa7134/Kconfig
Hunk #1 FAILED at 37.
1 out of 1 hunk FAILED -- saving rejects to file
linux/drivers/media/video/saa7134/Kconfig.rej
patching file linux/drivers/media/video/saa7134/saa7134-cards.c
Hunk #1 succeeded at 3280 (offset 11 lines).
Hunk #2 succeeded at 4029 with fuzz 1 (offset 429 lines).
Hunk #3 succeeded at 4096 (offset 429 lines).
Hunk #4 succeeded at 5051 with fuzz 2 (offset 621 lines).
Hunk #5 FAILED at 5305.
1 out of 5 hunks FAILED -- saving rejects to file
linux/drivers/media/video/saa7134/saa7134-cards.c.rej
patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
Hunk #2 succeeded at 668 (offset 3 lines).
Hunk #3 succeeded at 873 (offset 30 lines).
Hunk #4 succeeded at 1112 with fuzz 2 (offset 45 lines).
patching file linux/drivers/media/video/saa7134/saa7134.h
Hunk #1 FAILED at 247.
1 out of 1 hunk FAILED -- saving rejects to file
linux/drivers/media/video/saa7134/saa7134.h.rej
patching file linux/drivers/media/video/saa7134/saa7134-input.c
Hunk #1 succeeded at 304 (offset 44 lines).
Hunk #2 succeeded at 405 (offset 54 lines).
patching file linux/include/media/ir-common.h
Hunk #1 FAILED at 140.
1 out of 1 hunk FAILED -- saving rejects to file linux/include/media/ir-
common.h.rej


This is using a fresh copy of HG tree.

Regards,
  Eduard



2008/2/4, Matthias Schwarzott <zzam@gentoo.org>:
> On Dienstag, 29. Januar 2008, Eduard Huguet wrote:
> > 2008/1/29, Matthias Schwarzott <zzam@gentoo.org>:
> > >
> > > Sure the patch is too old. There was added a new card to saa7134
driver.
> > > So I
> > > needed to update the patch.
> > > You can now get the patch from my last mail (it was attached).
> > > http://thread.gmane.org/gmane.linux.drivers.dvb/38943/focus=38952
> > >
> > > Or you re-download the file linked from the wiki. I uploaded the new
> > > version.
> > >
> > > Greetings
> > > Matthias
> > >
> > > --
> > > Matthias Schwarzott (zzam)
> >
> > Ok, thanks. I'll try it later.
> >
> > Best regards,
> >   Eduard Huguet
>
> Hi Eduard!
> The full patch can be found here: http://dev.gentoo.org/~zzam/dvb/
>
> It is now also linked from here:
> http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_DVB-S_Pro_(A700)
>
> Regards
> Matthias
>
> --
> Matthias Schwarzott (zzam)
>

------=_Part_2405_4994945.1202202533564
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, <br>&nbsp;&nbsp;&nbsp;&nbsp;Bad news: I&#39;ve been unsuccesfully trying to apply the new patches (as mentioned in the wiki), with the following results:<br><br>1.- analog part applies just fine:<br><span style="font-family: courier new,monospace;"><br>
mediacenter v4l-dvb # patch -p1 &lt; ../1_avertv_A700_analog_part.d</span><span style="font-family: courier new,monospace;">iff</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/video/saa7</span><span style="font-family: courier new,monospace;">134/saa7134-cards.c</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/video/saa7</span><span style="font-family: courier new,monospace;">134/saa7134.h</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/Documentation/video4linu</span><span style="font-family: courier new,monospace;">x/CARDLIST.saa7134</span><br style="font-family: courier new,monospace;">
<br><br>2.- Your patch (ZZam&#39;s) gives some warnings:<br><br><span style="font-family: courier new,monospace;">mediacenter v4l-dvb # patch -p1 &lt; ../2_avertv_A700_zzam.diff</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/video/saa7134/saa7134-cards.c</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Hunk #1 succeeded at 4011 with fuzz 2 (offset 19 lines).</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Hunk #2 succeeded at 4268 with fuzz 1 (offset 25 lines).</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Hunk #3 succeeded at 5266 with fuzz 2 (offset 33 lines).</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/video/saa7134/saa7134.h</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Reversed (or previously applied) patch detected!&nbsp; Assume -R? [n]</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Apply anyway? [n]</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Skipping patch.</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">1 out of 1 hunk ignored -- saving rejects to file linux/drivers/media/video/saa7134/saa7134.h.rej</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/Documentation/video4linux/CARDLIST.saa7134</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Reversed (or previously applied) patch detected!&nbsp; Assume -R? [n]</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Apply anyway? [n]</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Skipping patch.</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">1 out of 1 hunk ignored -- saving rejects to file linux/Documentation/video4linux/CARDLIST.saa7134.rej</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/Kconfig</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/Makefile</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/zl1003x.c</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/zl1003x.h</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/mt312.c</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/mt312_priv.h</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/mt312.h</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/video/saa7134/Kconfig</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/video/saa7134/saa7134-dvb.c</span><br style="font-family: courier new,monospace;"><br style="font-family: courier new,monospace;"><br>At this point the patched code doens&#39;t even compile:<br>
<span style="font-family: courier new,monospace;">&nbsp; ...</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&nbsp; CC [M]&nbsp; /home/root/src/dvb/v4l-dvb/v4l/pwc-misc.o</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&nbsp; CC [M]&nbsp; /home/root/src/dvb/v4l-dvb/v4l/pwc-ctrl.o</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&nbsp; CC [M]&nbsp; /home/root/src/dvb/v4l-dvb/v4l/pwc-v4l.o</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&nbsp; CC [M]&nbsp; /home/root/src/dvb/v4l-dvb/v4l/pwc-uncompress.o</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&nbsp; CC [M]&nbsp; /home/root/src/dvb/v4l-dvb/v4l/pwc-dec1.o</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&nbsp; CC [M]&nbsp; /home/root/src/dvb/v4l-dvb/v4l/pwc-dec23.o</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&nbsp; CC [M]&nbsp; /home/root/src/dvb/v4l-dvb/v4l/pwc-kiara.o</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&nbsp; CC [M]&nbsp; /home/root/src/dvb/v4l-dvb/v4l/pwc-timon.o</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&nbsp; CC [M]&nbsp; /home/root/src/dvb/v4l-dvb/v4l/saa7134-cards.o</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">/home/root/src/dvb/v4l-dvb/v4l/saa7134-cards.c: In function &#39;saa7134_board_init1&#39;:</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">/home/root/src/dvb/v4l-dvb/v4l/saa7134-cards.c:5269: error: duplicate case value</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">/home/root/src/dvb/v4l-dvb/v4l/saa7134-cards.c:5261: error: previously used here</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">make[3]: *** [/home/root/src/dvb/v4l-dvb/v4l/saa7134-cards.o] Error 1</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">make[2]: *** [_module_/home/root/src/dvb/v4l-dvb/v4l] Error 2</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">make[2]: Leaving directory `/usr/src/linux-2.6.23-tuxonice-r8&#39;</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">make[1]: *** [default] Error 2</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">make[1]: Leaving directory `/home/root/src/dvb/v4l-dvb/v4l&#39;</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">make: *** [all] Error 2</span><br style="font-family: courier new,monospace;"><br>This is the offending code in &nbsp;v4l/saa7134-cards.c:<br><br><span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case SAA7134_BOARD_AVERMEDIA_A700:</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* write windows gpio values */</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; saa_andorl(SAA7134_GPIO_GPMODE0 &gt;&gt; 2,&nbsp;&nbsp; 0x80040100, 0x80040100);</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; saa_andorl(SAA7134_GPIO_GPSTATUS0 &gt;&gt; 2, 0x80040100, 0x00040100);</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printk(&quot;%s: %s: hybrid analog/dvb card\n&quot;</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;%s: Sorry, only the analog inputs are supported for now.\n&quot;,</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dev-&gt;name,card(dev).name, dev-&gt;name);</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; break;</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; case SAA7134_BOARD_AVERMEDIA_A700:</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* write windows gpio values */</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; saa_andorl(SAA7134_GPIO_GPMODE0 &gt;&gt; 2,&nbsp;&nbsp; 0x80040100, 0x80040100);</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; saa_andorl(SAA7134_GPIO_GPSTATUS0 &gt;&gt; 2, 0x80040100, 0x00040100);</span><br style="font-family: courier new,monospace;"><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* reset demod */</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; saa7134_set_gpio(dev, 23, 1);</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; msleep(100);</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; saa7134_set_gpio(dev, 23, 3); // back to tristate = input mode</span><br style="font-family: courier new,monospace;">
<br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; break;</span><br style="font-family: courier new,monospace;"><br style="font-family: courier new,monospace;">
<br>Apparently the A700 section is duplicated. I assume that the second section is the good one, as the first gives only option for analog input. This is probably related to the patch no aplying cleanly. I&#39;ve removed the 1st section and now it seems to compile fine.<br>
<br><br>3.- Tino&#39;s patch gets worse. It even doesn&#39;t apply:<br><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">mediacenter v4l-dvb # patch -p1 &lt; ../3_avertv_A700_tino.diff</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/common/ir-keymaps.c</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Hunk #1 FAILED at 1898.</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">1 out of 1 hunk FAILED -- saving rejects to file linux/drivers/media/common/ir-keymaps.c.rej</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/Kconfig</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Hunk #2 succeeded at 374 (offset 7 lines).</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/Makefile</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Hunk #1 succeeded at 51 (offset 1 line).</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/zl10039.c</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/zl10039.h</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/zl10039_priv.h</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">The next patch would create the file linux/drivers/media/dvb/frontends/zl1003x.c,</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">which already exists!&nbsp; Assume -R? [n]</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Apply anyway? [n] y</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/zl1003x.c</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Patch attempted to create file linux/drivers/media/dvb/frontends/zl1003x.c, which already exists.</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Hunk #1 FAILED at 1.</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">1 out of 1 hunk FAILED -- saving rejects to file linux/drivers/media/dvb/frontends/zl1003x.c.rej</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">The next patch would create the file linux/drivers/media/dvb/frontends/zl1003x.h,</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">which already exists!&nbsp; Assume -R? [n]</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Apply anyway? [n] y</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/zl1003x.h</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Patch attempted to create file linux/drivers/media/dvb/frontends/zl1003x.h, which already exists.</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Hunk #1 FAILED at 1.</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">1 out of 1 hunk FAILED -- saving rejects to file linux/drivers/media/dvb/frontends/zl1003x.h.rej</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/zl10313.c</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/zl10313.h</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/dvb/frontends/zl10313_priv.h</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/video/saa7134/Kconfig</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Hunk #1 FAILED at 37.</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">1 out of 1 hunk FAILED -- saving rejects to file linux/drivers/media/video/saa7134/Kconfig.rej</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/video/saa7134/saa7134-cards.c</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Hunk #1 succeeded at 3280 (offset 11 lines).</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Hunk #2 succeeded at 4029 with fuzz 1 (offset 429 lines).</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Hunk #3 succeeded at 4096 (offset 429 lines).</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Hunk #4 succeeded at 5051 with fuzz 2 (offset 621 lines).</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Hunk #5 FAILED at 5305.</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">1 out of 5 hunks FAILED -- saving rejects to file linux/drivers/media/video/saa7134/saa7134-cards.c.rej</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/video/saa7134/saa7134-dvb.c</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Hunk #2 succeeded at 668 (offset 3 lines).</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Hunk #3 succeeded at 873 (offset 30 lines).</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Hunk #4 succeeded at 1112 with fuzz 2 (offset 45 lines).</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/drivers/media/video/saa7134/saa7134.h</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Hunk #1 FAILED at 247.</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">1 out of 1 hunk FAILED -- saving rejects to file linux/drivers/media/video/saa7134/saa7134.h.rej</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">patching file linux/drivers/media/video/saa7134/saa7134-input.c</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Hunk #1 succeeded at 304 (offset 44 lines).</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Hunk #2 succeeded at 405 (offset 54 lines).</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">patching file linux/include/media/ir-common.h</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">Hunk #1 FAILED at 140.</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">1 out of 1 hunk FAILED -- saving rejects to file linux/include/media/ir-common.h.rej</span><br style="font-family: courier new,monospace;">
<br><br>This is using a fresh copy of HG tree.<br><br>Regards,<br>&nbsp; Eduard<br><br><br><br>2008/2/4, Matthias Schwarzott &lt;<a href="mailto:zzam@gentoo.org">zzam@gentoo.org</a>&gt;:<br>&gt; On Dienstag, 29. Januar 2008, Eduard Huguet wrote:<br>
&gt; &gt; 2008/1/29, Matthias Schwarzott &lt;<a href="mailto:zzam@gentoo.org">zzam@gentoo.org</a>&gt;:<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; Sure the patch is too old. There was added a new card to saa7134 driver.<br>&gt; &gt; &gt; So I<br>
&gt; &gt; &gt; needed to update the patch.<br>&gt; &gt; &gt; You can now get the patch from my last mail (it was attached).<br>&gt; &gt; &gt; <a href="http://thread.gmane.org/gmane.linux.drivers.dvb/38943/focus=38952">http://thread.gmane.org/gmane.linux.drivers.dvb/38943/focus=38952</a><br>
&gt; &gt; &gt;<br>&gt; &gt; &gt; Or you re-download the file linked from the wiki. I uploaded the new<br>&gt; &gt; &gt; version.<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; Greetings<br>&gt; &gt; &gt; Matthias<br>&gt; &gt; &gt;<br>
&gt; &gt; &gt; --<br>&gt; &gt; &gt; Matthias Schwarzott (zzam)<br>&gt; &gt;<br>&gt; &gt; Ok, thanks. I&#39;ll try it later.<br>&gt; &gt;<br>&gt; &gt; Best regards,<br>&gt; &gt;&nbsp;&nbsp; Eduard Huguet<br>&gt; <br>&gt; Hi Eduard!<br>
&gt; The full patch can be found here: <a href="http://dev.gentoo.org/~zzam/dvb/">http://dev.gentoo.org/~zzam/dvb/</a><br>&gt; <br>&gt; It is now also linked from here:<br>&gt; <a href="http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_DVB-S_Pro_(A700)">http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_DVB-S_Pro_(A700)</a><br>
&gt; <br>&gt; Regards<br>&gt; Matthias<br>&gt; <br>&gt; --<br>&gt; Matthias Schwarzott (zzam)<br>&gt; <br>

------=_Part_2405_4994945.1202202533564--


--===============1111157175==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1111157175==--
