Return-path: <mchehab@gaivota>
Received: from banach.math.auburn.edu ([131.204.45.3]:45972 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0LRWCu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 17:02:50 -0500
Received: from banach.math.auburn.edu (localhost [127.0.0.1])
	by banach.math.auburn.edu (8.14.4/8.14.2) with ESMTP id oBIMAAG8023008
	for <linux-media@vger.kernel.org>; Sat, 18 Dec 2010 16:10:10 -0600
Received: from localhost (kilgota@localhost)
	by banach.math.auburn.edu (8.14.4/8.14.2/Submit) with ESMTP id oBIMA9ex023004
	for <linux-media@vger.kernel.org>; Sat, 18 Dec 2010 16:10:10 -0600
Date: Sat, 18 Dec 2010 16:10:09 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: linux-media@vger.kernel.org
Subject: Power frequency detection.
Message-ID: <alpine.LNX.2.00.1012181550500.22984@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


Does anyone know whether, somewhere in the kernel, there exists a scheme 
for detecting whether the external power supply of the computer is using 
50hz or 60hz?

The reason I ask:

A certain camera is marketed with Windows software which requests the user 
to set up the option of 50hz or 60hz power during the setup.

Judging by what exists in videodev2.h, for example, it is evidently 
possible to set up this as a control setting in a Linux driver. I am not 
aware of any streaming app which knows how to access such an option.

Information about which streaming app ought to be used which could take 
advantage of a setting for line frequency would be welcome, too, of 
course. As I said, I do not know of a single one and would therefore have 
trouble with testing any such control setting unless I could find the 
software which can actually present the choice to the user.

But my main question is whether the kernel already does detect the line 
frequency anywhere else, for whatever reason. For, it occurs to me that a 
far more elegant solution -- if the camera really does need to have the 
line frequency detected -- would be do do the job automatically and not to 
bother the user about such a thing.

In other news, in case anyone has any children who are in love with Lego, 
the "Lego Bionicle" camera which is currently on sale has an SQ905C type 
chip in it. I just added its Product number to the Gphoto driver last 
night. And it works perfectly in webcam mode if one adds its product 
number in gspca/sq905c.c. I will get around to doing that formally, of 
course, when I get time. But if anyone wants just to add the number and 
re-compile the Vendor:Product number for the new camera is 0x2770:0x9051.

Merry Christmas.

Theodore Kilgore
