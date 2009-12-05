Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56170 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbZLEQHr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2009 11:07:47 -0500
Received: by yxe17 with SMTP id 17so2863478yxe.33
        for <linux-media@vger.kernel.org>; Sat, 05 Dec 2009 08:07:53 -0800 (PST)
From: jim <jiminycricket180@gmail.com>
To: linux-media@vger.kernel.org
Subject: help with cx88 blackbird
Date: Sat, 5 Dec 2009 10:07:49 -0600
MIME-Version: 1.0
Message-Id: <4b1a8558.e302be0a.7512.ffffcbfa@mx.google.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I need some help trying to get a second tuner card setup, the card is a Kworld 
mce 201, it has a conexant cx23416-12 and a conexant 23880-19 chips the 
tuner is a TNJ7751-MFF . I am running Ubuntu 8.04 with mythtv fixes .21.

The card is found as an anolog V4l capture card by mythtv but the Mpeg-2 
encoder part isnt found. Dmesg says that the card type is unknown and to add 
it to the modeprobe.d options file, but I am unsure witch card to choose, I 
have tried card 45 which loads it as device video3 ( I have to manually enter 
the video device number in mythtv backend to make it show the probed info) 
but when I switch to this tuner on a frontend it just sits on a black screen 
for a few minutes then returns to the mythtv menu. I can use Mplayer from the 
command line using mplayer -vo xv /dev/video3 the Mplayer window opens but 
all I get is colored snow.

In case it matters my other cards that work with mythtv are a Hauppauge PVR 
350 and an ATI TV Wonder dvb card. any help with this would be appreciated.
