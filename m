Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39066 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1EEWuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 18:50:17 -0400
Received: by iyb14 with SMTP id 14so2209917iyb.19
        for <linux-media@vger.kernel.org>; Thu, 05 May 2011 15:50:17 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-2?Q?Wojciech_Dal=EAtka?= <webmaster@nadaje.com>
Date: Fri, 6 May 2011 00:42:26 +0200
Message-ID: <BANLkTimz1X+FoT1dFHnxh7fQMrMB7p8WLg@mail.gmail.com>
Subject: h826d
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
I've got a problem with an USB Capture Device:
AVerTV Hybrid Volar HX

System: ubuntu 11.04
Kernel: linux-headers-2.6.38-8-generic-pae

I did everything co compile the driver, according to:
http://www.linuxtv.org/wiki/index.php/AVerMedia_AverTV_Hybrid_Volar_HX_(A827)

But afteall I get this error in dmesg:
[ 9506.533260] h826d: Unknown symbol param_array_ops.param_array_ops (err 0)
(I did hex edit the file osdep_dvb.o_shipped as it was recommended)

Is it possible to run this card on ubuntu 11.04?

-- 
Wojciech Dalętka
http://nadaje.com
