Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:58840 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab2CKNeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 09:34:23 -0400
From: "=?iso-8859-15?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: Claus Olesen <ceolesen@gmail.com>
Subject: Re: dvb-c usb device for linux
Date: Sun, 11 Mar 2012 15:27:41 +0200
Cc: linux-media@vger.kernel.org
References: <CAGa-wNMGMTBdB2bqPL7vibgrv+tLZnOMQsQwDbHHWXO6cyNkTg@mail.gmail.com>
In-Reply-To: <CAGa-wNMGMTBdB2bqPL7vibgrv+tLZnOMQsQwDbHHWXO6cyNkTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203111527.41689.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le dimanche 11 mars 2012 15:08:25 Claus Olesen, vous avez écrit :
> PS.
> If linux supported the 290e for dvb-c as supported by its chipset
> CXD2820 as also used by the ET T2C for dvb-c then it would be my choice.

The Linux driver does support DVB-C.

However you need software that understands multi-standard frontends from the 
Linux DVB API v5.4, and that is hard to come by as of today.

> As I said in my previous email then
> I found that the 290e works for dvb-c using dvbviewer and just now
> I found that it works for dvb-c also using dvblink

I have 290e showing DVB-C channels with hacked VLC on Linux 3.3-rc6.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
