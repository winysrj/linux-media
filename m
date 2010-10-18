Return-path: <mchehab@pedra>
Received: from relay01.digicable.hu ([92.249.128.189]:55361 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993Ab0JRTr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 15:47:26 -0400
Message-ID: <4CBCA449.7050600@freemail.hu>
Date: Mon, 18 Oct 2010 21:47:21 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] gspca_sonixj: add hardware vertical flip support
 for hama AC-150
References: <4CBAD911.9070800@freemail.hu> <20101018124440.4dbc2538@tele>
In-Reply-To: <20101018124440.4dbc2538@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jean-Francois,

Jean-Francois Moine wrote:
> On Sun, 17 Oct 2010 13:08:01 +0200
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> The PO2030N sensor chip found in hama AC-150 webcam supports vertical
>> flipping the image by hardware. Add support for this in the
>> gspca_sonixj driver also.
> 	[snip]
> The driver sonixj has changed in staging/2.6.37. I join a new version
> of your patches. May you check it? (when acked, I'll keep you as the
> author of the change)

Looks good. It was a bit tricky for me sometimes to understand the changes
together with the "V4L/DVB: gspca - main: New video control mechanism"
(commit ccbfd092a4199a6fba17273c11c1e0b340d91eb5), but still looks good.

One small thing: the title of the patch shall be changed because this
version contains horizontal and vertical flip also.

Note that I could not run the new driver, yet, together with hama AC-150,
but I hope you could already try whether the new feature is working correctly.

	Márton Németh

