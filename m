Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:36453 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362AbcECPbp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2016 11:31:45 -0400
Received: by mail-vk0-f43.google.com with SMTP id c189so27973121vkb.3
        for <linux-media@vger.kernel.org>; Tue, 03 May 2016 08:31:45 -0700 (PDT)
Received: from [10.251.101.16] ([201.206.221.6])
        by smtp.gmail.com with ESMTPSA id x15sm636985vkd.4.2016.05.03.08.31.43
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 03 May 2016 08:31:44 -0700 (PDT)
To: linux-media@vger.kernel.org
From: Marco Madrigal <marco.madrigal@ridgerun.com>
Subject: g_webcam driver not working properly on newer kernel
Message-ID: <5728C45F.9070208@ridgerun.com>
Date: Tue, 3 May 2016 09:31:43 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I am working with the g_webcam driver on Linux 3.14 and 4.3 with an 
embedded system. It works pretty well for most of Linux hosts but when 
trying to register the webcam driver on Windows 7/8 I got "This device 
cannot start (Code 10)" message.

I decided to try out the old version of the driver before the videobuf2 
modifications and some other stuff (mostly the pretty initial driver) 
and it worked correctly on Windows 7/8.

Has someone else experimented a similar issue? Is this a regression 
problem? I noticed that newer version of the patch need several tries to 
get the streaming working correctly on Linux hosts but I have been 
unable to get it working at all with Windows.

Regards,
-Marco
