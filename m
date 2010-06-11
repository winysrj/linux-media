Return-path: <linux-media-owner@vger.kernel.org>
Received: from diplomat.digitalinscription.com ([203.82.214.162]:55189 "EHLO
	diplomat.digitalinscription.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754733Ab0FKCUo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jun 2010 22:20:44 -0400
Received: from lime.digitalinscription.com ([115.187.253.207] helo=[127.0.0.1])
	by diplomat.digitalinscription.com with esmtpa (Exim 4.69)
	(envelope-from <se456@rohan.id.au>)
	id 1OMtrN-0003sM-Bd
	for linux-media@vger.kernel.org; Fri, 11 Jun 2010 10:20:43 +0800
Message-ID: <4C119D72.6010802@rohan.id.au>
Date: Fri, 11 Jun 2010 10:20:34 +0800
From: Rohan Carly <se456@rohan.id.au>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: please update V4L-DVB wiki concerning Compro DVD-T300 support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I had success with some TV tuner hardware that wasn't listed on the 
linuxtv.org V4L-DVB wiki. Could you please update it?

The relevant section is here:
http://www.linuxtv.org/wiki/index.php/DVB-T_PCI_Cards#Compro

My device is a Compro DVD-T300 (purchased in Australia):

lime:~# lspci | grep -i "saa"
01:06.0 Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL Video 
Broadcast Decoder (rev 01)

I use Debian 5 (lenny) and it seemed to be detected fine when I installed the 
AMD64 kernel/system.
When I installed the 32-bit x86 kernel/system (using a 64bit cpu) detection 
didn't seem to be automatic anymore.

Symptom: after modprobe saa7134 ,     /dev/video0  was created, but not /dev/dvb

Solution...

After reading this website:
     http://en.gentoo-wiki.com/wiki/Saa7134
I discovered that I had to do instead
     modprobe saa7134 card=70

zcat 
/usr/share/doc/linux-doc-2.6.26/Documentation/video4linux/CARDLIST.saa7134.gz 
| grep -i "compro"
  19 -> Compro VideoMate TV                      [185b:c100]
  40 -> Compro VideoMate TV PVR/FM               [185b:c100]
  41 -> Compro VideoMate TV Gold+                [185b:c100]
  49 -> Compro VideoMate Gold+ Pal               [185b:c200]
  62 -> Compro VideoMate TV Gold+II
  70 -> Compro Videomate DVB-T300                [185b:c900]
  71 -> Compro Videomate DVB-T200                [185b:c901]
103 -> Compro Videomate DVB-T200A
139 -> Compro VideoMate T750                    [185b:c900]

Hope this helps some people,

Rohan Carly.

