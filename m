Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:42665 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab0FPWPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 18:15:25 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id o5GMFOA5007354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 17:15:24 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id o5GMFOMx000576
	for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 17:15:24 -0500 (CDT)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id o5GMFOpF023686
	for <linux-media@vger.kernel.org>; Wed, 16 Jun 2010 17:15:24 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 16 Jun 2010 17:15:23 -0500
Subject: sub device device node and ioctl support?
Message-ID: <A69FA2915331DC488A831521EAE36FE4016B3A7671@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I need to support ioctls on sub devices as part of my work on vpbe display driver. For example, currently we have use proprietary ioctls on a fb device to configure osd hardware on DMXXX VPBE and would like to migrate them to
the osd sub device node. But currently sub devices are not exporting device
nodes. I know there is work done by Laurent to add this support as part of
media controller activity, but then I have to wait for this for ever. Is there a way we can get this support merged to the kernel tree for 2.6.36?

Murali Karicheri
email: m-karicheri2@ti.com

