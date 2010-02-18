Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50709 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab0BROA0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 09:00:26 -0500
Received: by pwj8 with SMTP id 8so1514901pwj.19
        for <linux-media@vger.kernel.org>; Thu, 18 Feb 2010 06:00:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <59cf47a81002080653y47f9df89j8d4bb1c56aaee52f@mail.gmail.com>
References: <3a665c761002080553j14ddf9cfu7167a848dc502d9d@mail.gmail.com>
	 <59cf47a81002080653y47f9df89j8d4bb1c56aaee52f@mail.gmail.com>
Date: Thu, 18 Feb 2010 22:00:23 +0800
Message-ID: <3a665c761002180600g640c6f48m3ad1754ecc7f5f18@mail.gmail.com>
Subject: Re: where I can get UVC svn repository
From: loody <miloody@gmail.com>
To: Paulo Assis <pj.assis@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi:

2010/2/8 Paulo Assis <pj.assis@gmail.com>:
> Hi,
> linuxtv uses mercurial (or git) not svn, please check the how-to:
>
> http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
>
> regards,
> Paulo
>
> 2010/2/8 loody <miloody@gmail.com>:
>> Dear all:
>> I hear UVC is change its repository to linxutv.
>> But I tried several possible repositories like
>> svn co http://linuxtv.org/hg/~pinchartl/uvcvideo/tags
>> svn co http://linuxtv.org/hg/~pinchartl/uvcvideo/rev/75c97b2d1a2a
>>
>> But svn says the repository is incorrect.
>> Would anyone tell me where is the correct location?
>> appreciate your help,
>> miloody
thanks for ur help :)
I have successfully check the source code out.
I have 2 questions:
1.When looking into the v4l folder, I find it seems different than
kernel/driver/media/video; it seems more files than the one in kernel
source.
in my opinion, the source I checkout should be the same as
kernel/driver/media/video, since they are kernel driver, right?

2. I try to build v4l2-apps but it seems I need to have at4 in advance.
My distribution is ubuntu and I have already "sudo apt-get install
qt4-dev-tools", but it still complain:

g++ -c -pipe -g -Wall -W -D_REENTRANT -DQT_GUI_LIB -DQT_CORE_LIB
-I/usr/share/qt4/mkspecs/linux-g++ -I. -I/usr/include/qt4/QtCore
-I/usr/include/qt4/QtGui -I/usr/include/qt4 -I. -I../../include
-I../../libv4l2util -I../../libv4l/include -I. -o qv4l2.o qv4l2.cpp
In file included from qv4l2.cpp:20:
qv4l2.h:23:23: error: QMainWindow: No such file or directory

I find it is really no any qt4 headers in the include file that -I point to.
does that mean I apt-get the wrong package?
appreciate your kind help,
miloody
