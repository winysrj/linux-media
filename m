Return-path: <mchehab@gaivota>
Received: from mail1.matrix-vision.com ([78.47.19.71]:36716 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0KBRKp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 13:10:45 -0400
Message-ID: <4CD045FA.8040003@matrix-vision.de>
Date: Tue, 02 Nov 2010 18:10:18 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: media-ctl header patch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Sergio & Laurent,

Back in July, Sergio submitted a patch "Just include kernel headers" (http://www.mail-archive.com/linux-media%40vger.kernel.org/msg20397.html) which Laurent didn't yet want to apply.

Now I'm using Laurent's branch "new-api" (and the new media API to match), and w/o Sergio's patch, I get a warning:

types.h:13: warning: #warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"

With Sergio's patch and setting HDIR, I get rid of this warning.  Laurent, what do you think about applying the patch now?  I would ack it if I could, but I don't know how to resurrect an old patch.

-- 
Michael Jones

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
