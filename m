Return-path: <linux-media-owner@vger.kernel.org>
Received: from averell.mail.tiscali.it ([213.205.33.55]:37823 "EHLO
	averell.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968507Ab0B1OwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 09:52:13 -0500
Received: from [192.168.0.60] (78.14.35.130) by averell.mail.tiscali.it (8.0.031)
        id 4B5FFB30015122BA for linux-media@vger.kernel.org; Sun, 28 Feb 2010 15:52:11 +0100
Message-ID: <4B8A82CC.6000408@gmail.com>
Date: Sun, 28 Feb 2010 15:50:52 +0100
From: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Analog TV issue with Empire Dual TV (probably wrong GPIO analogue
 setting)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi to all,
I've tried my Empire Dual TV usb device which is supported and correctly 
recognized by the kernel.
Digital TV works, but analogue tv is slow and with no audio.
I suppose that there is something wrong in the GPIO analogue setting.
I would like to know what I can do to solve the issue.
I can take an usbsnoop using windows XP virtualized with virtualbox (if 
feasible it is my first choice) or under windows Vista.
In any case I need to know if, using usbsnoop, it is sufficient to open 
the program used to watch analogue tv or it is needed to tune a channel 
to obtain the data needed to reverse engineering the GPIO analogue setting.
Finally, even if I obtain the correct usbsnoop, I'm not able to read it 
to extract GPIO. Is there somewhere an howto?
Thank you,
Andrea
