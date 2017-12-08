Return-path: <linux-media-owner@vger.kernel.org>
Received: from amazone.ujf-grenoble.fr ([193.54.238.254]:25957 "EHLO
        amazone.ujf-grenoble.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752165AbdLHRuE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 12:50:04 -0500
Received: from tana1.ujf-grenoble.fr (tana1.ujf-grenoble.fr [193.54.238.230])
        by amazone.ujf-grenoble.fr (Postfix) with ESMTP id 3ytfmY6x9Vz8Yx2
        for <linux-media@vger.kernel.org>; Fri,  8 Dec 2017 18:41:49 +0100 (CET)
Received: from tibre3.ujf-grenoble.fr (tibre3.ujf-grenoble.fr [152.77.18.90])
        by tana1.ujf-grenoble.fr (Postfix) with ESMTP id DD02F2E047
        for <linux-media@vger.kernel.org>; Fri,  8 Dec 2017 18:41:41 +0100 (CET)
Received: from lthe-srv-29.ujf-grenoble.fr (lthe-srv-29.ujf-grenoble.fr [152.77.121.29])
        by tibre3.ujf-grenoble.fr (8.14.3/8.14.3/SyS-1.11) with ESMTP id vB8HfjCR096286
        for <linux-media@vger.kernel.org>; Fri, 8 Dec 2017 18:41:47 +0100 (CET)
        (envelope-from frederic.parrenin@univ-grenoble-alpes.fr)
Received: from [192.168.1.41] (unknown [88.179.50.65])
        by lthe-srv-29.ujf-grenoble.fr (Postfix) with ESMTPSA id 4EC6A88040
        for <linux-media@vger.kernel.org>; Fri,  8 Dec 2017 18:41:45 +0100 (CET)
To: linux-media@vger.kernel.org
From: =?UTF-8?Q?Fr=c3=a9d=c3=a9ric_Parrenin?=
        <frederic.parrenin@univ-grenoble-alpes.fr>
Subject: webcams not recognized on a Dell Latitude 5285 detachable laptop
Message-ID: <359fc9d6-6f83-3228-bcb2-790b1e5ab9ef@univ-grenoble-alpes.fr>
Date: Fri, 8 Dec 2017 18:41:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

I recently installed debian 9 and ubuntu 17.10 on a Dell Latitude 5285 
detachable laptop.

I problem I have is that the webcams (both the rear one and the front 
one) are not recognized.
There is no /dev/video* file.

I am not sure what is the model of the webcam.
The Dell support website for this laptop mentions a Realtek IR webcam:

http://www.dell.com/support/home/fr/fr/frbsdt1/product-support/product/latitude-12-5285-2-in-1-laptop/drivers

Below are my lspci and lsusb outputs, under ubuntu 17.10, kernel 4.14.
It is not clear to me which line refer to the webcam.

Thank you for your help!

Frédéric

:~$ lspci
00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v6/7th Gen Core 
Processor Host Bridge/DRAM Registers (rev 02)
00:02.0 VGA compatible controller: Intel Corporation HD Graphics 620 
(rev 02)
00:04.0 Signal processing controller: Intel Corporation Skylake 
Processor Thermal Subsystem (rev 02)
00:05.0 Multimedia controller: Intel Corporation Skylake Imaging Unit 
(rev 01)
00:13.0 Non-VGA unclassified device: Intel Corporation Device 9d35 (rev 21)
00:14.0 USB controller: Intel Corporation Sunrise Point-LP USB 3.0 xHCI 
Controller (rev 21)
00:14.2 Signal processing controller: Intel Corporation Sunrise Point-LP 
Thermal subsystem (rev 21)
00:14.3 Multimedia controller: Intel Corporation Device 9d32 (rev 01)
00:15.0 Signal processing controller: Intel Corporation Sunrise Point-LP 
Serial IO I2C Controller #0 (rev 21)
00:15.1 Signal processing controller: Intel Corporation Sunrise Point-LP 
Serial IO I2C Controller #1 (rev 21)
00:15.2 Signal processing controller: Intel Corporation Sunrise Point-LP 
Serial IO I2C Controller #2 (rev 21)
00:16.0 Communication controller: Intel Corporation Sunrise Point-LP 
CSME HECI #1 (rev 21)
00:1c.0 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root 
Port #5 (rev f1)
00:1c.7 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root 
Port #8 (rev f1)
00:1d.0 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root 
Port #9 (rev f1)
00:1f.0 ISA bridge: Intel Corporation Device 9d4e (rev 21)
00:1f.2 Memory controller: Intel Corporation Sunrise Point-LP PMC (rev 21)
00:1f.3 Audio device: Intel Corporation Device 9d71 (rev 21)
00:1f.4 SMBus: Intel Corporation Sunrise Point-LP SMBus (rev 21)
01:00.0 Non-Volatile memory controller: Toshiba America Info Systems 
Device 0116
02:00.0 Network controller: Intel Corporation Wireless 8265 / 8275 (rev 78)
03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS525A 
PCI Express Card Reader (rev 01)


:~$ lsusb
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 003: ID 8087:0a2b Intel Corp.
Bus 001 Device 004: ID 044e:1218 Alps Electric Co., Ltd
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
