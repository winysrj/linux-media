Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <chancleta@gmail.com>) id 1JsKem-00055x-3g
	for linux-dvb@linuxtv.org; Sat, 03 May 2008 18:32:22 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1343907rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 03 May 2008 09:31:57 -0700 (PDT)
Message-ID: <a4ac2da80805030931i5148233fx557b3e259fa55f58@mail.gmail.com>
Date: Sat, 3 May 2008 18:31:57 +0200
From: "Daniel Guerrero" <chancleta@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] HVR 4000 and gspca webcam working; real or just a joke??
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

Hi,
after searching a lot and trying a lot, Im stooped at this point, I
cannot get working together over Ubuntu 8.04 or other distribution the
HVR4000 card and a normal webcam with gspca drivers. If someone get it
working together please help us.

Next you can find what I did, only to get HVR4000 working (thanks
Ian), but the gspca drivers give now some symbol errors. I read al lot
of times that is a well known problem and that make kernel-links in
the v4l-dvb tree and recompile a new kernel should work. But not for
me, maybe Im doing something wrong. I followed the steps on the next
link that work for them with another card.
http://gkiagia.freehostia.com/2008/02/09/installing-avermedia-m115-drivers-on-ubuntudebian/

What I did and dont work:

install fresh ubuntu 8.04
sudo apt-get install mercurial patch
wget ftp://167.206.143.11/outgoing/Oxford/88x_2_119_25023_WHQL.zip
unzip -jo 88x_2_119_25023_WHQL.zip Driver88/hcw88bda.sys
dd if=hcw88bda.sys of=/lib/firmware/dvb-fe-cx24116.fw skip=81768 bs=1
count=32522
sudo rm -r /lib/modules/2.6.24-16-generic/ubuntu/media/cx88
hg clone -r 127f67dea087 http://linuxtv.org/hg/v4l-dvb
wget http://dev.kewl.org/hauppauge/mfe-7285.diff
patch -d v4l-dvb -p1 < mfe-7285.diff
cd v4l-dvb
sudo make
sudo make install
mkdir /dev/dvb/adapter1
ln -s /dev/dvb/adapter0/frontend1 /dev/dvb/adapter1/frontend0
ln -s /dev/dvb/adapter0/net1 /dev/dvb/adapter1/net0
ln -s /dev/dvb/adapter0/dvr1 /dev/dvb/adapter1/dvr0
ln -s /dev/dvb/adapter0/demux1 /dev/dvb/adapter1/demux0
reboot

at this point the tv card works very well but I get the symbol errors
on dmesg regarding gspca.
So now I tried:

sudo apt-get install build-essential linux-source-2.6 libncurses5-dev
kernel-package mercurial
Now, let's prepare the kernel.
$ cd /usr/src
$ sudo tar xvjf linux-source*.tar.bz2
$ cd linux-source-<press tab to autocomplete the version>
$ sudo cp /boot/config-`uname -r` .config
$ cd v4l-dvb
$ SRCDIR=/usr/src/linux-source-<version> sudo make kernel-links
Now the kernel is patched. We now have to configure it if it is necessary.
$ cd /usr/src/linux-source-<version>
$ sudo make menuconfig
This will open the menuconfig ncurses dialog and will let you
configure the kernel. Normally, you don't need to touch anything
except the video4linux configuration. Go to "Device Drivers" ->
"Multimedia Devices" and select any drivers you need. To select a
driver, highlight it and press M.
I select everything there. (I also tried diferent combinations)
$ sudo make-kpkg clean
$ sudo make-kpkg --initrd --append_to_version .mykernel kernel_image
kernel_headers
When you have finished compiling, you can install the new kernel.
$ cd ..
$ sudo dpkg -i linux-*.deb
reboot

after restart ubuntu doesnt recognise my tv card
I built the last gspca stable drivers
cd /usr/src/gspcav1-20071224
./gspca_build

and now the webcam works but if try to make again the v4l-dvb drivers
above I loose again the webcam. :-(

thanks for your help,
Daniel

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
