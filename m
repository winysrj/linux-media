Return-path: <mchehab@localhost>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57000 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab0HaO6u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Aug 2010 10:58:50 -0400
Received: by wyb35 with SMTP id 35so7980440wyb.19
        for <linux-media@vger.kernel.org>; Tue, 31 Aug 2010 07:58:48 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 31 Aug 2010 20:28:45 +0530
Message-ID: <AANLkTimB2s6vfs0a0x4x_Rout=x4JGa=mhnXxq=-Tmpn@mail.gmail.com>
Subject: em28xx: new board id [1f71:3301]
From: Yogesh S <yogaishrs@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi All,



This you can take it as continuation mail of
http://www.mail-archive.com/linux-media@vger.kernel.org/msg21615.html

I am using same tv tuner card 1f71:3301.Its not loading driver.I
modified code by adding 1f71:3301 in vid pid defs by copying gadmei
330+ and 310 but its not loading driver.
When I load driver I am getting error "[ 1435.876079] usb 2-1: config
1 interface 0 altsetting 1 bulk endpoint 0x83 has invalid maxpacket
256"
Any solutions?



Regards
Yogesh
