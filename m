Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41757 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab2JEW1M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Oct 2012 18:27:12 -0400
Message-ID: <506F5EA5.3020205@iki.fi>
Date: Sat, 06 Oct 2012 01:26:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Gianluca Gennari <gennarone@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: em28xx releases I2C adapter earlier than demod/tuner/sec
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That is one bug fix could be nice to fix. It is potential change it 
Oopses Kernel when DVB sub-driver release is called with I2C-adaper == NULL.

regards
Antti

-- 
http://palosaari.fi/
