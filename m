Return-path: <linux-media-owner@vger.kernel.org>
Received: from n12b.bullet.mail.mud.yahoo.com ([209.191.125.179]:32585 "HELO
	n12b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762730AbZFNTsJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 15:48:09 -0400
From: David Brownell <david-b@pacbell.net>
To: davinci-linux-open-source@linux.davincidsp.com,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 7/10 - v2] DM355 platform changes for vpfe capture driver
Date: Sun, 14 Jun 2009 12:42:45 -0700
Cc: m-karicheri2@ti.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	linux-media@vger.kernel.org
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com> <1244739649-27466-8-git-send-email-m-karicheri2@ti.com> <200906141622.55197.hverkuil@xs4all.nl>
In-Reply-To: <200906141622.55197.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906141242.45851.david-b@pacbell.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 14 June 2009, Hans Verkuil wrote:
> >       /* { I2C_BOARD_INFO("tlv320aic3x", 0x1b), }, */
> 
> Huh? What's this? I only know the tlv320aic23b and that's an audio driver.

AIC33 is another audio codec chip:

  http://focus.ti.com/docs/prod/folders/print/tlv320aic33.html

One can't list audio codecs with other board-specific data until
the ASoC initialization gets re-worked to allow it.  That's why
it's commented out of the list-of-i2c-devices-on-the-board.



