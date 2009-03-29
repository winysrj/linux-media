Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39444 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbZC2LyL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 07:54:11 -0400
Message-ID: <49CF6157.1050807@iki.fi>
Date: Sun, 29 Mar 2009 14:53:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olivier MENUEL <olivier.menuel@free.fr>,
	Laurent Haond <lhaond@bearstech.com>
CC: linux-media@vger.kernel.org
Subject: Re: AverMedia Volar Black HD (A850)
References: <200903291334.00879.olivier.menuel@free.fr>
In-Reply-To: <200903291334.00879.olivier.menuel@free.fr>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Olivier MENUEL wrote:
> Hi,
> 
> Does anyone knows how to get this card work on linux : AverMedia Volar Black HD (A850)
> lsusb id is : 07ca:850a
> 
> I tried this project : http://linuxtv.org/hg/~anttip/af9015_aver_a850/ which seems to be specifically for this card but it does not work (The .num_device_descs has not been correctly set).
> I tried to fix the .num_device_descs and also tried to add my card in the af9015.c file of the official v4l-dvb project.
> 
> My card is now correctly detected and dirs are created in the /dev/dvb, but it seems initialization fails :
> 
  > I guess the problem is here :  [ 1164.478066] af9015: command failed:2

No it is not biggest problem - it only says that 2nd FE (you have dual 
tuner) will be disabled because it fails.

> It's probably a firmware issue, I'm using this firmware http://otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/
> I'm completely stuck and have no idea what else could be done.

The main problem seems to be that AverMedia does not use standard nor 
reference settings. That's very typical in case of AverMedia, I don't 
know why...
Someone should find correct settings used from usb-sniffs and configure 
that device as needed. It is a little bit hard for me add support 
because I don't have device. But I can try to look sniff and guess what 
should be changed.

I was waiting for if Laurent can fix that device. Laurent, are you still 
working with that?

Sniffs are welcome.

regards
Antti
-- 
http://palosaari.fi/
