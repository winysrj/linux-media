Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:57448 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZCSOUi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 10:20:38 -0400
Received: by ewy9 with SMTP id 9so412522ewy.37
        for <linux-media@vger.kernel.org>; Thu, 19 Mar 2009 07:20:35 -0700 (PDT)
Subject: Re: [linux-dvb] EC168 and MT2060
From: "t.Hgch" <pureherz@gmail.com>
Reply-To: pureherz@gmail.com
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Tanguy PRUVOT <tanguy.pruvot@gmail.com>, linux-dvb@linuxtv.org
In-Reply-To: <49BFA8A6.6010909@iki.fi>
References: <1237129041.7993.38.camel@0ri0n> <49BD3B31.8030308@iki.fi>
	 <1237146464.7993.94.camel@0ri0n> <49BD5D0E.3090304@iki.fi>
	 <1237208613.8685.13.camel@0ri0n>
	 <fe7b409d0903160826m23961c90i147661d0fa083c8e@mail.gmail.com>
	 <49BE7031.50005@iki.fi> <1237249937.19477.8.camel@0ri0n>
	 <49BFA8A6.6010909@iki.fi>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 15:20:32 +0100
Message-Id: <1237472432.10547.6.camel@0ri0n>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

I made a change on the tuner parameters and it worked perfectly.

This is the change, on ec168.c, line 245:

	.cap_select      = MXL_CAP_SEL_DISABLE,

So if anyone has a MinTV usb 2.0 DUTV007 dvb-t card an it is not tuning
properly, changing MXL_CAP_SEL_ENABLE to MXL_CAP_SEL_DISABLE could be a
workaround.

Thanks for the help!

Tony Higuchi.



