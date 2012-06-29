Return-path: <linux-media-owner@vger.kernel.org>
Received: from snail.math.uni-duesseldorf.de ([134.99.156.233]:58290 "EHLO
	snail.math.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932142Ab2F2Qrv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 12:47:51 -0400
Received: from p50851618.dip.t-dialin.net ([80.133.22.24] helo=[192.168.101.135])
	by snail.math.uni-duesseldorf.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <jansing@am.uni-duesseldorf.de>)
	id 1Skdvd-0004hV-MI
	for linux-media@vger.kernel.org; Fri, 29 Jun 2012 18:20:17 +0200
Message-ID: <4FEDD748.2060506@am.uni-duesseldorf.de>
Date: Fri, 29 Jun 2012 18:26:48 +0200
From: Georg Jansing <jansing@am.uni-duesseldorf.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] openSUSE hints for media_build
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everybody,

I was trying to install Linux TV Kernel Modules via your media_build git 
repo/scripts. Since I am on openSUSE and there are no installation hints 
yet, and I needed to look up the correct packages anyways, here is a 
small patch that adds the corresponding infomation to your script.

I hope, the formulation for adding the perl buildservice repository 
(something like Ubuntu's PPAs) is clear enough. Please also be warned, 
that I never did anything in perl yet, so I don't know if I chose the 
best/perl way to add the repo message.

Sadly, the media_build drivers did not work for me, but with the script 
I could at least compile them correctly (I think ;-)).

Kind regards,

Georg Jansing
