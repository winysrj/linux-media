Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lbraglia@gmail.com>) id 1K588B-0007yf-BD
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 01:47:32 +0200
Received: by mu-out-0910.google.com with SMTP id w8so1041829mue.1
	for <linux-dvb@linuxtv.org>; Sat, 07 Jun 2008 16:47:27 -0700 (PDT)
Resent-Message-ID: <20080607234748.GA6284@eeepc>
Date: Sun, 8 Jun 2008 01:44:03 +0200
From: Luca Braglia <lbraglia@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <20080607234403.GA6259@eeepc>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Help with Pinnacle PCTV usb nano stick
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

Hello everybody.

I've tried to follow the doc installing Pinnacle pctv uswb nano
stick on my Debian EEEPC, but failed.
This is how I did it.
Can you help me please?

Please, CC me because I'm not subscribed to the list!


[18:55:54] luca@eeepc: sudo lsusb 
..
Bus 005 Device 005: ID 2304:0237 Pinnacle Systems, Inc. [hex] 
..


from sudo lsusb -v

Bus 005 Device 006: ID 2304:0237 Pinnacle Systems, Inc. [hex] 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x2304 Pinnacle Systems, Inc. [hex]
  idProduct          0x0237 
  bcdDevice            1.00
  iManufacturer           1 Pinnacle
  iProduct                2 PCTV 73e
  iSerial                 3 0000000M81L1IGG
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)



Some preliminaries
------------------
sudo apt-get install build-essential linux-headers-$(uname -r)


Driver
------
wget http://linuxtv.org/hg/v4l-dvb/archive/tip.tar.bz2

tar xvjf tip.tar.bz2
cd v4l [press TAB]
make
sudo make install

if i plug the usb pctv

usb 5-3: new high speed USB device using ehci_hcd and address 6
usb 5-3: configuration #1 chosen from 1 choice
dib0700: loaded with support for 7 different device-types
dvb-usb: found a 'Pinnacle PCTV 73e' in cold state, will try to load a firmware
dvb-usb: did not find the firmware file. (dvb-usb-dib0700-1.10.fw) Please see linux/Documentation/dvb/ for more details on firmware-problems. (-2)
usbcore: registered new interface driver dvb_usb_dib0700


Firmware
--------
wget http://www.wi-bw.tfh-wildau.de/~pboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw

sudo cp dvb-usb-dib0700-1.10.fw /lib/firmware

again re-put the usb pctv and...

usb 5-3: new high speed USB device using ehci_hcd and address 7
usb 5-3: configuration #1 chosen from 1 choice
dvb-usb: found a 'Pinnacle PCTV 73e' in cold state, will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Pinnacle PCTV 73e' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Pinnacle PCTV 73e)
DVB: registering frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
input: IR-receiver inside an USB DVB receiver as /class/input/input9
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: Pinnacle PCTV 73e successfully initialized and connected.


I also notice that a blue light appear on the key. We get
also the interface files dir

[01:27:53] luca@eeepc: ls -l /dev/dvb/adapter0/
totale 0
crw-rw---- 1 root video 212, 4  8 giu 00:10 demux0
crw-rw---- 1 root video 212, 5  8 giu 00:10 dvr0
crw-rw---- 1 root video 212, 3  8 giu 00:10 frontend0
crw-rw---- 1 root video 212, 7  8 giu 00:10 net0

I have to check frequencies so i've scanned
all of which are included in it-* files (i'm italian)

cd /usr/share/doc/dvb-utils/examples/scan
for file in `ls -l it-*`; \
    do scan $file >> $HOME/.tzap/channel.conf

waited a lot ...  I used also wscan

wget http://wirbel.htpc-forum.de/w_scan/w_scan-20080105.tar.bz2
tar xvjf w_scan-20080105.tar.bz2
cd w_scan [Press tab]
make

./w_scan -x > asd

Now I use scan, put togheter with other frequencies founded,
sort'n uniq'n save

scan asd >> qwerty
cat qwerty >> $HOME/.tzap/channels.conf
cd  $HOME/.tzap
sort channels.conf |uniq > asd
mv asd channels.conf

I'm ready for tzap: i can see all channels with

sed -e 's/:.*//g'  $HOME/.tzap/channels.conf

so i've tried with

MTV:610000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO:0:0:203

tzap -r "MTV"

but I get only, 

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
ERROR: error while parsing constellation (syntax error)

some tests

[01:18:28] luca@eeepc: dvbtraffic 

^C

dvbtraffic is "dead"

[01:24:49] luca@eeepc: dvbsnoop -s pidscan
dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/ 

---------------------------------------------------------
Transponder PID-Scan...
---------------------------------------------------------
[01:24:49] luca@eeepc:


dvbsnoop too

Kernel seems to recognize the hardware and my channels.conf
have reasonable (local important and known) channels, founded
normally by scan & w_scan, so where do i make mistakes??
Is pinnacle pctv nano stick still to young?

Thanks Luca

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
