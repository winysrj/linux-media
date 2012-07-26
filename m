Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:60359 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751480Ab2GZAd5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 20:33:57 -0400
Received: from www.seiner.lan ([192.168.128.6] ident=yan)
	by www.seiner.lan with esmtpsa (SSL3.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <yan@seiner.com>)
	id 1SuBbM-0001L3-DR
	for linux-media@vger.kernel.org; Wed, 25 Jul 2012 17:06:48 -0700
Message-ID: <50108A15.8090005@seiner.com>
Date: Wed, 25 Jul 2012 17:06:45 -0700
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: cx231xx interlace-like artifacts
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just recently changed my vidcap to a Hauppage .  Now I get these 
interlace-like artifacts:

http://seiner.com/cz/rtpictures/2012_07_25T14h20m46sZ_0.451651_44.090619_-123.126059.jpg
http://seiner.com/cz/rtpictures/2012_07_25T14h22m48sZ_0.224624_44.089669_-123.139100.jpg

cxx231x.h has the following line:

#define CX231XX_INTERLACED_DEFAULT      1

Is there some way to turn off interlacing with a parameter?

Thanks,

--Yan

