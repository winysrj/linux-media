Return-path: <mchehab@pedra>
Received: from mail.ammma.de ([213.83.39.131]:26889 "EHLO ammma.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751257Ab0HKMpl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Aug 2010 08:45:41 -0400
Received: from mail.ammma.net (hydra.ammma.mil [192.168.110.1])
	by ammma.de (8.11.6/8.11.6/AMMMa AG) with ESMTP id o7BCBBS24322
	for <linux-media@vger.kernel.org>; Wed, 11 Aug 2010 14:11:11 +0200
Received: from neo.wg.de (hydra.ammma.mil [192.168.110.1])
	by mail.ammma.net (Postfix) with ESMTP id D8BA34D1C025
	for <linux-media@vger.kernel.org>; Wed, 11 Aug 2010 14:15:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id 290D95295C4
	for <linux-media@vger.kernel.org>; Wed, 11 Aug 2010 14:15:43 +0200 (CEST)
Received: from neo.wg.de ([127.0.0.1])
	by localhost (neo.wg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fZl19K-Lg4-c for <linux-media@vger.kernel.org>;
	Wed, 11 Aug 2010 14:15:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id 5A172529330
	for <linux-media@vger.kernel.org>; Wed, 11 Aug 2010 14:15:42 +0200 (CEST)
Message-ID: <20100811141542.20288il5ge6xlu28@neo.wg.de>
Date: Wed, 11 Aug 2010 14:15:42 +0200
From: Jan Schneider <jan@horde.org>
To: linux-media@vger.kernel.org
Subject: SATELCO EasyWatch PCI (DVB-C) not waking up
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

I have the DVB-C card mentioned in the subject. Unfortunately it's not  
properly waking up from standby or suspend. The card doesn't tune  
anymore after resuming.
This is with Ubuntu's 2.6.32-24 kernel.
I could need any pointers how to collect more information about the  
failing resume, so that you might be able to help me fixing this.

Jan.

-- 
Do you need professional PHP or Horde consulting?
http://horde.org/consulting/

