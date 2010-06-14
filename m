Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:39507 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab0FNR2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 13:28:42 -0400
Date: Mon, 14 Jun 2010 19:30:03 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: Krivchikov Sergei <sergei.krivchikov@gmail.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: genius islim 310 webcam test
Message-ID: <20100614193003.00988b97@tele>
In-Reply-To: <4C164387.1000608@freemail.hu>
References: <68c794d61003301249u138e643am20bb264375c3dfe1@mail.gmail.com>
	<4BB2E42B.4090302@freemail.hu>
	<AANLkTikIivyjNkVYlo4CKCJcFK_UW5J28qG48cnWQBm8@mail.gmail.com>
	<4C164387.1000608@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 14 Jun 2010 16:58:15 +0200
Németh Márton <nm127@freemail.hu> wrote:

> Hi Jean-Francois, I got this report about a working Genius iSlim 310
> webcam. Maybe it would be a good idea to add the device 0x093a:0x2625
> in pac7302.c. Should I send a patch for you?

Hi Németh,

OK for the patch. Don't forget to add the webcam in the file
Documentation/video4linux/gspca.txt.

Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
