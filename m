Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:41410 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab0JRGwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 02:52:43 -0400
Date: Mon, 18 Oct 2010 08:53:35 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC] gspca_sonixj: handle return values from USB
 subsystem
Message-ID: <20101018085335.75e6689e@tele>
In-Reply-To: <4CBB0BEF.1050005@freemail.hu>
References: <4CBB0BEF.1050005@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 17 Oct 2010 16:45:03 +0200
Németh Márton <nm127@freemail.hu> wrote:

> The usb_control_msg() may return error at any time so it is necessary
> to handle it. The error handling mechanism is taken from the pac7302.
> 
> The resulting driver was tested with hama AC-150 webcam (USB ID
> 0c45:6142).

Hi Németh,

This mechanism has already been done by commit 60f44336 in
media_tree.git branch staging/v2.6.37.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
