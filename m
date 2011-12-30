Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp503.mail.kks.yahoo.co.jp ([114.111.99.164]:27730 "HELO
	smtp503.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751145Ab1L3GxE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 01:53:04 -0500
Message-ID: <4EFD5E3D.8090305@yahoo.co.jp>
Date: Fri, 30 Dec 2011 15:46:21 +0900
From: Akihiro TSUKADA <tskd2@yahoo.co.jp>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: dvbzap application based on DVBv5 API
References: <4EFCC9A7.9050907@redhat.com>
In-Reply-To: <4EFCC9A7.9050907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> [channel name]
> 	property = value
> ...
> 	property = value

Currently, at least gstreamer's dvbbasebin and mplayer assumue that
the channel configuration file has the format of one line per channel.
So when I personally patched them to use v5 parameters,
I chose the one-line-per-channel format of
  <channel name>:propname=val|...|propname=val:<service id>, for example,
 NHKBS1:DTV_DELIVERY_SYSTEM=SYS_ISDBS|DTV_VOLTAGE=1|DTV_FREQUENCY=1318000|DTV_ISDBS_TS_ID=0x40f2:103
, to minimize modification (hopefully).
I understand that it is not that difficult nor complicated 
to adapt applications to use the ini file style format,
but the old one line style format seems slightly easier.

and I wish that the channel configuration can allow nicknames/aliases,
as the canonical channel name can be long to type in or difficult to remember correctly.
If I remember right, MythTV has its own database,
and it would be convenient if we could share the database,
because applications currently have their own channel configuration separately,
and the configuration change like new service or parameter changes must be
propagated manually.

regards,
Akihiro
