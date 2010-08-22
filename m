Return-path: <mchehab@pedra>
Received: from mail.ammma.de ([213.83.39.131]:6006 "EHLO ammma.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752005Ab0HVLFn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Aug 2010 07:05:43 -0400
Received: from mail.ammma.net (hydra.ammma.mil [192.168.110.1])
	by ammma.de (8.11.6/8.11.6/AMMMa AG) with ESMTP id o7MB0nS01876
	for <linux-media@vger.kernel.org>; Sun, 22 Aug 2010 13:00:49 +0200
Received: from neo.wg.de (hydra.ammma.mil [192.168.110.1])
	by mail.ammma.net (Postfix) with ESMTP id 16A114D1C025
	for <linux-media@vger.kernel.org>; Sun, 22 Aug 2010 13:05:40 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id AB35552661E
	for <linux-media@vger.kernel.org>; Sun, 22 Aug 2010 13:05:38 +0200 (CEST)
Received: from neo.wg.de ([127.0.0.1])
	by localhost (neo.wg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 42-uYAik7hc1 for <linux-media@vger.kernel.org>;
	Sun, 22 Aug 2010 13:05:37 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id 9D7965265B7
	for <linux-media@vger.kernel.org>; Sun, 22 Aug 2010 13:05:37 +0200 (CEST)
Message-ID: <20100822130537.121732rl2ot7msg0@neo.wg.de>
Date: Sun, 22 Aug 2010 13:05:37 +0200
From: Jan Schneider <jan@horde.org>
To: linux-media@vger.kernel.org
Subject: Re: SATELCO EasyWatch PCI (DVB-C) not waking up
References: <20100811141542.20288il5ge6xlu28@neo.wg.de>
In-Reply-To: <20100811141542.20288il5ge6xlu28@neo.wg.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Zitat von Jan Schneider <jan@horde.org>:

> Hi,
>
> I have the DVB-C card mentioned in the subject. Unfortunately it's  
> not properly waking up from standby or suspend. The card doesn't  
> tune anymore after resuming.
> This is with Ubuntu's 2.6.32-24 kernel.
> I could need any pointers how to collect more information about the  
> failing resume, so that you might be able to help me fixing this.

Attached is the syslog from the suspend/resume cycle. There are  
several errors regarding the DVB-C adapter and the CAM. Maybe this  
helps?

Jan.

-- 
Do you need professional PHP or Horde consulting?
http://horde.org/consulting/

