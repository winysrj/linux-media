Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59963 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758667AbZFAO4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 10:56:46 -0400
From: "Paulraj, Sandeep" <s-paulraj@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Grosen, Mark" <mgrosen@ti.com>
Date: Mon, 1 Jun 2009 09:56:40 -0500
Subject: New Driver for DaVinci DM355/DM365/DM6446
Message-ID: <C9D59C82B94F474B872F2092A87F261481797D4B@dlee07.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,

WE have a module(H3A) on Davinci DM6446,DM355 and DM365.

Customers require a way to collect the data required to perform the Auto Exposure (AE), Auto Focus(AF), and Auto White balance (AWB) in hardware as opposed to software. This is primarily for performance reasons as there is not enough software processing MIPS (to do 3A statistics) available in
an imaging/video system.

Including this block in hardware reduces the load on the processor and bandwidth to the memory as the data is collected on the fly from the imager.

This modules collects statistics and we currently implement it as a character driver.

Which mailing list would be the most appropriate mailing list to submit patches for review?

Thanks,
Sandeep
