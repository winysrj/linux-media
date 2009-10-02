Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:50898 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbZJBNzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 09:55:54 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n92Dtw7M005252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 2 Oct 2009 08:55:58 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id n92DtvU4011002
	for <linux-media@vger.kernel.org>; Fri, 2 Oct 2009 08:55:57 -0500 (CDT)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id n92Dtv6b023144
	for <linux-media@vger.kernel.org>; Fri, 2 Oct 2009 08:55:57 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Fri, 2 Oct 2009 08:55:54 -0500
Subject: Programming sensor through firmware files bc of NDA
Message-ID: <A24693684029E5489D1D202277BE89444C9C9C11@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm currently interested in knowing what is the stand on having a
v4l2_subdev driver that uses some kind of binary for programming
registers in a image sensor driver.

NOTE: I must confess I currently don't know how to do it
(Any pointers/samples for doing it on a proper way?)

The only reason for doing this is to avoid potential violation of
NDA with sensor manufacturer by exposing all register details.

Please comment.

Regards,
Sergio