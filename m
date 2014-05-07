Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:59980 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbaEGLge (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 May 2014 07:36:34 -0400
Received: by mail-yk0-f174.google.com with SMTP id 9so684085ykp.33
        for <linux-media@vger.kernel.org>; Wed, 07 May 2014 04:36:34 -0700 (PDT)
Received: from [192.168.1.18] (c-68-56-128-104.hsd1.fl.comcast.net. [68.56.128.104])
        by mx.google.com with ESMTPSA id k7sm26731731yhj.31.2014.05.07.04.36.33
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 07 May 2014 04:36:33 -0700 (PDT)
Message-ID: <536A1AC1.7010304@gmail.com>
Date: Wed, 07 May 2014 07:36:33 -0400
From: Dale Ritchey <mergan14846@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: https://bugzilla.kernel.org/show_bug.cgi?id=75591
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I had problems with uvc with the linux-3.15 kernel, all rc's When uvc is 
added I have problems with pulse audio that prevents firefox from 
functioning. disabling pulse audio allows firefox to work properly. on 
shut down and reboot watchdog does not stop and systemd says it cannot 
unmount some directorys. With uvc removed all works as they should.
