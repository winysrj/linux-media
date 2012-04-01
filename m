Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:36518 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751085Ab2DAOby (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 10:31:54 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T Stick [0ccd:0093]
Date: Sun, 1 Apr 2012 16:31:47 +0200
Cc: linux-media@vger.kernel.org
References: <4F75A7FE.8090405@iki.fi> <201204011227.18739.hfvogt@gmx.net> <4F784AB3.9070507@iki.fi>
In-Reply-To: <4F784AB3.9070507@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204011631.47333.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti,

I could provide the SNR, BER and UCB implementation (simply porting from my 
draft driver to yours).
But I first need to implement the support for my AverMedia A867R device so that 
I am able to test the implementation. Therefore it could take a few hours 
(maybe until tomorrow).

Regards,
Hans-Frieder

Am Sonntag, 1. April 2012 schrieb Antti Palosaari:
> On 01.04.2012 13:27, Hans-Frieder Vogt wrote:
> > nice work! I'll try to port the features that I have in my implementation
> > of an af9035 driver into yours.
> 
> You are welcome! But please tell me what you are doing to avoid
> duplicate work. My today plan was to implement af9033 SNR, BER, UCB, but
> if you would like to then say it for me and I will jump back to IT9135
> support.
> 
> regards
> Antti


Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
