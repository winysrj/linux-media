Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:44863 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758802AbaGYCGw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 22:06:52 -0400
Message-ID: <53D1B999.7090608@earthlink.net>
Date: Thu, 24 Jul 2014 21:57:45 -0400
From: Felix Miata <mrmazda@earthlink.net>
MIME-Version: 1.0
To: Martin Kepplinger <martink@posteo.de>,
	intel-gfx-bounces@lists.freedesktop.org,
	linux-media@vger.kernel.org
Subject: Re: [BUG] rc1 rc2 rc3 not bootable - black screen after kernel loading
References: <53A6E72A.9090000@posteo.de>	 <744357E9AAD1214791ACBA4B0B90926301379B97@SHSMSX101.ccr.corp.intel.com>	 <53A81BF7.3030207@posteo.de> <1403529246.4686.6.camel@rzhang1-toshiba>	 <53A83DC7.1010606@posteo.de> <1403882067.16305.124.camel@rzhang1-toshiba>	 <53ADB359.4010401@posteo.de> <53ADCB24.9030206@posteo.de>	 <53ADECDA.60600@posteo.de> <53B11749.3020902@posteo.de>	 <1404116299.8366.0.camel@rzhang1-toshiba> <1404116444.8366.1.camel@rzhang1-toshiba> <53B12723.4080902@posteo.de> <53B13E4B.2080603@posteo.de> <53D131E7.2090304@posteo.de>
In-Reply-To: <53D131E7.2090304@posteo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-07-24 18:18 (GMT+0200) Martin Kepplinger composed:

> schrieb Martin Kepplinger:

>> back to aaeb2554337217dfa4eac2fcc90da7be540b9a73 as the first bad
>> commit. why is this not revertable exactly? how can I show a complete
>> list of commits this merge introduces?

> It seems that _nobody_ is running a simple 32 bit i915 (acer) laptop.
> rc6 is still unusable. Black screen directly after kernel-loading. no
> change since rc1.
 
> Seems like I won't be able to use 3.16. I'm happy to test patches and am
> happy for any advice what to do, when time permits.
 
I keep seeing this thread's post come to me via the linux-media@vger.kernel.org
list with a bucketload of CCs, but don't know why. Is this a problem exclusive
to laptops? I have 32 bit 3.16rc6 working on a i915G desktop just fine NAICT
with KDE3 booting multi-user and running startx:

gx280:~ $ grep 'using VT' /var/log/Xorg.0.log
[   354.196] (--) using VT number 7
gx280:~ $ lspci | grep VGA
00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL Integrated Graphics Controller (rev 04)
gx280:~ $ grep PRETTY /etc/os-release
PRETTY_NAME="openSUSE 20140721 (Harlequin) (i586)"
gx280:~ $ grep 'X.Org X Server' /var/log/Xorg.0.log
X.Org X Server 1.16.0
gx280:~ $ grep 'Current Operating System' /var/log/Xorg.0.log
[   354.177] Current Operating System: Linux gx280 3.16.0-rc6-1.ga0523f2-desktop #1 SMP PREEMPT Mon Jul 21 13:03:47 UTC 2014 (a0523f2) i686
gx280:~ $ grep 'Kernel Command Line' /var/log/Xorg.0.log
[   354.177] Kernel command line: root=LABEL=os132p20 ipv6.disable=1 noresume splash=verbose vga=791 video=1024x768@60 3
gx280:~ $ grep Output /var/log/Xorg.0.log | egrep -v 'disconnec|no monit' | grep -v 'nitor sect'
[   354.209] (--) intel(0): Output VGA1 using initial mode 1024x768 on pipe 0
gx280:~ $ grep -v ^\# /etc/X11/xorg.conf.d/50-monitor.conf | grep DisplaySize
gx280:~ $ grep -v ^\# /etc/X11/xorg.conf | grep DisplaySize
grep: /etc/X11/xorg.conf: No such file or directory
gx280:~ $ grep -v ^\# /etc/X11/xorg.conf.d/50-monitor.conf | grep PreferredMode
gx280:~ $ grep -v ^\# /etc/X11/xorg.conf | grep PreferredMode
grep: /etc/X11/xorg.conf: No such file or directory
gx280:~ $ grep -v ^\# /etc/X11/xinit/xinitrd.d/setup | grep xrandr
xrandr --dpi 120 --fb 1920x1200 --output VGA1 --mode 1600x1200 --panning 1920x1200 # intel analog
gx280:~ $ xrdb -query | grep dpi
gx280:~ $ xrandr | egrep 'onnect|creen|\*' | grep -v disconn | sort -r
VGA1 connected 1920x1200+0+0 (normal left inverted right x axis y axis) 388mm x 291mm panning 1920x1200+0+0
Screen 0: minimum 8 x 8, current 1920 x 1200, maximum 32767 x 32767
   1600x1200     85.00*   75.00    70.00    65.00    60.00
