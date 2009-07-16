Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw2.jenoptik.com ([213.248.109.130]:8002 "EHLO
	mailgw2.jenoptik.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554AbZGPQFg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2009 12:05:36 -0400
Received: from hermes.jena-optronik.de (hermes [10.128.0.8])
 	by julia.jena-optronik.de (Postfix) with ESMTP id 94D172102B
 	for <linux-media@vger.kernel.org>; Thu, 16 Jul 2009 17:55:34 +0200 (CEST)
Received: from hermes.jena-optronik.de (localhost.localdomain [127.0.0.1])
 	by hermes.jena-optronik.de (8.13.8/8.13.8) with ESMTP id n6GFtYfh030371
 	for <linux-media@vger.kernel.org>; Thu, 16 Jul 2009 17:55:34 +0200
Date: Thu, 16 Jul 2009 17:55:18 +0200
From: "Jesko Schwarzer" <jesko.schwarzer@jena-optronik.de>
To: <linux-media@vger.kernel.org>
Message-ID: <"4430.36471247759733.hermes.jena-optronik.de*"@MHS>
In-Reply-To: <20090716124649.488941bd@pedra.chehab.org>
Subject: Force driver to load (tcm825x)
MIME-Version: 1.0
Content-Type: text/plain;
 	charset="US-ASCII"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,

I am working to get the omap34xxcam with the tcm825x running. Currently I
was not successful in forcing the driver to load and register (in absence of
a real sensor). I do a probe when the driver starts and uncommented the i2c
things.

It fails when calling the

vidioc_int_g_priv()

Function in the device-register function of the "omap34xxcam.c".
How do I get it accepting the data ?

Is there any documentation to find?

Any hint would be perfect.

Kind regards
/Jesko

