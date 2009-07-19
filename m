Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38862 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754497AbZGSOjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 10:39:18 -0400
Received: from compute2.internal (compute2.internal [10.202.2.42])
	by out1.messagingengine.com (Postfix) with ESMTP id 226993BA43A
	for <linux-media@vger.kernel.org>; Sun, 19 Jul 2009 10:39:18 -0400 (EDT)
Received: from localhost.localdomain (ool-457b4d55.dyn.optonline.net [69.123.77.85])
	by mail.messagingengine.com (Postfix) with ESMTPSA id DDB8CA1BB
	for <linux-media@vger.kernel.org>; Sun, 19 Jul 2009 10:39:17 -0400 (EDT)
Received: from acano by localhost.localdomain with local (Exim 4.69)
	(envelope-from <acano@fastmail.fm>)
	id 1MSXY7-0004Z7-3E
	for linux-media@vger.kernel.org; Sun, 19 Jul 2009 10:39:35 -0400
Date: Sun, 19 Jul 2009 10:39:35 -0400
From: acano@fastmail.fm
To: linux-media@vger.kernel.org
Subject: The em28xx driver is creating /dev/video* entry for dvb only cards
Message-ID: <20090719143935.GA17043@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


The em28xx driver is creating /dev/video* entry for dvb only cards.
