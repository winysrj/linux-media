Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2b.orange.fr ([80.12.242.145]:37377 "EHLO smtp2b.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758555AbZAWWHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 17:07:40 -0500
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] cx24116 & roll-off factor = auto
Date: Fri, 23 Jan 2009 23:07:38 +0100
References: <20090123205854.45e40dd0@bk.ru> <c74595dc0901231151iafa6b15kd3c0949e0ed86668@mail.gmail.com> <20090124004435.0c110182@bk.ru>
In-Reply-To: <20090124004435.0c110182@bk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901232307.38396.hftom@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le vendredi 23 janvier 2009 22:44:35 Goga777, vous avez écrit :
> > For example, DVB-S uses only rolloff = 0.35, so if the driver knows that
> > the chip can't accept auto value, it should use 0.35 value by default in
> > that case.
>
> good idea. Anybody against ?

That's already the case with cx24116, 0.35 is used for dvb-s

-- 
Christophe Thommeret

