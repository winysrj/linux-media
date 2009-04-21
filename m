Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:55126 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZDUBdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 21:33:43 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2117535wff.4
        for <linux-media@vger.kernel.org>; Mon, 20 Apr 2009 18:33:42 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 21 Apr 2009 10:33:42 +0900
Message-ID: <5e9665e10904201833k42a733fdh40b11f499744c85f@mail.gmail.com>
Subject: Applying SoC camera framework on multi-functional camera interface
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

One of my recent work is making S3C64XX camera interface driver with
SoC camera framework. Thanks to Guennadi, SoC camera framework is so
clear and easy to follow. Actually I didn't need to worry about my
whole driver structure, the framework almost has everything that I
need.

But here is a problem that I couldn't make up my mind while
implementing some of the features of S3C64XX camera IP.
As you know, S3C64XX camera IP has scaler and rotator capability on
it's own which can be used standalone even memory to memory scaling
and rotating jobs.
If you want to know in detail please take a look at the user manual
(just remind if you have already seen this)  :
http://www.ebv.com/fileadmin/products/Products/Samsung/S3C6400/S3C6400X_UserManual_rev1-0_2008-02_661558um.pdf

Telling you about the driver concept that I wanted to make is like following:

(I want to select inputs like external camera and MSDMA using
S_INPUT'/G_INPUT but we don't have them in SoC camera framework.
So this should be the version of design with current SoC camera framework.)

1. S3C64XX has preview and codec path
2. Each preview and codec path can have external camera and MSDMA for input
3. make external camera and MSDMA device nodes for each preview and codec.
  => Let's assume that we have camera A and B, then it should go like this
  /dev/video0 (camera A on preview device)
  /dev/video1 (camera B on preview device)
  /dev/video2 (MSDMA on preview device)
  /dev/video3 (camera A on codec device)
  /dev/video4 (camera B on codec device)
  /dev/video5 (MSDMA on codec device)

4. Those device nodes are "device" in SoC camera framework (and S3C
camera interface should be "host" device)
 => External camera devices can be made in SoC camera device. Fair enough.

  But MSMDA? what should I do If I want to make it as a "device"
driver in SoC camera framework?
  Any reference that I could have? because I can't find any "device"
drivers besides camera sensor,isp drivers.
  Please let me know if there is any.

Cheers,

Nate

-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
