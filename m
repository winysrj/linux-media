Return-path: <mchehab@pedra>
Received: from relay03.digicable.hu ([92.249.128.185]:45532 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab0JRR76 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 13:59:58 -0400
Message-ID: <4CBC8B19.2070301@freemail.hu>
Date: Mon, 18 Oct 2010 19:59:53 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC] gspca_sonixj: handle return values from USB subsystem
References: <4CBB0BEF.1050005@freemail.hu> <20101018085335.75e6689e@tele>
In-Reply-To: <20101018085335.75e6689e@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
Jean-Francois Moine írta:
> On Sun, 17 Oct 2010 16:45:03 +0200
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> The usb_control_msg() may return error at any time so it is necessary
>> to handle it. The error handling mechanism is taken from the pac7302.
>>
>> The resulting driver was tested with hama AC-150 webcam (USB ID
>> 0c45:6142).
> 
> Hi Németh,
> 
> This mechanism has already been done by commit 60f44336 in
> media_tree.git branch staging/v2.6.37.

I must looking at totally wrong place for my base of changes. Now I
see the branch staging/v2.6.37, thanks for the hint.

	Márton Németh
