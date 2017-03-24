Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.149.4]:33352 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751355AbdCXBd2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Mar 2017 21:33:28 -0400
Received: from cm4.websitewelcome.com (unknown [108.167.139.16])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 58C781EBDC
        for <linux-media@vger.kernel.org>; Thu, 23 Mar 2017 19:04:23 -0500 (CDT)
From: peter@easthope.ca
To: linux-media@vger.kernel.org
Cc: peter@easthope.ca
Subject: JVC camera and Hauppauge PVR-150 framegrabber.
Message-Id: <E1crCiL-0001oB-BQ@dalton.invalid>
Date: Thu, 23 Mar 2017 17:04:21 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With a manual setting of the device path and ID, the V4L2 Test Bench 
produced this image from a JVC TK-1070U camera on a microscope.  
http://easthope.ca/JVCtoPVR150screen.jpg

Setting the device in the Test Bench each time it is opened becomes 
tedious and no /etc/*v4l* exists.  Can the default configuration be 
adjusted permanently without recompiling?  How?

Although too dark, the image from the microscope slide is faintly 
visible. The upper half of the image is on the bottom of the screen 
and the lower half is at the top.  On a VCR I might try adjusting 
vertical sync.  Is there an equivalent in the Test Bench?

Thanks,                           ... Peter E. 
-- 

123456789 123456789 123456789 123456789 123456789 123456789 123456789
Tel: +1 360 639 0202                      Pender Is.: +1 250 629 3757
http://easthope.ca/Peter.html              Bcc: peter at easthope. ca
