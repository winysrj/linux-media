Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.matrix-vision.com ([85.214.244.251]:57682 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2JBOPs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 10:15:48 -0400
Message-ID: <506AF50B.5000606@matrix-vision.de>
Date: Tue, 02 Oct 2012 16:07:07 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media ML <linux-media@vger.kernel.org>
Subject: omap3isp: timeout in ccdc_disable()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I am looking at a case where the sensor may stop delivering data, at 
which point I want to do a STREAMOFF.  In this case, the STREAMOFF takes 
2s because of the wait_event_timeout() in ccdc_disable().  This wait 
waits for ccdc->stopping to be CCDC_STOP_FINISHED, which happens in two 
stages (only 2 because LSC is always LSC_STATE_STOPPED for me),
1. in VD1 because CCDC_STOP_REQUEST has been set by ccdc_disable()
2. in VD0 after CCDC_STOP_REQUEST had happened in VD1.

But because the data has already stopped coming from the sensor, when I 
do STREAMOFF, I'm no longer getting VD1/0, so ccdc->stopping will never 
become CCDC_STOP_FINISHED, and the wait_event_timeout() has to run its 
course of 2 seconds.  This doesn't change the control flow in 
ccdc_disable(), except to print a warning "CCDC stop timeout!" and 
return -ETIMEDOUT to ccdc_set_stream(), which in turn returns that as 
its return value.  But this value is ignored by its caller, 
isp_pipeline_disable().  It looks to me, then, like the only difference 
between timing out and not timing out is getting the warning message. 
omap3isp_sbl_disble() is called the same in both cases.

Q: Is there another reason for the wait & timeout?  Is there some 
functional difference between timing out and not timing out?  2 seconds 
sounds fairly arbitrary, are there constraints on that, or could I at 
least lower it to speed up STREAMOFF?

I know that normally the data wouldn't stop coming from the sensor until 
after the CCDC is disabled, when the sensor's s_stream(0) is called. 
But in this case the sensor is being driven externally, and I'm trying 
to react to that.

thanks,
Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
