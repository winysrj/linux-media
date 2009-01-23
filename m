Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.orange.fr ([193.252.22.30]:58383 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135AbZAWTxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 14:53:00 -0500
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] cx24116 & roll-off factor = auto
Date: Fri, 23 Jan 2009 20:52:58 +0100
References: <20090123205854.45e40dd0@bk.ru> <200901231959.49629.hftom@free.fr> <20090123224924.62a48791@bk.ru>
In-Reply-To: <20090123224924.62a48791@bk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901232052.58626.hftom@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le vendredi 23 janvier 2009 20:49:24 Goga777, vous avez écrit :
> > > does support cx24116  the roll-off factor = auto ?
> >
> > no
>
> who should be care about of corrected roll-off factor which have to send to
> cx24116 - the drivers or user software ? does roll-off factor = 0,35 good
> for 99% dvb-s2 channels ?

The scanning app should get the rolloff factor.
Yes, 0.35 is most likely.

-- 
Christophe Thommeret

