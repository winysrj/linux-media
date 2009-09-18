Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway10.websitewelcome.com ([67.18.39.11]:46386 "HELO
	gateway10.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751298AbZIRXtn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 19:49:43 -0400
Received: from [66.15.212.169] (port=30657 helo=[10.140.5.16])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1Moi6o-0002YW-CB
	for linux-media@vger.kernel.org; Fri, 18 Sep 2009 13:23:02 -0500
Subject: [PATCH 0/9] staging go7007 cleanup
From: Pete <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 11:23:06 -0700
Message-Id: <1253298186.4314.564.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Everyone,

Here are some patches that I've been working on for the go7007 driver.
Most are whitespace cleanup and small fixes.  I had previously applied
these to Hans v4l-dvb-go7007 branch, and required minor changes to apply
cleanly to the staging go7007 driver in v4l-dvb.  I'm also working on
the subdev conversion patch, but it requires a large bit of rework.

Comments and review welcome.

Pete Eberlein


