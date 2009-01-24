Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx44.mail.ru ([195.239.211.10]:51499 "EHLO mx44.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbZAXIQB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2009 03:16:01 -0500
Received: from f240.mail.ru (f240.mail.ru [194.186.55.245])
	by mx44.mail.ru (mPOP.Fallback_MX) with ESMTP id F2D3938001639
	for <linux-media@vger.kernel.org>; Sat, 24 Jan 2009 11:07:36 +0300 (MSK)
From: Goga777 <goga777@bk.ru>
To: Christophe Thommeret <hftom@free.fr>
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: =?koi8-r?Q?Re[2]=3A_[linux-dvb]_cx24116_&_roll-off_factor_=3D_auto?=
Mime-Version: 1.0
Date: Sat, 24 Jan 2009 11:07:04 +0300
References: <200901232307.38396.hftom@free.fr>
In-Reply-To: <200901232307.38396.hftom@free.fr>
Reply-To: Goga777 <goga777@bk.ru>
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 8bit
Message-Id: <E1LQdXk-000Ok0-00.goga777-bk-ru@f240.mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Le vendredi 23 janvier 2009 22:44:35 Goga777, vous avez écrit :
> > > For example, DVB-S uses only rolloff = 0.35, so if the driver knows that
> > > the chip can't accept auto value, it should use 0.35 value by default in
> > > that case.
> >
> > good idea. Anybody against ?
> 
> That's already the case with cx24116, 0.35 is used for dvb-s


already has been done with cx24116 ? It's strange because I can see in cx24116 debug logs the messages like this

unsupported rolloff selected (3) 

for dvb-s


Goga

