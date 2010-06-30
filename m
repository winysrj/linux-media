Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47212 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab0F3OnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 10:43:11 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id o5UEhAk5028874
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 30 Jun 2010 09:43:10 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id o5UEhApv008044
	for <linux-media@vger.kernel.org>; Wed, 30 Jun 2010 09:43:10 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id o5UEhAGi007413
	for <linux-media@vger.kernel.org>; Wed, 30 Jun 2010 09:43:10 -0500 (CDT)
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 30 Jun 2010 09:43:08 -0500
Subject: [Query] How to preserve soc_camera and still use a sensor for media
 controller?
Message-ID: <A24693684029E5489D1D202277BE89445638FD0E@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Is it possible to keep a sensor chip driver compatible with 2 interfaces?

I'm particularly interested in mt9t112 sensor.

Has this been done before with other driver?

Thanks for your attention.

Regards,
Sergio
