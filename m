Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34778 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbZBJVOg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 16:14:36 -0500
Message-ID: <4991EE34.3040507@iki.fi>
Date: Tue, 10 Feb 2009 23:14:28 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Tanguy Pruvot <tanguy.pruvot@gmail.com>
CC: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] EC168
References: <457563803.20081123042151@gmail.com> <1766329077.20081126030346@gmail.com>
In-Reply-To: <1766329077.20081126030346@gmail.com>
Content-Type: text/plain; charset=windows-1250; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tanguy Pruvot wrote:
> #define CMD_EC168_RAM       0x00 //RW- Read/Write RAM (Firmware go to addr 0-0x1EFF)
> #define CMD_EC168_GETSTATUS 0x01 //R-- ex: dfu_ctrl_get(device,0x01,0x0000,0x01A0,buffer,0x1A);
> #define CMD_EC168_STREAM    0x03 //R-X ex: dfu_ctrl(device,0x03,0/0x20,0xFF00);
>                                  //    disable/enable streaming 
> #define CMD_EC168_SET_POWER 0x04 //--X ex: dfu_ctrl(device,0x04,0/1,0x0008);
>                                  //    disable/enable LED
>                                  //    indexes seen: 206,208,8,9,A,B
> #define CMD_EC168_UNKNOWN   0x10 //--X ???
> #define CMD_EC168_READ_BUF  0x20 //R-- ex: dfu_ctrl_get(device,0x20,0x0000,0x01A0,buffer,0x1A); 
> #define CMD_EC168_WRITE_BUF 0x21 //-W- 
> #define CMD_EC168_SET       0x30 //--X ex: dfu_ctrl(device, 0x30, 0x0709, 0x1A);

Are you still hacking that device?
I tried to order Intel CE6230 device but got EC168 (SinoVideo 3420A-2). 
I take one USB-sniff and here are commands as I think:

00 firmware download
01 ? config
03 demodulator
04 ? GPIO (LED)
10 streaming control
20 I2C read
21 I2C write
30 HID table download

Looks like EC168 has EC100 demodulator integrated. And programming this 
demodulator seems to be rather easy, not very many bytes...

regards
Antti
-- 
http://palosaari.fi/
