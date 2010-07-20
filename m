Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:35533 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758507Ab0GTNFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 09:05:53 -0400
Date: Tue, 20 Jul 2010 15:06:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-i2c@vger.kernel.org
cc: ibrahima sakho <ibrahima_sakho@hotmail.com>
Subject: HELP: Interface a CMOS sensor with the DM355 (fwd)
Message-ID: <Pine.LNX.4.64.1007201504190.29807@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Forwarding on authors's behalf.

Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

---------- Forwarded message ----------
Date: Tue, 20 Jul 2010 11:01:36 +0200
From: ibrahima sakho <ibrahima_sakho@hotmail.com>
Subject: HELP: Interface a CMOS sensor with the DM355


Hello,

I come towards you because I work at present on the interfacing between 
the demo board DM355 and the CMOS sensor MT9J003 from Micron (Aptina) to 
make of the video. I use the Arago project for it.

The problem which I have is situated at the configuration of the I2C bus. 
Indeed, the register address of the CMOS sensor MT9J003 is on 16 bits and 
I do not succeed in communicating via this bus. I am parit of the driver 
that you developed for the MT9T031, but without succés. The communication 
with the sensor is of this kind:

I2C Block Read (2 Comm bytes)
=============================

  
This command reads a block of bytes from a device, from a 
designated register that is specified through the two Comm byte.

S Addr Wr [A] Comm1 [A] Comm2 [A] S Addr Rd [A] [Data] A [Data] A ... A [Data] NA P

Is this I2C function  implemented in the I2C module ? 

May I use Arago project to manage to configure this I2C communication ? I 
shall really need your help and your councils.

I thank you beforehand. 

Ibrahima SAKHO

 		 	   		  
_________________________________________________________________
Le nouveau Hotmail est presque arrivé, ne le manquez pas !
http://www.windowslive.fr/nouveau-hotmail/
