Return-path: <linux-media-owner@vger.kernel.org>
Received: from [200.29.137.120] ([200.29.137.120]:37485 "EHLO tesla.opendot.cl"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab0FXQgd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jun 2010 12:36:33 -0400
Received: from [192.168.0.10] (unknown [200.2.215.29])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tesla.opendot.cl (Postfix) with ESMTPSA id 0591EC8001
	for <linux-media@vger.kernel.org>; Thu, 24 Jun 2010 12:15:04 -0400 (CLT)
Message-ID: <4C238B30.3050908@opendot.cl>
Date: Thu, 24 Jun 2010 12:43:28 -0400
From: "Reynaldo H. Verdejo Pinochet" <reynaldo@opendot.cl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: ISDB-T Tuning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys

I have been trying to get a siano based 1seg ISDB-T USB dongle
to scan and tune under Linux to no avail. Asking around it has
been brought to my attention there might be no app available
that would do this successfully even with an adapter currently
supported by the kernel like the one I'm using. Facing that
scenario and assuming my lack of luck trying to find such an
application supports that claim, I'm wondering if there is
anyone reading this that might be working on writing such an
application and/or in extending an existing one like 'scan'
to be able to work with ISDB-T. Just to avoid duplicating the
effort.

Best regards

--
Reynaldo
