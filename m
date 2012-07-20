Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:47254 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753735Ab2GTN0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 09:26:42 -0400
Message-ID: <1342790769.2231.14.camel@tbastian-desktop.localdomain>
Subject: Terratec Cinergy XS 0ccd:0042 (em28xx): Tuning Problem Analog
From: "llarevo@gmx.net" <llarevo@gmx.net>
To: linux-media@vger.kernel.org
Date: Fri, 20 Jul 2012 15:26:09 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have tuning problem for some analog channels with the Terratec Cinergy
XS 0ccd:0042. This card is unable to tune into some channels. 

I have another version of this hardware with the ID's 0ccd:005e.
Interestingly, this Hardware-Version tunes without any problems all
available channels. 

Some channels are not found, but this seems to be not really correlated
with the frequency, although many of the not found channels are at lower
frequencies (PAL-BG, channel-list is europe-west):

0ccd:005e                 00cd:0042
E6   (182.25 MHz): ???    E6   (182.25 MHz): no station
E7   (189.25 MHz): ???    E7   (189.25 MHz): no station
E8   (196.25 MHz): ???    E8   (196.25 MHz): no station
E9   (203.25 MHz): ???    E9   (203.25 MHz): no station
SE6  (140.25 MHz): ???    SE6  (140.25 MHz): no station
SE7  (147.25 MHz): ???    SE7  (147.25 MHz): no station
SE8  (154.25 MHz): ???    SE8  (154.25 MHz): no station
SE9  (161.25 MHz): ???    SE9  (161.25 MHz): no station
SE10 (168.25 MHz): ???    SE10 (168.25 MHz): no station
SE11 (231.25 MHz): ???    SE11 (231.25 MHz): no station

For a complete station-list compare the scantv output attached below.

According to
http://www.kernel.org/doc/Documentation/video4linux/CARDLIST.tuner I
created a parameter file for the proper tuner-setting:

cat /etc/modprobe.d/tuner_xc2028.conf
tuner=71

But this does not solve the problem. 

The firmware I use is
-rw-r--r-- 1 root root 65K 11. Jul 21:17 /lib/firmware/xc3028-v27.fw

The problem occurs both with Fedora 17 and Ubuntu 10.04.

What could I try next? Any help is appreciated.

Thanks
-- 
Felix



Hardware-Version: 0ccd:005e
scanning channel list europe-west...
E2   ( 48.25 MHz): no station
E3   ( 55.25 MHz): no station
E4   ( 62.25 MHz): no station
S01  ( 69.25 MHz): no station
S02  ( 76.25 MHz): no station
S03  ( 83.25 MHz): no station
E5   (175.25 MHz): no station
E6   (182.25 MHz): ???
E7   (189.25 MHz): ???
E8   (196.25 MHz): ???
E9   (203.25 MHz): ???
E10  (210.25 MHz): ???
E11  (217.25 MHz): ???
E12  (224.25 MHz): ???
SE1  (105.25 MHz): no station
SE2  (112.25 MHz): no station
SE3  (119.25 MHz): no station
SE4  (126.25 MHz): no station
SE5  (133.25 MHz): no station
SE6  (140.25 MHz): ???
SE7  (147.25 MHz): ???
SE8  (154.25 MHz): ???
SE9  (161.25 MHz): ???
SE10 (168.25 MHz): ???
SE11 (231.25 MHz): ???
SE12 (238.25 MHz): ???
SE13 (245.25 MHz): ???
SE14 (252.25 MHz): ???
SE15 (259.25 MHz): ???
SE16 (266.25 MHz): ???
SE17 (273.25 MHz): ???
SE18 (280.25 MHz): ???
SE19 (287.25 MHz): ???
SE20 (294.25 MHz): ???
S21  (303.25 MHz): ???
S22  (311.25 MHz): ???
S23  (319.25 MHz): ???
S24  (327.25 MHz): ???
S25  (335.25 MHz): ???
S26  (343.25 MHz): no station
S27  (351.25 MHz): no station
S28  (359.25 MHz): no station
S29  (367.25 MHz): no station
S30  (375.25 MHz): no station
S31  (383.25 MHz): no station
S32  (391.25 MHz): no station
S33  (399.25 MHz): no station
S34  (407.25 MHz): no station
S35  (415.25 MHz): no station
S36  (423.25 MHz): no station
S37  (431.25 MHz): no station
S38  (439.25 MHz): no station
S39  (447.25 MHz): no station
S40  (455.25 MHz): no station
S41  (463.25 MHz): no station
21   (471.25 MHz): no station
22   (479.25 MHz): ???
23   (487.25 MHz): ???
24   (495.25 MHz): ???
25   (503.25 MHz): ???
26   (511.25 MHz): ???
(...)




Hardware-Version: 0ccd:0042
scanning channel list europe-west...
E2   ( 48.25 MHz): no station
E3   ( 55.25 MHz): no station
E4   ( 62.25 MHz): no station
S01  ( 69.25 MHz): no station
S02  ( 76.25 MHz): no station
S03  ( 83.25 MHz): no station
E5   (175.25 MHz): no station
E6   (182.25 MHz): no station
E7   (189.25 MHz): no station
E8   (196.25 MHz): no station
E9   (203.25 MHz): no station
E10  (210.25 MHz): ???
E11  (217.25 MHz): ???
E12  (224.25 MHz): ???
SE1  (105.25 MHz): no station
SE2  (112.25 MHz): no station
SE3  (119.25 MHz): no station
SE4  (126.25 MHz): no station
SE5  (133.25 MHz): no station
SE6  (140.25 MHz): no station
SE7  (147.25 MHz): no station
SE8  (154.25 MHz): no station
SE9  (161.25 MHz): no station
SE10 (168.25 MHz): no station
SE11 (231.25 MHz): no station
SE12 (238.25 MHz): ???
SE13 (245.25 MHz): ???
SE14 (252.25 MHz): ???
SE15 (259.25 MHz): ???
SE16 (266.25 MHz): ???
SE17 (273.25 MHz): ???
SE18 (280.25 MHz): ???
SE19 (287.25 MHz): ???
SE20 (294.25 MHz): ???
S21  (303.25 MHz): ???
S22  (311.25 MHz): ???
S23  (319.25 MHz): ???
S24  (327.25 MHz): ???
S25  (335.25 MHz): ???
S26  (343.25 MHz): no station
S27  (351.25 MHz): no station
S28  (359.25 MHz): no station
S29  (367.25 MHz): no station
S30  (375.25 MHz): no station
S31  (383.25 MHz): no station
S32  (391.25 MHz): no station
S33  (399.25 MHz): no station
S34  (407.25 MHz): no station
S35  (415.25 MHz): no station
S36  (423.25 MHz): no station
S37  (431.25 MHz): no station
S38  (439.25 MHz): no station
S39  (447.25 MHz): no station
S40  (455.25 MHz): no station
S41  (463.25 MHz): no station
21   (471.25 MHz): no station
22   (479.25 MHz): ???
23   (487.25 MHz): ???
24   (495.25 MHz): ???
25   (503.25 MHz): ???
26   (511.25 MHz): ???
(...)



