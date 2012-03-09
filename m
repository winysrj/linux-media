Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:53262 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2CIAnn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 19:43:43 -0500
Received: from 188-222-104-137.zone13.bethere.co.uk ([188.222.104.137] helo=tiber)
	by mail81.extendcp.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.77)
	id 1S5nvp-00051d-Ph
	for linux-media@vger.kernel.org; Fri, 09 Mar 2012 00:43:41 +0000
Received: from [127.0.0.1] (helo=tiber)
	by tiber with esmtp (Exim 4.77)
	(envelope-from <h@realh.co.uk>)
	id 1S5nvs-00044B-Ow
	for linux-media@vger.kernel.org; Fri, 09 Mar 2012 00:43:44 +0000
Date: Fri, 9 Mar 2012 00:43:44 +0000
From: Tony Houghton <h@realh.co.uk>
To: linux-media@vger.kernel.org
Subject: Initial tuning data format for DVB-T2
Message-ID: <20120309004344.187af1e4@tiber>
Reply-To: linux-media@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there an official way of expressing DVB-T2 tuning data in the files
used by the scan utility as input? Similarly to how roll-off and
modulation type were added to the S/S2 lines. I think DVB-T2 needs a PLP
id on top of the DVB-T parameters, is there anything else?
