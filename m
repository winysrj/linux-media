Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33924 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698AbZLGWtU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 17:49:20 -0500
Received: by bwz27 with SMTP id 27so3979728bwz.21
        for <linux-media@vger.kernel.org>; Mon, 07 Dec 2009 14:49:25 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org,
	Patrick Boettcher <patrick.boettcher@desy.de>,
	Olivier Grenie <olivier.grenie@dibcom.fr>
Subject: dib0090.h need attention - copy-paste errors
Date: Tue, 8 Dec 2009 00:49:10 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912080049.10790.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Part of dib0090.h:

91 static inline enum frontend_tune_state dib0090_get_tune_state(struct dvb_frontend *fe)
92 {
93 printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
94 return CT_DONE;
95 }
96
97 static inline int dib0090_set_tune_state(struct dvb_frontend *fe, enum frontend_tune_state 
tune_state)
98 {
99 printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
100 return -ENODEV;
101 }
102
103 static inline num frontend_tune_state dib0090_get_tune_state(struct dvb_frontend *fe)
104 {
105 printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
106 return CT_SHUTDOWN,}
107 

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
