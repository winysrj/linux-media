Return-path: <linux-media-owner@vger.kernel.org>
Received: from flamewarestudios.plus.com ([212.159.53.145]:58926 "EHLO
        exchange02.cblinux.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdL0Puv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Dec 2017 10:50:51 -0500
From: Carl Brunning <carlb@cblinux.co.uk>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: help need for getting CXD2837 to scan dvb-t on blackgold 3600 cards
Date: Wed, 27 Dec 2017 15:50:49 +0000
Message-ID: <cf418aebff994a7b923cfd2447388f88@exchange02.cblinux.co.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All

I've been working on getting blackgold 3600/3602 tv card working
They have older driver drivers that over the last few year I've been updating for people 
but was missing the CXD2837 code which I was able to add
This allow the turner to been seen .

The problem I have is am not able to get the dvb-t to scan and lock on channel 
So my question is what part of the code do I need to look at for getting the tuner to lock

The card use saa7231 pci chip, two cxd2837 for two dvb-t/a(tda18272) and dual stvo90x for sat (this part works)
If anyone want to check the code you find my git here
http://www.cblinux.co.uk:5010/BGT3xxx-fork-for-cxd2837
am using the cxd2843 driver that supports the 2837 from DigitalDevice dddvb branch 
I did try the cxd 2841er driver but could not even get i2c to even talk. 

if anyone want to help I have a box with a card in and can give access 

I have to say thanks to all the people whose code I've used in this driver and bug fixes over the year 

All I would like is to get the dvb-t working and make lots of people with the card to be happy and that includes me as well.

If you need more information say what you need and I get 


Thanks
Carl Brunning
