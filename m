Return-path: <linux-media-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:56405 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbcCHPuz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2016 10:50:55 -0500
Received: from localhost (alg1 [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id B37701A0476
	for <linux-media@vger.kernel.org>; Tue,  8 Mar 2016 16:22:29 +0100 (CET)
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id SOQxlqIAGUHl for <linux-media@vger.kernel.org>;
	Tue,  8 Mar 2016 16:22:28 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
	by a.mx.secunet.com (Postfix) with ESMTP id A816C1A0488
	for <linux-media@vger.kernel.org>; Tue,  8 Mar 2016 16:22:28 +0100 (CET)
From: Dennis Wassenberg <dennis.wassenberg@secunet.com>
To: <linux-media@vger.kernel.org>
Subject: Question regarding internal webcams of tablet devices
Message-ID: <56DEEDDD.3030401@secunet.com>
Date: Tue, 8 Mar 2016 16:21:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a couple of questions regarding support of internal webcams of
new/current generation of tablet devices. For example Lenovo X1, HP
Elite x2 1012 G1. There are internal webcams which are not connected via
USB. In fact they are connected via the

(00:14.3 Multimedia controller [0480]: Intel Corporation Device
[8086:9d32] (rev 01) / Intel Skylake-U/Y PCH - Camera IO Host Controller
(CSI2) [A1])

PCI device. The PCI device itself serves as a camera IO host controller
which communicates via CSI-2 over I2C to the camera sensors. As far as I
know there is currently no support for the CSI-2 host controller but I
have seen some support for camera sensors in general at v4l.

However, at first there is the need to get a driver for the camera IO
host controller PCI device. Is there anybody how knows a driver for that
pci device or known if there will be a driver for that in the future? Is
this the right way to support this kind of cameras or is there an other
way to get such cameras working with linux?

Thank you & best regards,

Dennis
