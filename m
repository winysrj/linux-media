Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab1L3QuO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 11:50:14 -0500
Message-ID: <4EFDEBB8.1030707@redhat.com>
Date: Fri, 30 Dec 2011 14:50:00 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.3 RESEND] AF9015/AF9013 changes
References: <4EF60396.4000401@iki.fi>
In-Reply-To: <4EF60396.4000401@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24-12-2011 14:53, Antti Palosaari wrote:
> Hello
> I just looked latest for 3.3 and there was 3 patch missing I have already PULL requested.
> 
> Could you PULL those ASAP from that tree:
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/misc
> 
> 2011-11-19 tda18218: fix 6 MHz default IF frequency
> 2011-11-19 af9015: limit I2C access to keep FW happy
> 2011-11-28 af9013: rewrite whole driver

Antti,

Please, don't send pull requests like that. They won't go to my queue, as patchwork
won't get it.

For patchwork to get a git pull request, it has to contain the strings bellow:
	The following changes since commit 1a5cd29631a6b75e49e6ad8a770ab9d69cda0fa2:

	[media] tda10021: Add support for DVB-C Annex C (2011-12-20 14:01:08 -0200)

	are available in the git repository at:
	git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.3

(those are from a real example).

E. g. the pull request should be generated with git request-pull.

This time, I'll get it by hand. I'm assuming that you want me to pull from:
	git://linuxtv.org/anttip/media_tree.git misc

based on the URL you've sent me.

Regards,
Mauro