gx280:~ $ xdpyinfo | egrep 'dimen|ution'
  dimensions:    1920x1200 pixels (406x253 millimeters)
  resolution:    120x120 dots per inch

with KDE4 booting multi-user and running startx:
[   426.397] (++) using VT number 3
gx280:~ $ lspci | grep VGA
00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL Integrated Graphics Controller (rev 04)
gx280:~ $ grep PRETTY /etc/os-release
PRETTY_NAME="Fedora 22 (Rawhide)"
gx280:~ $ grep 'X.Org X Server' /var/log/Xorg.0.log
X.Org X Server 1.15.99.904 (1.16.0 RC 4)
gx280:~ $ grep 'Current Operating System' /var/log/Xorg.0.log
[   425.910] Current Operating System: Linux gx280 3.16.0-0.rc6.git1.1.fc22.i686+PAE #1 SMP Tue Jul 22 13:57:53 UTC 2014 i686
gx280:~ $ grep 'Kernel Command Line' /var/log/Xorg.0.log
[   425.910] Kernel command line: root=LABEL=f22p22 ipv6.disable=1 net.ifnames=0 selinux=0 noplymouth noresume splash=verbose vga=791 video=1024x768@60 3
gx280:~ $ grep Output /var/log/Xorg.0.log | egrep -v 'disconnec|no monit' | grep -v 'nitor sect'
[   426.428] (--) intel(0): Output VGA1 using initial mode 1024x768 on pipe 0
gx280:~ $ grep -v ^\# /etc/X11/xorg.conf.d/50-monitor.conf | grep DisplaySize
 DisplaySize    380 238 # 096 DPI @ 1440x0900
gx280:~ $ grep -v ^\# /etc/X11/xorg.conf | grep DisplaySize
grep: /etc/X11/xorg.conf: No such file or directory
gx280:~ $ grep -v ^\# /etc/X11/xorg.conf.d/50-monitor.conf | grep PreferredMode
gx280:~ $ grep -v ^\# /etc/X11/xorg.conf | grep PreferredMode
grep: /etc/X11/xorg.conf: No such file or directory
gx280:~ $ grep -v ^\# /etc/X11/xinit/xinitrd.d/setup | grep xrandr
xrandr --dpi 120 --output VGA1 --mode 1600x1200 # intel analog
gx280:~ $ xrdb -query | grep dpi
gx280:~ $ xrandr | egrep 'onnect|creen|\*' | grep -v disconn | sort -r
VGA1 connected 1600x1200+0+0 (normal left inverted right x axis y axis) 388mm x 291mm
Screen 0: minimum 8 x 8, current 1600 x 1200, maximum 32767 x 32767
   1600x1200     85.00*   75.00    70.00    65.00    60.00
gx280:~ $ xdpyinfo | egrep 'dimen|ution'
  dimensions:    1600x1200 pixels (338x253 millimeters)
  resolution:    120x120 dots per inch

No unexpected black screens here.
-- 
"The wise are known for their understanding, and pleasant
words are persuasive." Proverbs 16:21 (New Living Translation)

 Team OS/2 ** Reg. Linux User #211409 ** a11y rocks!

Felix Miata  ***  http://fm.no-ip.com/
