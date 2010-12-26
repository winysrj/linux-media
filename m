Return-path: <mchehab@gaivota>
Received: from mailout08.t-online.de ([194.25.134.20]:46453 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab0LZVob (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Dec 2010 16:44:31 -0500
From: Heino Goldenstein <heino.goldenstein@t-online.de>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] cx88-dvb.c: DVB net latency using Hauppauge HVR4000
Date: Sun, 26 Dec 2010 21:51:34 +0100
References: <4D14325E.9000505@sfc.wide.ad.jp> <20101224222845.47edf47d@bk.ru>
In-Reply-To: <20101224222845.47edf47d@bk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012262151.35026.heino.goldenstein@t-online.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

Am Freitag, 24. Dezember 2010 20:28 schrieb Goga777:

> will your patch useful for dvb sat tv ?
>
> >      We are from School On Internet Asia (SOI Asia) project that uses
> > satellite communication to deliver educational content. We used Hauppauge
> > HVR 4000 to carry IP traffic over ULE. However, there is an issue with
> > high latency jitter. My boss, Husni, identified the problem and provided
> > a patch for this problem. We have tested this patch since kernel 2.6.30
> > on our partner sites and it hasn't cause any issue. The default buffer
> > size of 32 TS frames on cx88 causes the high latency, so our deployment
> > changes that to 6 TS frames. This patch made the buffer size tunable,
> > while keeping the default buffer size of 32 TS frames unchanged. Sorry, I

FWIW in the DVBlast subversion is a similar patch [1] touching the same
value. See the reason for this in the README [2].

Tjuess
  Heino

[1]http://svn.videolan.org/filedetails.php?repname=DVBlast&path=%2Ftrunk%2Fextra%2Fkernel-patches%2F03-cx88.patch
[2]http://svn.videolan.org/filedetails.php?repname=DVBlast&path=%2Ftrunk%2Fextra%2Fkernel-patches%2FREADME
