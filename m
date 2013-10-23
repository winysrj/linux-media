Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp507.mail.kks.yahoo.co.jp ([114.111.99.156]:38211 "HELO
	smtp507.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750870Ab3JWEPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Oct 2013 00:15:47 -0400
Message-ID: <52674BE0.1040503@yahoo.co.jp>
Date: Wed, 23 Oct 2013 13:09:04 +0900
From: Akihiro TSUKADA <tskd2@yahoo.co.jp>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: =?ISO-2022-JP?B?GyRCJyInZSdVJ1obKEIgGyRCJzInYCdeJ1EnXydkJ2AbKEI=?=
	<knightrider@are.ma>, hdegoede@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com
Subject: Re: [PATCH] Full DVB driver package for Earthsoft PT3 (ISDB-S/ISDB-T)
 cards.
References: <1382463613-29493-1-git-send-email-guest@puma.are.ma>
In-Reply-To: <1382463613-29493-1-git-send-email-guest@puma.are.ma>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
It would be nice if you consider integrating this driver and pt1.
Because PT3 is a PCIe successor of PT2 and designed by the same person,
I guess they can share much code about bridge FPGA chip and
demod IC (tc90512 in PT1/2 and tc90522 in PT3),
though their frontends are obviously different.

regards,
Akihiro
