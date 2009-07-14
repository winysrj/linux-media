Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw2.jenoptik.com ([213.248.109.130]:54235 "EHLO
	mailgw2.jenoptik.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbZGNQ6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 12:58:44 -0400
Date: Tue, 14 Jul 2009 18:58:26 +0200
From: "Jesko Schwarzer" <jesko.schwarzer@jena-optronik.de>
To: "'Zach LeRoy'" <zleroy@rii.ricoh.com>
cc: "'linux-media'" <linux-media@vger.kernel.org>,
	"'linux-omap'" <linux-omap@vger.kernel.org>
Message-ID: <"4430.36201247590721.hermes.jena-optronik.de*"@MHS>
In-Reply-To: <15157053.23861247590158808.JavaMail.root@mailx.crc.ricoh.com>
Subject: AW: Problems configuring OMAP35x ISP driver
MIME-Version: 1.0
Content-Type: text/plain;
 	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Zach,

unfortunately I cannot help you, but maybe you can tell me what driver you
use? Where I can find it?

Thanks in advance
/Jesko

-----Ursprüngliche Nachricht-----
Von: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] Im Auftrag von Zach LeRoy
Gesendet: Dienstag, 14. Juli 2009 18:49
An: Aguirre Rodriguez, Sergio
Cc: linux-media; linux-omap
Betreff: Problems configuring OMAP35x ISP driver

Hello Sergio,

I spoke with you earlier about using the ISP and omap34xxcam drivers with a
micron mt9d111 SOC sensor.  I have since been able to take pictures, but the
sensor data is not making it through the ISP data-path correctly.  I know
the problem is in the ISP data-path because I am configuring the sensor the
exact same way as I have been on my working PXA system.  I am expecting
4:2:2 packed YUV data, but all of the U and V data is no more than 2 bits
where it should be 8.  I know the ISP has a lot of capabilities, but all I
want to use it for is grabbing 8-bit data from my sensor and putting it in a
buffer untouched using the CCDC interface (and of course clocking and
timing).  What are the key steps to take to get this type of configuration?


Other Questions:

Is there any processing done on YUV data in the ISP driver by default that I
am missing?
Has any one else experienced similar problems while adding new sensor
support?

Any help here would be greatly appreciated.

Thank you,

Zach LeRoy
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

