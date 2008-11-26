Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jyrki.n@telia.com>) id 1L5Jj3-0001t1-F0
	for linux-dvb@linuxtv.org; Wed, 26 Nov 2008 13:42:39 +0100
Received: from [192.168.128.36] (90.228.209.229) by
	pne-smtpout1-sn1.fre.skanova.net (7.3.129) (authenticated as
	u49403269) id 47A9795004E45C9B for linux-dvb@linuxtv.org;
	Wed, 26 Nov 2008 13:42:03 +0100
Message-ID: <492D441D.1050108@telia.com>
Date: Wed, 26 Nov 2008 13:42:05 +0100
From: Jyrki Niskala <jyrki.n@telia.com>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Can't get signal lock with Hauppauge Nova TD-500
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

Hello

I'm stucked here with a problem with a new Hauppauge card called Nova 
TD-500.
When tuning, I got lock on 4 of 5 muxes.  The fifth, non working mux, is 
at 778 MHz.
It's same behaviour on both tuners, with tzap or MythTV,  with or 
without lna option.
I have also tried with another computer with same result.
The signal is not a problem. I have 3 other dvb-t cards up and running 
for the moment...
All muxes are from 538 MHz to 778 MHz (64 QAM, 8 MHz bandwith, 8k 
transmission mode)

Some more information/dump ...

lsusb gives:
Bus 002 Device 002: ID 2040:8400 Hauppauge
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x2040 Hauppauge
  idProduct          0x8400
  bcdDevice            1.00
  iManufacturer           1 Hauppauge
  iProduct                2 WinTV Nova-DT
  iSerial                 3 4031669132
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

a good tzap gives...

DiB0070: Tuning for Band: 2 (754000 kHz)
DiB0070: HFDIV code: 1
DiB0070: VCO = 1
DiB0070: VCOF in kHz: 6032000 ((4*754000) << 1))
DiB0070: REFDIV: 1, FREF: 12000
DiB0070: FBDIV: 125, Rest: 43520
DiB0070: Num: -22016, Den: 255, SD: 1
DiB0070: CAPTRIM=64; ADC = 33 (ADC) & 58mV
DiB0070: CAPTRIM=64 is closer to target (367/3000)
DiB0070: CAPTRIM=96; ADC = 989 (ADC) & 1738mV
DiB0070: CAPTRIM=80; ADC = 989 (ADC) & 1738mV
DiB0070: CAPTRIM=72; ADC = 251 (ADC) & 441mV
DiB0070: CAPTRIM=72 is closer to target (149/367)
DiB0070: CAPTRIM=76; ADC = 687 (ADC) & 1207mV
DiB0070: CAPTRIM=74; ADC = 366 (ADC) & 643mV
DiB0070: CAPTRIM=74 is closer to target (34/149)
DiB0070: CAPTRIM=75; ADC = 464 (ADC) & 815mV
DiB7000P: SPLIT df392800: 87
DiB7000P: using updated timf
DiB7000P: updated timf_frequency: 20451948 (default: 20452225)
DiB7000P: relative position of the Spur: 2000k (RF: 754000k, XTAL: 12000k)
DiB7000P: PALF COEF: 0 re: 25 im: 124
DiB7000P: PALF COEF: 1 re: -103 im: 43
DiB7000P: PALF COEF: 2 re: -52 im: -79
DiB7000P: PALF COEF: 3 re: 54 im: -53
DiB7000P: PALF COEF: 4 re: 45 im: 30
DiB7000P: PALF COEF: 5 re: -11 im: 28
DiB7000P: PALF COEF: 6 re: -5 im: 0
DiB7000P: PALF COEF: 7 re: 0 im: 19
DiB7000P: using updated timf
DiB7000P: setting output mode for demod df392800 to 5

and a failed tzap (no lock)

DiB0070: Tuning for Band: 2 (778000 kHz)
DiB0070: HFDIV code: 1
DiB0070: VCO = 1
DiB0070: VCOF in kHz: 6224000 ((4*778000) << 1))
DiB0070: REFDIV: 1, FREF: 12000
DiB0070: FBDIV: 129, Rest: 43520
DiB0070: Num: -22016, Den: 255, SD: 1
DiB0070: CAPTRIM=64; ADC = 988 (ADC) & 1736mV
DiB0070: CAPTRIM=64 is closer to target (588/3000)
DiB0070: CAPTRIM=32; ADC = 34 (ADC) & 59mV
DiB0070: CAPTRIM=32 is closer to target (366/588)
DiB0070: CAPTRIM=48; ADC = 34 (ADC) & 59mV
DiB0070: CAPTRIM=56; ADC = 204 (ADC) & 358mV
DiB0070: CAPTRIM=56 is closer to target (196/366)
DiB0070: CAPTRIM=60; ADC = 441 (ADC) & 775mV
DiB0070: CAPTRIM=60 is closer to target (41/196)
DiB0070: CAPTRIM=58; ADC = 282 (ADC) & 495mV
DiB0070: CAPTRIM=59; ADC = 336 (ADC) & 590mV
DiB7000P: SPLIT df392800: 128
DiB7000P: using updated timf
DiB7000P: relative position of the Spur: 2000k (RF: 778000k, XTAL: 12000k)
DiB7000P: PALF COEF: 0 re: 25 im: 124
DiB7000P: PALF COEF: 1 re: -103 im: 43
DiB7000P: PALF COEF: 2 re: -52 im: -79
DiB7000P: PALF COEF: 3 re: 54 im: -53
DiB7000P: PALF COEF: 4 re: 45 im: 30
DiB7000P: PALF COEF: 5 re: -11 im: 28
DiB7000P: PALF COEF: 6 re: -5 im: 0
DiB7000P: PALF COEF: 7 re: 0 im: 19
DiB7000P: using updated timf
DiB7000P: setting output mode for demod df392800 to 5

Best regards
/ Jyrki


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
