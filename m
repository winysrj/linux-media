Return-path: <mchehab@pedra>
Received: from yop.chewa.net ([91.121.105.214]:49396 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab1EYOv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 10:51:26 -0400
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: dvb: one demux per tuner or one demux per demod?
Date: Wed, 25 May 2011 17:51:19 +0300
Cc: vlc-devel@videolan.org
References: <719f9c4d1bd57d5b2711bc24a9d5c3b1@chewa.net> <BANLkTinN1YWpEpxxMgoZ2hMTGt3eEv=peA@mail.gmail.com> <4DDBABDE.5010908@iki.fi>
In-Reply-To: <4DDBABDE.5010908@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105251751.21203.remi@remlab.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Le mardi 24 mai 2011 16:00:14 Antti Palosaari, vous avez écrit :
> Yes I did, since I didn't know there is better way. Is there any other
> driver which implements it differently? I think all current MFE drivers
> does it like I did. For example look NetUP cx23885 + stv0367.
> 
> /dev/dvb/adapter0/
> crw-rw----+ 1 root video 212, 2 May 24 15:51 demux0
> crw-rw----+ 1 root video 212, 3 May 24 15:51 dvr0
> crw-rw----+ 1 root video 212, 0 May 24 15:51 frontend0
> crw-rw----+ 1 root video 212, 1 May 24 15:51 frontend1
> crw-rw----+ 1 root video 212, 4 May 24 15:51 net0

So there is always only one demux per adapter then? That would work for me, 
but it contradicts the example code at Documentation/DocBook/dvb/examples.xml

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
