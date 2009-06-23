Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:49715 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbZFWSKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 14:10:16 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n5NIADts011663
	for <linux-media@vger.kernel.org>; Tue, 23 Jun 2009 13:10:19 -0500
Received: from dlep20.itg.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id n5NIADRO002733
	for <linux-media@vger.kernel.org>; Tue, 23 Jun 2009 13:10:13 -0500 (CDT)
Received: from dlee75.ent.ti.com (localhost [127.0.0.1])
	by dlep20.itg.ti.com (8.12.11/8.12.11) with ESMTP id n5NIADp5018967
	for <linux-media@vger.kernel.org>; Tue, 23 Jun 2009 13:10:13 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 23 Jun 2009 13:10:11 -0500
Subject: sub devices sharing same i2c address
Message-ID: <A69FA2915331DC488A831521EAE36FE40139EDB7B2@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am having to switch between two sub devices that shares the same i2c address. First one is TVP5146 and the other is MT9T031. The second has a i2c switch and the evm has a data path switch. So in our internal release we could switch capture inputs between the two by configuring the above two switches. Right now, I am loading up the i2c sub devices using the new API (added by Hans) v4l2_i2c_new_subdev_board(). But since the i2c addresses are shared, it fails for the second sub device. Does someone know a way to get around this so that I could load up both sub devices and switch between them for capture?

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
Phone : 301-515-3736
email: m-karicheri2@ti.com

